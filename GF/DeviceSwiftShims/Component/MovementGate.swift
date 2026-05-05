//
//  MovementGate.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - MovementGate

package struct MovementGate<Upstream, LocationValue>: Sendable
    where Upstream: GestureComponent,
    LocationValue: LocationContaining & Sendable,
    Upstream.Value == TrackedValue<LocationValue>
{
    package enum Failure: Error, Hashable, Sendable {
        case tooMuchMovement
    }

    package enum Restriction: Hashable, Sendable {
        case min
        case max
    }

    package var upstream: Upstream
    package let bound: Double
    package let restriction: Restriction

    package init(
        upstream: Upstream,
        bound: Double,
        restriction: Restriction
    ) {
        self.upstream = upstream
        self.bound = bound
        self.restriction = restriction
    }
}

// MARK: - MovementGate + GestureComponent

extension MovementGate: GestureComponent {
    package typealias Value = TrackedValue<LocationValue>
}

// MARK: - MovementGate + CompositeGestureComponent

extension MovementGate: CompositeGestureComponent {}

// MARK: - MovementGate + ValueTransformingComponent

extension MovementGate: ValueTransformingComponent {
    package mutating func transform(
        _ value: Upstream.Value,
        isFinal: Bool
    ) throws -> GestureOutput<Value> {
        let movement = value.locationTranslation.magnitude
        switch restriction {
        case .min:
            if movement < bound {
                return .empty(
                    .filtered,
                    metadata: GestureOutputMetadata(
                        traceAnnotation: UpdateTraceAnnotation(value: "not enough movement")
                    )
                )
            }
        case .max:
            if movement > bound {
                throw Failure.tooMuchMovement
            }
        }
        if isFinal {
            return .finalValue(value, metadata: nil)
        } else {
            return .value(value, metadata: nil)
        }
    }
}
