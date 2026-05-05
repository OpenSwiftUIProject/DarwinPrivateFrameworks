//
//  GestureComponentController.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import Dispatch

// MARK: - GestureComponentController

public final class GestureComponentController<Component: GestureComponent>: AnyGestureComponentController, @unchecked Sendable {

    private var component: Component
    private let timeScheduler: any TimeScheduler
    private var eventStores: [ObjectIdentifier: AnyEventStore] = [:]
    private var _traits: GestureTraitCollection?
    private var startTime: Timestamp?
    private var updateListener: ((Result<GestureOutput<Component.Value>, any Error>) -> Void)?
    private lazy var updateTracer: UpdateTracer? = UpdateTracer()
    private lazy var updateScheduler = UpdateScheduler(
        timeScheduler: timeScheduler,
        scheduledRequests: [:]
    )

    public init(component: Component, timeScheduler: any TimeScheduler) {
        self.component = component
        self.timeScheduler = timeScheduler
        super.init()
    }

    public convenience init(component: Component) {
        self.init(
            component: component,
            timeScheduler: DispatchTimeScheduler(queue: .main, timeSource: UptimeTimeSource())
        )
    }

    public override var traits: GestureTraitCollection? {
        if _traits == nil {
            _traits = component.traits()
        }
        return _traits
    }

    public override var timeSource: any TimeSource {
        timeScheduler
    }

    public override func canHandleEvents<E: Event>(ofType: E.Type, count: Int) -> Bool {
        component.capacity(for: ofType) >= count
    }

    public override func handleEvents<E: Event>(_ events: [E]) throws {
        let store = eventStore(for: E.self)
        store.append(events)
        if startTime == nil {
            startTime = timeScheduler.timestamp
        }
        try performUpdate(updateSource: .event, eventType: E.self)
        store.removeUnboundTerminalEvents()
    }

    public override func reset() {
        updateScheduler.cancelAll()
        for store in eventStores.values {
            store.unbindAll()
        }
        component.reset()
        _traits = nil
        startTime = nil
    }

    private func eventStore<E: Event>(for eventType: E.Type) -> AnyEventStore {
        let key = ObjectIdentifier(eventType)
        if let store = eventStores[key] {
            return store
        }
        let store = EventStore<E>()
        eventStores[key] = store
        return store
    }

    private func performUpdate<E: Event>(
        updateSource: GestureUpdateSource,
        eventType: E.Type
    ) throws {
        let context = GestureComponentContext(
            startTime: startTime!,
            currentTime: timeScheduler.timestamp,
            updateSource: updateSource,
            updateTracer: updateTracer,
            eventStore: eventStore(for: eventType)
        )
        let result = component.tracingUpdateResult(context: context)
        if let updateTracer {
            updateTracer.logTrace()
            updateTracer.reset()
        }
        if let output = try? result.get() {
            try applyOutputMetadata(output, eventType: eventType)
        }
        if let node {
            try dispatch(node, result: result)
        }
        updateListener?(result)
    }

    private func applyOutputMetadata<E: Event>(
        _ output: GestureOutput<Component.Value>,
        eventType: E.Type
    ) throws {
        guard let metadata = output.metadata else {
            return
        }
        if !metadata.updatesToSchedule.isEmpty {
            updateScheduler.schedule(
                metadata.updatesToSchedule,
                handler: { [weak self] requestIDs in
                    guard let self else {
                        return
                    }
                    performScheduledUpdate(requestIDs, eventType: eventType)
                },
                cancelHandler: nil
            )
        }
        if !metadata.updatesToCancel.isEmpty {
            updateScheduler.cancel(metadata.updatesToCancel)
        }
    }

    private func performScheduledUpdate<E: Event>(
        _ requestIDs: Set<UInt32>,
        eventType: E.Type
    ) {
        do {
            try performUpdate(
                updateSource: .scheduler(requestIDs),
                eventType: eventType
            )
        } catch {
            Log.logFailedScheduledUpdate()
        }
    }

    private func dispatch(
        _ node: AnyGestureNode,
        result: Result<GestureOutput<Component.Value>, any Error>
    ) throws {
        switch result {
        case let .success(output):
            if let value = output.value {
                try node.update(someValue: value, isFinalUpdate: output.isFinal)
            }
        case let .failure(error):
            try node.update(reason: .custom(error), isFinalUpdate: false)
        }
    }
}

// MARK: - AnyGestureComponentController

open class AnyGestureComponentController: @unchecked Sendable {

    open weak var node: AnyGestureNode?

    open var traits: GestureTraitCollection? {
        _gesturesBaseClassAbstractMethod()
    }

    open var timeSource: any TimeSource {
        _gesturesBaseClassAbstractMethod()
    }

    open func canHandleEvents<E: Event>(ofType: E.Type, count: Int) -> Bool {
        _gesturesBaseClassAbstractMethod()
    }

    open func canHandleEvent<E: Event>(_ event: E) -> Bool {
        _gesturesBaseClassAbstractMethod()
    }

    open func handleEvents<E: Event>(_ events: [E]) throws {
        _gesturesBaseClassAbstractMethod()
    }

    open func reset() {
        _gesturesBaseClassAbstractMethod()
    }

    package init() {}
}
