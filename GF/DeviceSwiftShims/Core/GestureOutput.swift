//
//  GestureOutput.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - GestureOutput

public enum GestureOutput<Value: Sendable>: Sendable {
    case empty(GestureOutputEmptyReason, metadata: GestureOutputMetadata?)
    case value(Value, metadata: GestureOutputMetadata?)
    case finalValue(Value, metadata: GestureOutputMetadata?)
}

extension GestureOutput {
    public var value: Value? {
        switch self {
        case let .value(v, _): v
        case let .finalValue(v, _): v
        case .empty: nil
        }
    }

    public var isEmpty: Bool {
        switch self {
        case .empty: true
        default: false
        }
    }

    public var isFinal: Bool {
        switch self {
        case .finalValue: true
        default: false
        }
    }
}

// MARK: - GestureOutput + NestedCustomStringConvertible

extension GestureOutput: NestedCustomStringConvertible {
    package func populateNestedDescription(_ nested: inout NestedDescription) {
        let metadata: GestureOutputMetadata?
        switch self {
        case let .empty(reason, m):
            nested.append(reason, label: "emptyReason")
            metadata = m
        case let .value(v, m):
            nested.append(v, label: "value")
            metadata = m
        case let .finalValue(v, m):
            nested.append(v, label: "finalValue")
            metadata = m
        }
        if let metadata {
            nested.append(metadata, label: "metadata")
        }
    }
}

// MARK: - GestureOutputEmptyReason

public enum GestureOutputEmptyReason: Hashable, Sendable {
    case noData
    case filtered
    case timeUpdate
}

// MARK: - GestureOutputMetadata

public struct GestureOutputMetadata: Sendable {
    package var updatesToSchedule: [UpdateRequest]
    package var updatesToCancel: [UpdateRequest]
    package var traceAnnotation: UpdateTraceAnnotation?

    package init(
        updatesToSchedule: [UpdateRequest] = [],
        updatesToCancel: [UpdateRequest] = [],
        traceAnnotation: UpdateTraceAnnotation? = nil
    ) {
        self.updatesToSchedule = updatesToSchedule
        self.updatesToCancel = updatesToCancel
        self.traceAnnotation = traceAnnotation
    }
}

// MARK: - GestureOutputMetadata + NestedCustomStringConvertible

extension GestureOutputMetadata: NestedCustomStringConvertible {}

// MARK: - UpdateTraceAnnotation

package struct UpdateTraceAnnotation: Sendable {
    package var value: String

    package init(value: String) {
        self.value = value
    }
}


// MARK: - GestureOutputStatusCombiner

package struct GestureOutputStatusCombiner: Sendable {
    package var combine: @Sendable ([GestureOutputStatus]) throws -> GestureOutputStatus

    package init(combine: @escaping @Sendable ([GestureOutputStatus]) throws -> GestureOutputStatus) {
        self.combine = combine
    }
}

// MARK: - GestureOutputStatus

package enum GestureOutputStatus: Hashable, Sendable {
    case empty
    case value
    case finalValue
}

// MARK: - GestureOutputArrayCombiner

package struct GestureOutputArrayCombiner<A: Sendable>: Sendable {
    package let statusCombiner: GestureOutputStatusCombiner

    package init(statusCombiner: GestureOutputStatusCombiner) {
        self.statusCombiner = statusCombiner
    }
}

// MARK: - GestureOutputCombiner

package struct GestureOutputCombiner<each A: Sendable, B: Sendable>: Sendable {
    package let combineValues: (@Sendable (repeat each A) throws -> B)?
    package let combineOptionals: (@Sendable (repeat (each A)?) throws -> B)?
    package let statusCombiner: GestureOutputStatusCombiner

    package init(
        combineValues: (@Sendable (repeat each A) throws -> B)?,
        combineOptionals: (@Sendable (repeat (each A)?) throws -> B)?,
        statusCombiner: GestureOutputStatusCombiner
    ) {
        self.combineValues = combineValues
        self.combineOptionals = combineOptionals
        self.statusCombiner = statusCombiner
    }
}
