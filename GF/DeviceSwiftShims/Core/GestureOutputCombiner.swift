//
//  GestureOutputCombiner.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

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

extension GestureOutput {
    package var status: GestureOutputStatus {
        switch self {
        case .empty:
            return .empty
        case .value:
            return .value
        case .finalValue:
            return .finalValue
        }
    }
}

// MARK: - GestureOutputArrayCombiner

package struct GestureOutputArrayCombiner<Value: Sendable>: Sendable {
    package let statusCombiner: GestureOutputStatusCombiner

    package init(statusCombiner: GestureOutputStatusCombiner) {
        self.statusCombiner = statusCombiner
    }

    package func combine(_ outputs: [GestureOutput<Value>]) throws -> GestureOutput<[Value]> {
        var statuses: [GestureOutputStatus] = []
        var values: [Value] = []
        var metadata: GestureOutputMetadata?
        var emptyReason: GestureOutputEmptyReason?
        var lastOutputEmptyReason: GestureOutputEmptyReason?
        var hasProcessedOutput = false
        var hasPriorOutput = false
        for output in outputs {
            hasPriorOutput = hasProcessedOutput
            if let value = output.value {
                values.append(value)
            }
            statuses.append(output.status)
            metadata = GestureOutputMetadata.combineUpdateRequests(metadata, output.metadata)
            lastOutputEmptyReason = output.emptyReason
            hasProcessedOutput = true
        }
        if hasProcessedOutput {
            emptyReason = hasPriorOutput || lastOutputEmptyReason != nil ? .filtered : .noData
        }
        let status = try statusCombiner.combine(statuses)
        switch status {
        case .empty:
            return .empty(emptyReason!, metadata: metadata)
        case .value:
            return .value(values, metadata: metadata)
        case .finalValue:
            return .finalValue(values, metadata: metadata)
        }
    }
}

// MARK: - GestureOutputCombiner

package struct GestureOutputCombiner<each Value: Sendable, Output: Sendable>: Sendable {
    package let combineValues: (@Sendable (repeat each Value) throws -> Output)?
    package let combineOptionals: (@Sendable (repeat (each Value)?) throws -> Output)?
    package let statusCombiner: GestureOutputStatusCombiner

    package init(
        combineValues: (@Sendable (repeat each Value) throws -> Output)?,
        combineOptionals: (@Sendable (repeat (each Value)?) throws -> Output)?,
        statusCombiner: GestureOutputStatusCombiner
    ) {
        self.combineValues = combineValues
        self.combineOptionals = combineOptionals
        self.statusCombiner = statusCombiner
    }

    package func combine(_ outputs: repeat GestureOutput<each Value>) throws -> GestureOutput<Output> {
        var statuses: [GestureOutputStatus] = []
        var metadata: GestureOutputMetadata?
        var emptyReason: GestureOutputEmptyReason?
        var lastOutputEmptyReason: GestureOutputEmptyReason?
        var hasProcessedOutput = false
        var hasPriorOutput = false
        for output in repeat each outputs {
            hasPriorOutput = hasProcessedOutput
            statuses.append(output.status)
            metadata = GestureOutputMetadata.combineUpdateRequests(metadata, output.metadata)
            lastOutputEmptyReason = output.emptyReason
            hasProcessedOutput = true
        }
        if hasProcessedOutput {
            emptyReason = hasPriorOutput || lastOutputEmptyReason != nil ? .filtered : .noData
        }
        let status = try statusCombiner.combine(statuses)
        switch status {
        case .empty:
            return .empty(emptyReason!, metadata: metadata)
        case .value, .finalValue:
            let value: Output
            if let combineOptionals {
                value = try combineOptionals(repeat (each outputs).value)
            } else if let combineValues {
                value = try combineValues(repeat (each outputs).value!)
            } else {
                preconditionFailure("Invalid combiner configuration")
            }
            if status == .value {
                return .value(value, metadata: metadata)
            } else {
                return .finalValue(value, metadata: metadata)
            }
        }
    }
}
