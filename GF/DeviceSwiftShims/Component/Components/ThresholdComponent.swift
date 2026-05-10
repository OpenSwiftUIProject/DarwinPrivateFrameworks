//
//  ThresholdComponent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - ThresholdComponent

package struct ThresholdComponent<Upstream>: Sendable
where Upstream: GestureComponent,
      Upstream.Value: ThresholdAdjustable,
      Upstream.Value.VectorType: Sendable
{
    package struct State: GestureComponentState, NestedCustomStringConvertible {
        package var initialValue: Upstream.Value?

        package var adjustmentDelta: Upstream.Value.VectorType?

        package init() {
            initialValue = nil
            adjustmentDelta = nil
        }

        package init(
            initialValue: Upstream.Value?,
            adjustmentDelta: Upstream.Value.VectorType?
        ) {
            self.initialValue = initialValue
            self.adjustmentDelta = adjustmentDelta
        }
    }

    package enum Failure: Error, Hashable, Sendable {
        case notEnoughMovement
    }

    package var upstream: Upstream

    package var state: State

    package let threshold: @Sendable (Upstream.Value, Upstream.Value) -> Upstream.Value.Threshold

    package init(
        upstream: Upstream,
        state: State = State(),
        threshold: @escaping @Sendable (Upstream.Value, Upstream.Value) -> Upstream.Value.Threshold
    ) {
        self.upstream = upstream
        self.state = state
        self.threshold = threshold
    }
}

// MARK: - ThresholdComponent + Component Protocols

extension ThresholdComponent: GestureComponent {
    package typealias Value = Upstream.Value
}

extension ThresholdComponent: CompositeGestureComponent {}

extension ThresholdComponent: StatefulGestureComponent {}

extension ThresholdComponent: ValueTransformingComponent {
    package mutating func transform(
        _ value: Upstream.Value,
        isFinal: Bool,
        context: GestureComponentContext
    ) throws -> GestureOutput<Value> {
        if state.initialValue == nil {
            state.initialValue = value
        }
        let initialValue = state.initialValue!
        guard let adjustmentDelta = state.adjustmentDelta else {
            guard !isFinal else {
                throw Failure.notEnoughMovement
            }
            var adjustedValue = value
            guard let adjustmentDelta = adjustedValue.consume(
                threshold(value, initialValue),
                from: value.vector - initialValue.vector
            ) else {
                return .empty(
                    .filtered,
                    metadata: GestureOutputMetadata(
                        traceAnnotation: UpdateTraceAnnotation(value: "not enough movement")
                    )
                )
            }
            state.adjustmentDelta = adjustmentDelta
            return .value(adjustedValue, isFinal: false)
        }
        var adjustedValue = value
        adjustedValue.vector -= adjustmentDelta
        return .value(adjustedValue, isFinal: isFinal)
    }
}
