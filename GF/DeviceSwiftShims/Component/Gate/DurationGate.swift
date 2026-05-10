//
//  DurationGate.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - DurationGate

package struct DurationGate<Upstream>: Sendable where Upstream: GestureComponent {
    package enum Failure: Error, Hashable, Sendable {
        case minimumDurationNotReached
    }

    package var upstream: Upstream
    package let minimumDuration: Duration
    package let maximumDuration: Duration

    package init(
        upstream: Upstream,
        minimumDuration: Duration,
        maximumDuration: Duration
    ) {
        self.upstream = upstream
        self.minimumDuration = minimumDuration
        self.maximumDuration = maximumDuration
    }
}

// MARK: - DurationGate + GestureComponent

extension DurationGate: GestureComponent {
    package typealias Value = ExpirationRecord<Upstream.Value>
}

// MARK: - DurationGate + CompositeGestureComponent

extension DurationGate: CompositeGestureComponent {}

// MARK: - DurationGate + ValueTransformingComponent

extension DurationGate: ValueTransformingComponent {
    package mutating func transform(
        _ value: Upstream.Value,
        isFinal: Bool,
        context: GestureComponentContext
    ) throws -> GestureOutput<Value> {
        if context.durationSinceStart < minimumDuration {
            guard !isFinal else {
                throw Failure.minimumDurationNotReached
            }
            let output = GestureOutput<Upstream.Value>.empty(
                .filtered,
                metadata: GestureOutputMetadata(
                    traceAnnotation: UpdateTraceAnnotation(value: "min duration not reached")
                )
            )
            return Self.makeExpirationOutput(
                output,
                from: context.startTime,
                after: minimumDuration,
                reason: "min duration expired"
            )
        } else {
            let output = GestureOutput<Upstream.Value>.value(
                value,
                isFinal: isFinal
            )
            return Self.makeExpirationOutput(
                output,
                from: context.startTime,
                after: maximumDuration,
                reason: "max duration expired"
            )
        }
    }

    private static func makeExpirationOutput(
        _ output: GestureOutput<Upstream.Value>,
        from startTime: Timestamp,
        after duration: Duration,
        reason: ExpirationReason
    ) -> GestureOutput<ExpirationRecord<Upstream.Value>> {
        let expiration: Expiration?
        if .zero < duration, duration < .max {
            expiration = Expiration(deadline: startTime + duration, reason: reason)
        } else {
            expiration = nil
        }
        return output.expired(with: expiration)
    }
}
