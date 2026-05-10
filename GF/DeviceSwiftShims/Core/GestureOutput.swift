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

    package var emptyReason: GestureOutputEmptyReason? {
        if case let .empty(reason, _) = self {
            return reason
        }
        return nil
    }

    public var isFinal: Bool {
        switch self {
        case .finalValue: true
        default: false
        }
    }

    package var metadata: GestureOutputMetadata? {
        switch self {
        case let .empty(_, metadata):
            metadata
        case let .value(_, metadata):
            metadata
        case let .finalValue(_, metadata):
            metadata
        }
    }

    package func copyClearingMetadata() -> Self {
        switch self {
        case let .empty(reason, _):
            return .empty(reason, metadata: nil)
        case let .value(value, _):
            return .value(value, metadata: nil)
        case let .finalValue(value, _):
            return .finalValue(value, metadata: nil)
        }
    }

    package func copyWithCombinedMetadata(_ other: GestureOutputMetadata?) -> Self {
        switch self {
        case let .empty(reason, metadata):
            return .empty(reason, metadata: .combineUpdateRequests(metadata, other))
        case let .value(value, metadata):
            return .value(value, metadata: .combineUpdateRequests(metadata, other))
        case let .finalValue(value, metadata):
            return .finalValue(value, metadata: .combineUpdateRequests(metadata, other))
        }
    }

    package static func value(
        _ value: Value,
        isFinal: Bool,
        metadata: GestureOutputMetadata? = nil
    ) -> Self {
        if isFinal {
            return .finalValue(value, metadata: metadata)
        } else {
            return .value(value, metadata: metadata)
        }
    }
}

// MARK: - GestureOutput + NestedCustomStringConvertible

extension GestureOutput: NestedCustomStringConvertible {
    package func populateNestedDescription(_ nested: inout NestedDescription) {
        switch self {
        case .empty:
            nested.append(emptyReason, label: "emptyReason")
        case .value:
            nested.append(value, label: "value")
        case .finalValue:
            nested.append(value, label: "finalValue")
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

    package static func combineUpdateRequests(
        _ first: GestureOutputMetadata?,
        _ second: GestureOutputMetadata?
    ) -> GestureOutputMetadata? {
        switch (first, second) {
        case (nil, nil):
            return nil
        case let (metadata?, nil):
            return GestureOutputMetadata(
                updatesToSchedule: metadata.updatesToSchedule,
                updatesToCancel: metadata.updatesToCancel
            )
        case let (nil, metadata?):
            return GestureOutputMetadata(
                updatesToSchedule: metadata.updatesToSchedule,
                updatesToCancel: metadata.updatesToCancel
            )
        case let (first?, second?):
            return GestureOutputMetadata(
                updatesToSchedule: first.updatesToSchedule + second.updatesToSchedule,
                updatesToCancel: first.updatesToCancel + second.updatesToCancel
            )
        }
    }
}

// MARK: - GestureOutputMetadata + NestedCustomStringConvertible

extension GestureOutputMetadata: NestedCustomStringConvertible {}

// MARK: - UpdateTraceAnnotation

package struct UpdateTraceAnnotation: Sendable {
    public var value: String

    public init(value: String) {
        self.value = value
    }
}

