//
//  EventSource.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - EventSource

package struct EventSource<E: Event>: Sendable {
    package enum Failure: Error, Hashable, Sendable {
        case eventFailed
    }

    package struct State: GestureComponentState, NestedCustomStringConvertible, Sendable {
        package var trackedId: EventID?

        package init() {
            trackedId = nil
        }

        package init(trackedId: EventID?) {
            self.trackedId = trackedId
        }
    }

    package var state: State

    package init(state: State = State()) {
        self.state = state
    }
}

// MARK: - EventSource + GestureComponent

extension EventSource: GestureComponent {
    package typealias Value = E

    package mutating func update(
        context: GestureComponentContext
    ) throws -> GestureOutput<E> {
        guard context.updateSource == .event else {
            return .empty(.timeUpdate, metadata: nil)
        }
        guard let store = matchingEventStore(context: context) else {
            return makeEmptyOutput(traceAnnotation: "no event")
        }
        let event: E?
        if let trackedId = state.trackedId {
            event = trackedEvent(in: store, matching: trackedId)
        } else {
            event = store.bindNextUnboundEvent()
            if let event {
                state.trackedId = event.id
            }
        }
        guard let event else {
            if state.trackedId == nil {
                return makeEmptyOutput(
                    traceAnnotation: "no unbound events"
                )
            } else {
                return makeEmptyOutput(
                    traceAnnotation: "source is already bound"
                )
            }
        }
        return try makeOutputForEvent(event)
    }

    private func trackedEvent(
        in store: EventStore<E>,
        matching trackedId: EventID
    ) -> E? {
        return store.events.first { $0.id == trackedId }
    }

    private func matchingEventStore(
        context: GestureComponentContext
    ) -> EventStore<E>? {
        guard context.eventStore.accepts(E.self) else {
            return nil
        }
        return unsafeDowncast(context.eventStore, to: EventStore<E>.self)
    }

    private func makeOutputForEvent(_ event: E) throws -> GestureOutput<E> {
        switch event.phase {
        case .began, .active:
            return .value(event, metadata: nil)
        case .ended:
            return .finalValue(event, metadata: nil)
        case .failed:
            throw Failure.eventFailed
        }
    }

    private func makeEmptyOutput(traceAnnotation: String) -> GestureOutput<E> {
        .empty(
            .noData,
            metadata: GestureOutputMetadata(
                traceAnnotation: UpdateTraceAnnotation(value: traceAnnotation)
            )
        )
    }

    package func traits() -> GestureTraitCollection? {
        nil
    }

    package func capacity<EventType: Event>(for eventType: EventType.Type) -> Int {
        if state.trackedId == nil, eventType == E.self {
            return 1
        }
        return 0
    }
}

// MARK: - EventSource + StatefulGestureComponent

extension EventSource: StatefulGestureComponent {}
