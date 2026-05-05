//
//  EventStore.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - AnyEventStore

/// Type-erased base class for per-event-type event stores.
package class AnyEventStore: @unchecked Sendable {
    package init() {}

    package func accepts<E: Event>(_ eventType: E.Type) -> Bool {
        _gesturesBaseClassAbstractMethod()
    }

    package func append<E: Event>(_ events: [E]) {
        _gesturesBaseClassAbstractMethod()
    }

    package func removeUnboundTerminalEvents() {
        _gesturesBaseClassAbstractMethod()
    }

    package func unbindAll() {
        _gesturesBaseClassAbstractMethod()
    }
}

// MARK: - EventStore

/// Concrete per-event-type event store.
package final class EventStore<E: Event>: AnyEventStore, @unchecked Sendable {
    package var events: [E]
    package var boundEventIds: [EventID]

    package init(events: [E] = [], boundEventIds: [EventID] = []) {
        self.events = events
        self.boundEventIds = boundEventIds
        super.init()
    }

    package override func accepts<A: Event>(_ eventType: A.Type) -> Bool {
        eventType == E.self
    }

    package override func append<A: Event>(_ newEvents: [A]) {
        removeUnboundTerminalEvents()

        for event in newEvents {
            let isBound = boundEventIds.contains(event.id)
            let phase = event.phase
            guard isBound || phase == .began else {
                continue
            }
            events.append(unsafeBitCast(event, to: E.self))
        }
    }

    package func bindNextUnboundEvent() -> E? {
        guard let event = events.first(where: eventIDIsUnbound) else {
            return nil
        }
        boundEventIds.append(event.id)
        return event
    }

    private func eventIDIsUnbound(_ event: E) -> Bool {
        !boundEventIds.contains(event.id)
    }

    package override func removeUnboundTerminalEvents() {
        for event in events {
            guard event.phase == .ended || event.phase == .failed else {
                continue
            }
            if let index = boundEventIds.firstIndex(of: event.id) {
                boundEventIds.remove(at: index)
            }
        }
        events.removeAll(keepingCapacity: false)
    }

    package override func unbindAll() {
        events.removeAll(keepingCapacity: false)
        boundEventIds = []
    }
}

// MARK: - EventStore + NestedCustomStringConvertible

extension EventStore: NestedCustomStringConvertible {}
