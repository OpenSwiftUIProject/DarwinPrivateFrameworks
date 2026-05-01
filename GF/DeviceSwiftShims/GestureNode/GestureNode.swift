//
//  GestureNode.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: WIP

import Foundation
import Synchronization

// MARK: - AnyGestureNode

/// Type-erased base class for gesture nodes.
open class AnyGestureNode: Identifiable, @unchecked Sendable {

    // MARK: - Static ID counter

    /// Monotonically increasing node-ID allocator. Backed by a lock-free
    /// `Atomic<UInt32>` with trap-on-overflow semantics.
    private static let counter = Atomic<UInt32>(0)

    @inline(__always)
    private static func makeUniqueID() -> UInt32 {
        let (_, id) = counter.add(1, ordering: .relaxed)
        return id
    }

    // MARK: - Stored Properties

    public let id: GestureNodeID = GestureNodeID(rawValue: makeUniqueID())
    public var tag: GestureTag?
    public var traits: GestureTraitCollection?
    open var options: GestureNodeOptions = []
    open weak var container: (any GestureNodeContainer)?
    package var timeSource: (any TimeSource)?
    package unowned var context: AnyObject?
    package var debugLabelProvider: ((AnyGestureNode) -> String)?
    package unowned var listener: (any GestureNodeListener)?
    package var relationMap: RelationMap = RelationMap()
    package var trackedEvents: Set<EventID> = []

    // MARK: - Init [WIP]

    package init(
        traits: GestureTraitCollection? = nil,
        tag: GestureTag? = nil,
        relations: [GestureRelation] = []
    ) {
        self.tag = tag
        self.traits = traits
        for relation in relations {
            addRelation(relation)
        }
    }

    // MARK: - Relations

    open var relations: [GestureRelation] {
        relationMap.toRelations()
    }

    open func addRelation(_ relation: GestureRelation) {
        relationMap.addRelation(relation)
    }

    open func removeRelation(_ relation: GestureRelation) {
        relationMap.removeRelation(relation)
    }

    open func addRelations(_ relations: [GestureRelation]) {
        for relation in relations {
            addRelation(relation)
        }
    }

    open func removeRelations(_ relations: [GestureRelation]) {
        for relation in relations {
            removeRelation(relation)
        }
    }

    // MARK: - Event Tracking

    public func startTrackingEvents(with eventIDs: [EventID]) {
        for id in eventIDs {
            trackedEvents.insert(id)
        }
    }

    public func stopTrackingEvents(with eventIDs: [EventID]) {
        for id in eventIDs {
            trackedEvents.remove(id)
        }
    }

    // MARK: - Update / Abort / Fail

    /// Type-erased update. Subclass (`GestureNode<Value>`) overrides.
    open func update<T>(someValue: T, isFinalUpdate: Bool) throws {
        _gesturesBaseClassAbstractMethod()
    }

    /// Fails the gesture with an error.
    open func fail(with error: Error) throws {
        _gesturesBaseClassAbstractMethod()
    }

    package func update(reason: GestureFailureReason, isFinalUpdate: Bool) throws {
        _gesturesBaseClassAbstractMethod()
    }

    @discardableResult
    package func processPendingPhaseUpdates() -> Bool {
        _gesturesBaseClassAbstractMethod()
    }

    /// Aborts the gesture.
    public final func abort() throws {
        try update(reason: .aborted, isFinalUpdate: true)
    }

    // MARK: - Debug

    public final var debugLabel: String {
        var parts: [String] = []
        let label: String
        if let debugLabelProvider {
            label = debugLabelProvider(self)
        } else {
            let address = String(UInt(bitPattern: ObjectIdentifier(self)), radix: 16, uppercase: false)
            label = "\(type(of: self)): 0x\(address)"
        }
        parts.append(label)
        if let tag {
            parts.append(tag.description)
        }
        var pairs: [(String, String)] = []
        pairs.append(("id", id.description))
        pairs.append(("phase", describePhaseQueue()))
        let header = parts.joined(separator: " ")
        var pairStrings: [String] = []
        for pair in pairs {
            pairStrings.append(pair.0 + " = " + pair.1)
        }
        return "<" + header + "; " + pairStrings.joined(separator: "; ") + ">"
    }

