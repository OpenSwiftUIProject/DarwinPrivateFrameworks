//
//  ValueTracker.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - ValueTracker

package struct ValueTracker<Upstream: GestureComponent, V: Sendable>: Sendable {

    package var upstream: Upstream

    package struct State: GestureComponentState, NestedCustomStringConvertible {
        package var initialValue: V?
        package var previousValue: V?

        package init() {
            initialValue = nil
            previousValue = nil
        }
    }

    package var state: State

    package let valueReader: @Sendable (Upstream.Value) -> V

    package init(
        upstream: Upstream,
        state: State = State(),
        valueReader: @escaping @Sendable (Upstream.Value) -> V
    ) {
        self.upstream = upstream
        self.state = state
        self.valueReader = valueReader
    }
}

// MARK: - ValueTracker + Component Protocols

extension ValueTracker: GestureComponent {
    package typealias Value = TrackedValue<V>
}

extension ValueTracker: CompositeGestureComponent {}

extension ValueTracker: StatefulGestureComponent {}

extension ValueTracker: ValueTransformingComponent {
    package mutating func transform(
        _ value: Upstream.Value,
        isFinal: Bool,
        context: GestureComponentContext
    ) throws -> GestureOutput<Value> {
        let current = valueReader(value)
        if state.initialValue == nil {
            state.initialValue = current
        }
        let previous = state.previousValue ?? state.initialValue!
        let trackedValue = TrackedValue(
            current: current,
            previous: previous,
            initial: state.initialValue!
        )
        state.previousValue = current
        return .value(trackedValue, isFinal: isFinal)
    }
}
