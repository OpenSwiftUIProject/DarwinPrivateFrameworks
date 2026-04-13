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

extension GestureOutputMetadata: NestedCustomStringConvertible {
    package func populateNestedDescription(_ nested: inout NestedDescription) {
        nested.options.formUnion([.hideTypeName, .compact])
        nested.customPrefix = ""
        nested.customSuffix = ""
        if !updatesToSchedule.isEmpty {
            nested.append("\(updatesToSchedule)", label: "updatesToSchedule")
        }
        if !updatesToCancel.isEmpty {
            nested.append("\(updatesToCancel)", label: "updatesToCancel")
        }
        if let traceAnnotation {
            nested.append(traceAnnotation.value, label: "traceAnnotation")
        }
    }
}

// MARK: - UpdateTraceAnnotation

package struct UpdateTraceAnnotation: Sendable {
    package var value: String

    package init(value: String) {
        self.value = value
    }
}

// MARK: - GestureOutputStatus [TBA]

public enum GestureOutputStatus: Hashable, Sendable {
    case empty
    case value
    case finalValue
}

// MARK: - GestureOutputStatusCombiner [TBA]

public struct GestureOutputStatusCombiner: Sendable {
    public var combine: @Sendable ([GestureOutputStatus]) throws -> GestureOutputStatus

    public init(combine: @escaping @Sendable ([GestureOutputStatus]) throws -> GestureOutputStatus) {
        self.combine = combine
    }
}

// MARK: - GestureOutputArrayCombiner [TBA]

public struct GestureOutputArrayCombiner<A: Sendable>: Sendable {
    public let statusCombiner: GestureOutputStatusCombiner

    public init(statusCombiner: GestureOutputStatusCombiner) {
        self.statusCombiner = statusCombiner
    }
}

// MARK: - GestureOutputCombiner [TBA]

public struct GestureOutputCombiner<each A: Sendable, B: Sendable>: Sendable {
    public let combineValues: (@Sendable (repeat each A) throws -> B)?
    public let combineOptionals: (@Sendable (repeat (each A)?) throws -> B)?
    public let statusCombiner: GestureOutputStatusCombiner

    public init(
        combineValues: (@Sendable (repeat each A) throws -> B)?,
        combineOptionals: (@Sendable (repeat (each A)?) throws -> B)?,
        statusCombiner: GestureOutputStatusCombiner
    ) {
        self.combineValues = combineValues
        self.combineOptionals = combineOptionals
        self.statusCombiner = statusCombiner
    }
}
