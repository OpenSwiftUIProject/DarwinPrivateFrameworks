//
//  TimeoutComponent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - TimeoutComponent

package struct TimeoutComponent<Upstream>: Sendable where Upstream: GestureComponent {
    package struct State: GestureComponentState, NestedCustomStringConvertible, Sendable {
        package var fulfilled: Bool

        package init() {
            fulfilled = false
        }

        package init(fulfilled: Bool) {
            self.fulfilled = fulfilled
        }
    }

    package var upstream: Upstream
    package var state: State
    package let timeout: Duration
    package let tag: String
    package let predicate: @Sendable (GestureOutput<Upstream.Value>) -> Bool

    package init(
        upstream: Upstream,
        state: State = State(),
        timeout: Duration,
        tag: String,
        predicate: @escaping @Sendable (GestureOutput<Upstream.Value>) -> Bool
    ) {
        self.upstream = upstream
        self.state = state
        self.timeout = timeout
        self.tag = tag
        self.predicate = predicate
    }
}

// MARK: - TimeoutComponent + GestureComponent

extension TimeoutComponent: GestureComponent {
    package typealias Value = ExpirationRecord<Upstream.Value>

    package mutating func update(context: GestureComponentContext) throws -> GestureOutput<Value> {
        let output = try upstream.tracingUpdate(context: context)
        guard output.emptyReason != .noData else {
            return .empty(.noData, metadata: output.metadata)
        }
        return output.expired(with: expiration(for: output, context: context))
    }

    private mutating func expiration(
        for output: GestureOutput<Upstream.Value>,
        context: GestureComponentContext
    ) -> Expiration? {
        guard timeout != .max, !state.fulfilled else {
            return nil
        }

        let deadline = context.startTime + timeout
        if context.currentTime < deadline, predicate(output) {
            state.fulfilled = true
            return nil
        }
        return Expiration(
            deadline: deadline,
            reason: ExpirationReason(rawValue: tag)
        )
    }
}

// MARK: - TimeoutComponent + Component Protocols

extension TimeoutComponent: CompositeGestureComponent {}

extension TimeoutComponent: StatefulGestureComponent {}
