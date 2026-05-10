//
//  VelocityComponent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - VelocityComponent

package struct VelocityComponent<Upstream>: Sendable
where Upstream: GestureComponent,
      Upstream.Value: VectorContaining,
      Upstream.Value.VectorType: Interpolatable
{
    package struct State: GestureComponentState, NestedCustomStringConvertible {
        package var previousValue: Upstream.Value.VectorType?
        package var previousVelocity: Upstream.Value.VectorType?
        package var previousTime: Timestamp?

        package init() {
            previousValue = nil
            previousVelocity = nil
            previousTime = nil
        }

        package init(
            previousValue: Upstream.Value.VectorType?,
            previousVelocity: Upstream.Value.VectorType?,
            previousTime: Timestamp?
        ) {
            self.previousValue = previousValue
            self.previousVelocity = previousVelocity
            self.previousTime = previousTime
        }
    }

    package var upstream: Upstream
    package var state: State
    package let interpolationWeight: Double

    package init(
        upstream: Upstream,
        state: State = State(),
        interpolationWeight: Double
    ) {
        self.upstream = upstream
        self.state = state
        self.interpolationWeight = interpolationWeight
    }
}

// MARK: - VelocityComponent + Component Protocols

extension VelocityComponent: GestureComponent {
    package typealias Value = (value: Upstream.Value, velocity: Upstream.Value.VectorType)
}

extension VelocityComponent: CompositeGestureComponent {}

extension VelocityComponent: StatefulGestureComponent {}

extension VelocityComponent: ValueTransformingComponent {
    package mutating func transform(
        _ value: Upstream.Value,
        isFinal: Bool,
        context: GestureComponentContext
    ) throws -> GestureOutput<Value> {
        let currentVector = value.vector
        var velocity = makeRawVelocity(
            currentVector: currentVector,
            currentTime: context.currentTime
        )
        if let previousVelocity = state.previousVelocity {
            velocity.mix(with: previousVelocity, by: interpolationWeight)
        }

        state.previousValue = currentVector
        state.previousVelocity = velocity
        state.previousTime = context.currentTime

        let result = (value: value, velocity: velocity)
        return .value(result, isFinal: isFinal)
    }

    private func makeRawVelocity(
        currentVector: Upstream.Value.VectorType,
        currentTime: Timestamp
    ) -> Upstream.Value.VectorType {
        guard let previousValue = state.previousValue,
              let previousTime = state.previousTime else {
            return .zero
        }

        let elapsed = previousTime.duration(to: currentTime)
        guard elapsed >= .milliseconds(1) else {
            return .zero
        }

        let movement = currentVector - previousValue
        return movement.scaled(byInverseOf: elapsed.asTimeInterval())
    }

    package mutating func transform2(
        _ value: Upstream.Value,
        isFinal: Bool,
        context: GestureComponentContext
    ) throws -> GestureOutput<Value> {
        let currentTime = context.currentTime
        var velocity = Upstream.Value.VectorType.zero
        if let previousValue = state.previousValue,
           let previousTime = state.previousTime {
            let elapsed = previousTime.duration(to: currentTime)
            if elapsed >= .milliseconds(1) {
                let movement = value.vector - previousValue
                velocity = movement.scaled(byInverseOf: elapsed.asTimeInterval())
            }
        }
        if let previousVelocity = state.previousVelocity {
            velocity.mix(with: previousVelocity, by: interpolationWeight)
        }
        state.previousValue = value.vector
        state.previousVelocity = velocity
        state.previousTime = currentTime

        let result = (value: value, velocity: velocity)
        return .value(result, isFinal: isFinal)
    }
}