    /// Overridable hook providing the `phase = …` fragment of ``debugLabel``.
    /// `GestureNode<Value>` overrides this to describe its phase queue.
    package func describePhaseQueue() -> String {
        ""
    }
}

// MARK: - Hashable / Comparable

extension AnyGestureNode: Hashable {
    public static func == (lhs: AnyGestureNode, rhs: AnyGestureNode) -> Bool {
        lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension AnyGestureNode: Comparable {
    public static func < (lhs: AnyGestureNode, rhs: AnyGestureNode) -> Bool {
        guard let lhsContainer = lhs.container,
              let rhsContainer = rhs.container else {
            return rhs.container != nil
        }
        guard lhsContainer === rhsContainer else {
            return rhsContainer.isDeeper(than: lhsContainer, referenceNode: lhs)
        }
        guard let lhsIndex = lhsContainer.index(of: lhs),
              let rhsIndex = rhsContainer.index(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}

// MARK: - GestureNode [WIP]

/// A concrete gesture node with a typed Value.
public class GestureNode<Value: Sendable>: AnyGestureNode, @unchecked Sendable {

    // MARK: - Stored Properties

    public weak var delegate: (any GestureNodeDelegate<Value>)?

    private var phaseQueue: GesturePhaseQueue<Value>

    // MARK: - Init

    /// Designated initializer. Initializes `GestureNode<Value>`-specific
    /// fields in this order:
    /// 1. `delegate = nil`
    /// 2. `phaseQueue = .init()` (default `.idle` + empty 5-slot ring buffer)
    /// 3. `super.init(traits:tag:relations:)`
    public override init(
        traits: GestureTraitCollection?,
        tag: GestureTag?,
        relations: [GestureRelation]
    ) {
        delegate = nil
        phaseQueue = .init()
        super.init(traits: traits, tag: tag, relations: relations)
    }

    /// Zero-arg convenience initializer. Forwards to the designated
    /// initializer with `traits: nil`, `tag: nil`, and
    /// `relations: .default`.
    public convenience init() {
        self.init(traits: nil, tag: nil, relations: .default)
    }

    public override var options: GestureNodeOptions {
        get { super.options }
        set {
            let oldValue = super.options
            super.options = newValue
            didChangeOptions(from: oldValue)
        }
    }

    private func didChangeOptions(from oldOptions: GestureNodeOptions) {
        guard options.contains(.isDisabled) != oldOptions.contains(.isDisabled) else { return }
        try? update(reason: .disabled, isFinalUpdate: true)
    }

    public override var container: (any GestureNodeContainer)? {
        get { super.container }
        set {
            super.container = newValue
            didChangeContainer()
        }
    }

    private func didChangeContainer() {
        guard container == nil else { return }
        try? update(reason: .removedFromContainer, isFinalUpdate: true)
    }

    // MARK: - Phase

    /// The currently committed phase, as observed after the last
    /// `processUpdates` drain.
    public var phase: GesturePhase<Value> {
        phaseQueue.currentPhase
    }

    /// The most recently enqueued phase. May differ from `phase` between
    /// `enqueueUpdates` and the next `processUpdates` drain.
    public var latestPhase: GesturePhase<Value> {
        phaseQueue.latestPhase
    }

    // MARK: - Relations

    public override var relations: [GestureRelation] {
        relationMap.toRelations()
    }

    /// Override that augments the base-class map mutation with a
    /// failure-dependency propagation pass. Apple's thunk at 0x26480
    /// tail-calls a shared dispatcher with two function pointers:
    /// the RelationMap add op and a free function
    /// `_cc_confirmed_GestureNode_addRelation_failureDeps_update` (0x55eb0).
    /// The worker (0x272f8) then:
    ///   1. Calls the op to mutate `self.relationMap`; it returns whether
    ///      the map actually changed.
    ///   2. If unchanged -> return.
    ///   3. Loads `self.listener` via `swift_unknownObjectUnownedLoadStrong`.
    ///   4. If listener is nil -> return.
    ///   5. Invokes the failureDeps update function with `x20 = listener`,
    ///      passing `(relation, self, matcher)`. That function early-exits
    ///      unless `relation.type == .failureRequirement`; otherwise it walks
    ///      the listener's node collection and updates its failure-dependency
    ///      graph.
    /// TODO: Once `GestureNodeCoordinator` owns the failure-dep graph,
    /// route this tail through the listener's concrete update method.
    public override func addRelation(_ relation: GestureRelation) {
        let changed = relationMap.addRelation(relation)
        guard changed, listener != nil else { return }
        // TODO: listener.updateFailureDependencies(forAdded: relation,
        //                                         on: self,
        //                                         target: relation.target)
    }

    public override func addRelations(_ relations: [GestureRelation]) {
        for relation in relations {
            addRelation(relation)
        }
    }

    /// Symmetric to ``addRelation(_:)``. Apple's thunk at 0x27268 passes the
    /// RelationMap remove op and the free function
    /// `_cc_confirmed_GestureNode_removeRelation_failureDeps_update` (0x56598)
    /// into the same dispatcher. That update function also early-exits unless
    /// `relation.type == .failureRequirement`.
    public override func removeRelation(_ relation: GestureRelation) {
        let changed = relationMap.removeRelation(relation)
        guard changed, listener != nil else { return }
        // TODO: listener.updateFailureDependencies(forRemoved: relation,
        //                                         on: self,
        //                                         target: relation.target)
    }

    public override func removeRelations(_ relations: [GestureRelation]) {
        for relation in relations {
            removeRelation(relation)
        }
    }

    // MARK: - Update

    public func update(value: Value, isFinalUpdate: Bool) throws {
        try update(
            value: value,
            isFinalUpdate: isFinalUpdate,
            synchronously: false
        )
    }

    public override func update<T>(someValue: T, isFinalUpdate: Bool) throws {
        try update(
            value: unsafeBitCast(someValue, to: Value.self),
            isFinalUpdate: isFinalUpdate,
            synchronously: false
        )
    }

    private func update(value: Value, isFinalUpdate: Bool, synchronously: Bool) throws {
        let newPhase: GesturePhase<Value> = isFinalUpdate ? .ended(value: value) : .active(value: value)
        try enqueuePhase(newPhase, synchronousUpdate: synchronously)
    }

    public override func fail(with error: Error) throws {
        try update(reason: .custom(error), isFinalUpdate: false)
    }

    package override func update(reason: GestureFailureReason, isFinalUpdate: Bool) throws {
        try enqueuePhase(.failed(reason: reason), synchronousUpdate: isFinalUpdate)
    }

    private func enqueuePhase(_ phase: GesturePhase<Value>, synchronousUpdate: Bool) throws {
        var phase = phase
        if let delegate, phase.isRecognized, phaseQueue.latestPhase.isPossible {
            let shouldActivate = delegate.gestureNodeShouldActivate(self)
            if !shouldActivate {
                phase = .failed(reason: .activationDenied)
            }
        }
        try phaseQueue.enqueue(phase)
        Log.logEnqueuedPhase(self)
        listener?.gestureNode(self, didEnqueuePhaseWithSynchronousUpdate: synchronousUpdate)
        delegate?.gestureNode(self, didEnqueuePhase: phase)
    }

    @discardableResult
    package override func processPendingPhaseUpdates() -> Bool {
        var didProcess = false
        while let transition = phaseQueue.processNextPhase() {
            delegate?.gestureNode(
                self,
                didUpdatePhase: transition.newPhase,
                oldPhase: transition.oldPhase
            )
            didProcess = true
        }
        return didProcess
    }

    // MARK: - Debug

    package override func describePhaseQueue() -> String {
        "\(phaseQueue.currentPhase)"
    }
}
