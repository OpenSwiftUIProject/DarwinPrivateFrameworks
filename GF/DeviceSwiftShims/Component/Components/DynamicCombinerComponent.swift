//
//  DynamicCombinerComponent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - DynamicCombinerComponent

package struct DynamicCombinerComponent<Upstream>: Sendable where Upstream: GestureComponent {
    package enum Failure: Error, Hashable, Sendable {
        case limitExceeded
    }

    package var upstreams: ReplicatingList<CombinerElement<Upstream>>
    package let outputCombiner: GestureOutputArrayCombiner<Upstream.Value>
    package let initialCount: Int
    package let limit: Int
    package let failOnExceedingLimit: Bool
    package let resetComponentsOnCompletion: Bool

    // TBA
    package init(
        upstream: Upstream,
        outputCombiner: GestureOutputArrayCombiner<Upstream.Value>,
        initialCount: Int,
        limit: Int,
        failOnExceedingLimit: Bool,
        resetComponentsOnCompletion: Bool
    ) {
        self.upstreams = ReplicatingList(
            prototype: CombinerElement(upstream: upstream),
            count: initialCount
        )
        self.outputCombiner = outputCombiner
        self.initialCount = initialCount
        self.limit = limit
        self.failOnExceedingLimit = failOnExceedingLimit
        self.resetComponentsOnCompletion = resetComponentsOnCompletion
    }

    package init(
        upstreams: ReplicatingList<CombinerElement<Upstream>>,
        outputCombiner: GestureOutputArrayCombiner<Upstream.Value>,
        initialCount: Int,
        limit: Int,
        failOnExceedingLimit: Bool,
        resetComponentsOnCompletion: Bool
    ) {
        self.upstreams = upstreams
        self.outputCombiner = outputCombiner
        self.initialCount = initialCount
        self.limit = limit
        self.failOnExceedingLimit = failOnExceedingLimit
        self.resetComponentsOnCompletion = resetComponentsOnCompletion
    }
}

// MARK: - DynamicCombinerComponent + GestureComponent

extension DynamicCombinerComponent: GestureComponent {
    package typealias Value = [Upstream.Value]

    package mutating func update(context: GestureComponentContext) throws -> GestureOutput<Value> {
        guard !upstreams.isEmpty else {
            return .empty(
                .filtered,
                metadata: GestureOutputMetadata(
                    traceAnnotation: UpdateTraceAnnotation(value: "no upstreams")
                )
            )
        }

        var outputs: [GestureOutput<Upstream.Value>] = []
        var noDataCount = 0
        for index in upstreams.indices {
            let output = try upstreams[index].tracingUpdate(context: context)
            outputs.append(output)
            if output.emptyReason == .noData {
                noDataCount += 1
            }
        }
        if noDataCount == 0, context.updateSource == .event {
            let limit = limit
            while upstreams.count < limit || failOnExceedingLimit {
                upstreams.appendReplications(1)
                let index = upstreams.count - 1
                let output = try upstreams[index].tracingUpdate(context: context)
                guard output.emptyReason != .noData else {
                    upstreams.removeLast(1)
                    break
                }
                if failOnExceedingLimit, limit < upstreams.count {
                    throw Failure.limitExceeded
                } else {
                    outputs.append(output)
                }
            }
        }
        if resetComponentsOnCompletion {
            for index in outputs.indices.reversed() where outputs[index].isFinal {
                if initialCount >= upstreams.count {
                    upstreams[index].reset()
                } else {
                    upstreams.remove(at: index)
                }
            }
        }
        return try outputCombiner.combine(outputs)
    }

    package mutating func reset() {
        upstreams.resize(to: initialCount)
        for index in upstreams.indices {
            upstreams[index].reset()
        }
    }

    package mutating func traits() -> GestureTraitCollection? {
        var prototype = upstreams.prototype()
        return prototype.traits()
    }

    package mutating func capacity<EventType: Event>(for eventType: EventType.Type) -> Int {
        var total = 0
        for index in upstreams.indices {
            total += upstreams[index].capacity(for: eventType)
        }

        var prototype = upstreams.prototype()
        let prototypeCapacity = prototype.capacity(for: eventType)
        guard prototypeCapacity >= 1 else {
            return total
        }
        guard upstreams.count < limit || failOnExceedingLimit else {
            return total
        }
        return Swift.min(limit, total + prototypeCapacity)
    }
}
