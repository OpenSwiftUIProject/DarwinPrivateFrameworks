//
//  GestureComponent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - GestureComponent

/// A protocol for gesture recognition components.
public protocol GestureComponent: Sendable {
    associatedtype Value: Sendable
    mutating func update(context: GestureComponentContext) throws -> GestureOutput<Value>
    mutating func reset()
    func traits() -> GestureTraitCollection?
    func capacity<E: Event>(for eventType: E.Type) -> Int
}

// MARK: - GestureComponent + Tracing

extension GestureComponent {
    package mutating func tracingUpdateResult(
        context: GestureComponentContext
    ) -> Result<GestureOutput<Value>, any Error> {
        Result {
            try tracingUpdate(context: context)
        }
    }

    package mutating func tracingUpdate(context: GestureComponentContext) throws -> GestureOutput<Value> {
        guard let updateTracer = context.updateTracer else {
            return try update(context: context)
        }

        updateTracer.beginTrace()
        let result: Result<GestureOutput<Value>, any Error> = Result {
            try update(context: context)
        }
        let snapshot = makeTraceDataSnapshot(result: result)
        updateTracer.endTrace(snapshot: snapshot)
        return try result.get()
    }

    private mutating func makeTraceDataSnapshot(
        result: Result<GestureOutput<Value>, any Error>
    ) -> TraceDataSnapshot {
        let componentDescription = String(describing: self)
        let resultDescription = String(describing: result)
        let stateDescription: String
        if let stateful = self as? any StatefulGestureComponent {
            stateDescription = String(describing: stateful.state)
        } else {
            stateDescription = ""
        }
        return TraceDataSnapshot(
            component: { componentDescription },
            result: { resultDescription },
            state: { stateDescription },
            isSuccess: {
                switch result {
                case .success: true
                case .failure: false
                }
            }()
        )
    }
}

extension CompositeGestureComponent {
    public mutating func update(
        context: GestureComponentContext
    ) throws -> GestureOutput<Upstream.Value> {
        try upstream.tracingUpdate(context: context)
    }
}

// MARK: - GestureComponentContext

/// Context passed to gesture components during update cycles.
public struct GestureComponentContext: @unchecked Sendable {
    public var startTime: Timestamp
    public var currentTime: Timestamp
    package var updateSource: GestureUpdateSource
    package var updateTracer: UpdateTracer?
    package var eventStore: AnyEventStore

    public var durationSinceStart: Duration {
        startTime.duration(to: currentTime)
    }

    package init(
        startTime: Timestamp,
        currentTime: Timestamp,
        updateSource: GestureUpdateSource,
        updateTracer: UpdateTracer? = nil,
        eventStore: AnyEventStore
    ) {
        self.startTime = startTime
        self.currentTime = currentTime
        self.updateSource = updateSource
        self.updateTracer = updateTracer
        self.eventStore = eventStore
    }
}

// MARK: - GestureUpdateSource

/// Source that caused a gesture component update cycle.
package enum GestureUpdateSource: Equatable, Sendable {
    /// Scheduler-driven update carrying the scheduled request identifiers.
    case scheduler(Set<UInt32>)

    /// Event-driven update.
    case event
}
