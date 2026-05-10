//
//  RepeatComponent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - RepeatComponent

package struct RepeatComponent<Upstream>: Sendable where Upstream: GestureComponent {
    package struct State: GestureComponentState, NestedCustomStringConvertible, Sendable {
        package var currentCount: Int
        package var repeatDeadline: Timestamp?
        package var repeatStartTime: Timestamp?

        package init() {
            currentCount = 0
            repeatDeadline = nil
            repeatStartTime = nil
        }

        package init(
            currentCount: Int,
            repeatDeadline: Timestamp?,
            repeatStartTime: Timestamp?
        ) {
            self.currentCount = currentCount
            self.repeatDeadline = repeatDeadline
            self.repeatStartTime = repeatStartTime
        }

        package var repeatExpiration: Expiration? {
            guard let repeatDeadline else {
                return nil
            }
            return Expiration(
                deadline: repeatDeadline,
                reason: "Repeat deadline expired"
            )
        }
    }

    package var upstream: Upstream
    package var state: State
    package let count: Int
    package let delay: Duration

    package init(
        upstream: Upstream,
        state: State = State(),
        count: Int,
        delay: Duration
    ) {
        self.upstream = upstream
        self.state = state
        self.count = count
        self.delay = delay
    }
}

// MARK: - RepeatComponent + GestureComponent

extension RepeatComponent: GestureComponent {
    package typealias Value = ExpirationRecord<Upstream.Value>

    package mutating func update(context: GestureComponentContext) throws -> GestureOutput<Value> {
        if state.currentCount > 0,
           state.repeatStartTime == nil,
           case .event = context.updateSource {
            state.repeatStartTime = context.currentTime
        }
        var newContext = context
        if let repeatStartTime = state.repeatStartTime {
            newContext.startTime = repeatStartTime
        }
        let output = try upstream.tracingUpdate(context: newContext)
        guard let value = output.value else {
            return .empty(output.emptyReason!, metadata: output.metadata)
        }
        var newOutput = Self.makeExpirationOutputForNonEmptyOutput(
            output,
            repeatComponent: &self,
            value: value,
            context: context
        )
        newOutput.metadata = output.metadata ?? GestureOutputMetadata()
        return newOutput
    }

    private static func makeExpirationOutputForNonEmptyOutput(
        _ output: GestureOutput<Upstream.Value>,
        repeatComponent: inout Self,
        value: Upstream.Value,
        context: GestureComponentContext
    ) -> GestureOutput<Value> {
        guard output.isFinal else {
            return GestureOutput<Upstream.Value>.value(
                value,
                isFinal: false,
                expiration: repeatComponent.state.repeatExpiration
            )
        }
        repeatComponent.state.currentCount += 1
        guard repeatComponent.state.currentCount < repeatComponent.count else {
            return GestureOutput<Upstream.Value>
                .finalValue(value, metadata: nil)
                .expired(with: nil)
        }
        repeatComponent.upstream.reset()
        repeatComponent.state.repeatStartTime = nil
        let repeatDeadline = context.currentTime + repeatComponent.delay
        repeatComponent.state.repeatDeadline = repeatDeadline
        return GestureOutput<Upstream.Value>.value(
            value,
            isFinal: false,
            expiration: repeatComponent.state.repeatExpiration
        )
    }
}

// MARK: - RepeatComponent + Component Protocols

extension RepeatComponent: CompositeGestureComponent {}

extension RepeatComponent: StatefulGestureComponent {}
