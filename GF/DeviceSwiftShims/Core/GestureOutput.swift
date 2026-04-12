//
//  GestureOutput.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - GestureOutput

public enum GestureOutput<Value> {
    case empty(GestureOutputEmptyReason, metadata: GestureOutputMetadata?)
    case value(Value, metadata: GestureOutputMetadata?)
    case finalValue(Value, metadata: GestureOutputMetadata?)
}

extension GestureOutput: Sendable where Value: Sendable {}

extension GestureOutput {
    public var value: Value? {
        switch self {
        case .value(let v, _): v
        case .finalValue(let v, _): v
        case .empty: nil
        }
    }

    public var isEmpty: Bool {
        if case .empty = self { return true }
        return false
    }

    public var isFinal: Bool {
        if case .finalValue = self { return true }
        return false
    }
}

// MARK: - GestureOutput + NestedCustomStringConvertible

extension GestureOutput: NestedCustomStringConvertible {
    package func populateNestedDescription(_ nested: inout NestedDescription) {
        nested.options.formUnion([.hideTypeName, .compact])
        nested.customPrefix = ""
        nested.customSuffix = ""
        switch self {
        case .empty(let reason, _):
            nested.append("empty(\(reason))")
        case .value(_, _):
            nested.append("value")
        case .finalValue(_, _):
            nested.append("finalValue")
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
    public var updatesToSchedule: [UpdateRequest]
    public var updatesToCancel: [UpdateRequest]
    public var traceAnnotation: UpdateTraceAnnotation?

    public init(
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

public struct UpdateTraceAnnotation: Sendable {
    public var value: String

    public init(value: String) {
        self.value = value
    }
}

// MARK: - GestureOutputStatus

public enum GestureOutputStatus: Hashable, Sendable {
    case empty
    case value
    case finalValue
}

// MARK: - GestureOutputStatusCombiner

public struct GestureOutputStatusCombiner: Sendable {
    public var combine: @Sendable ([GestureOutputStatus]) throws -> GestureOutputStatus

    public init(combine: @escaping @Sendable ([GestureOutputStatus]) throws -> GestureOutputStatus) {
        self.combine = combine
    }
}

// MARK: - GestureOutputArrayCombiner

public struct GestureOutputArrayCombiner<A: Sendable>: Sendable {
    public let statusCombiner: GestureOutputStatusCombiner

    public init(statusCombiner: GestureOutputStatusCombiner) {
        self.statusCombiner = statusCombiner
    }
}

// MARK: - GestureOutputCombiner

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
