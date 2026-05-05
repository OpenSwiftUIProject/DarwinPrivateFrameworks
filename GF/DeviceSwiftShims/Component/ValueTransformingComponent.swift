//
//  ValueTransformingComponent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - ValueTransformingComponent

package protocol ValueTransformingComponent: CompositeGestureComponent {
    mutating func transform(
        _ value: Upstream.Value,
        isFinal: Bool
    ) throws -> GestureOutput<Value>
}

extension ValueTransformingComponent {
    package mutating func update(
        context: GestureComponentContext
    ) throws -> GestureOutput<Value> {
        let output = try upstream.tracingUpdate(context: context)
        switch output {
        case let .empty(reason, metadata):
            return .empty(reason, metadata: metadata)
        case let .value(value, _):
            return try transform(value, isFinal: false)
        case let .finalValue(value, _):
            return try transform(value, isFinal: true)
        }
    }
}

extension ValueTransformingComponent where Value == Upstream.Value {
    package mutating func transform(
        _ value: Upstream.Value,
        isFinal: Bool
    ) throws -> GestureOutput<Value> {
        if isFinal {
            return .finalValue(value, metadata: nil)
        } else {
            return .value(value, metadata: nil)
        }
    }
}
