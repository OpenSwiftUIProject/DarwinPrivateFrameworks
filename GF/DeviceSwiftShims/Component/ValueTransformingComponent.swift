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
        isFinal: Bool,
        context: GestureComponentContext
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
        case let .value(value, metadata):
            let output = try transform(value, isFinal: false, context: context)
            return output.copyWithCombinedMetadata(metadata)
        case let .finalValue(value, metadata):
            let output = try transform(value, isFinal: true, context: context)
            return output.copyWithCombinedMetadata(metadata)
        }
    }
}

extension ValueTransformingComponent where Value == Upstream.Value {
    package mutating func transform(
        _ value: Upstream.Value,
        isFinal: Bool,
        context: GestureComponentContext
    ) throws -> GestureOutput<Value> {
        return .value(value, isFinal: isFinal)
    }
}
