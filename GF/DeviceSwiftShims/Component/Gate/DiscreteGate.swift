//
//  DiscreteGate.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - DiscreteGate

package struct DiscreteGate<Upstream: GestureComponent>: Sendable {
    package var upstream: Upstream

    package init(upstream: Upstream) {
        self.upstream = upstream
    }
}

// MARK: - DiscreteGate + GestureComponent

extension DiscreteGate: GestureComponent {
    package typealias Value = Upstream.Value
}

// MARK: - DiscreteGate + CompositeGestureComponent

extension DiscreteGate: CompositeGestureComponent {}

// MARK: - DiscreteGate + DiscreteComponent

extension DiscreteGate: DiscreteComponent {}

// MARK: - DiscreteGate + ValueTransformingComponent

extension DiscreteGate: ValueTransformingComponent {
    package mutating func transform(
        _ value: Value,
        isFinal: Bool,
        context: GestureComponentContext
    ) throws -> GestureOutput<Value> {
        if isFinal {
            return .finalValue(value, metadata: nil)
        } else {
            return .empty(
                .filtered,
                metadata: GestureOutputMetadata(
                    traceAnnotation: UpdateTraceAnnotation(value: "not final event")
                )
            )
        }
    }
}
