//
//  ReduceComponent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - ReduceComponent

package struct ReduceComponent<Upstream, Output>: Sendable
where Upstream: GestureComponent, Output: Sendable {
    package struct State: GestureComponentState, NestedCustomStringConvertible {
        package var accumulator: Output?

        package init() {
            accumulator = nil
        }
    }

    package var upstream: Upstream
    package var state: State
    package let initial: Output
    package let reduce: @Sendable (Output, Upstream.Value) throws -> Output

    package init(
        upstream: Upstream,
        state: State = State(),
        initial: Output,
        reduce: @escaping @Sendable (Output, Upstream.Value) throws -> Output
    ) {
        self.upstream = upstream
        self.state = state
        self.initial = initial
        self.reduce = reduce
    }
}

// MARK: - ReduceComponent + Component Protocols

extension ReduceComponent: GestureComponent {
    package typealias Value = Output
}

extension ReduceComponent: CompositeGestureComponent {}

extension ReduceComponent: StatefulGestureComponent {}

extension ReduceComponent: ValueTransformingComponent {
    package mutating func transform(
        _ value: Upstream.Value,
        isFinal: Bool,
        context: GestureComponentContext
    ) throws -> GestureOutput<Value> {
        let previous = state.accumulator ?? initial
        state.accumulator = try reduce(previous, value)
        return .value(state.accumulator!, isFinal: isFinal)
    }
}
