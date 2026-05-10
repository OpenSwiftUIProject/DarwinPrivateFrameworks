//
//  CombinerComponent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - CombinerComponent

package struct CombinerComponent<each Upstream, Output>: Sendable
where repeat each Upstream: GestureComponent, Output: Sendable {
    package var upstream: (repeat CombinerElement<each Upstream>)
    package let outputCombiner: GestureOutputCombiner<repeat (each Upstream).Value, Output>
    package let resetComponentsOnCompletion: Bool

    package init(
        upstream: (repeat CombinerElement<each Upstream>),
        outputCombiner: GestureOutputCombiner<repeat (each Upstream).Value, Output>,
        resetComponentsOnCompletion: Bool
    ) {
        self.upstream = upstream
        self.outputCombiner = outputCombiner
        self.resetComponentsOnCompletion = resetComponentsOnCompletion
    }
}

// MARK: - CombinerComponent + GestureComponent

extension CombinerComponent: GestureComponent {
    package typealias Value = Output

    package mutating func update(context: GestureComponentContext) throws -> GestureOutput<Value> {
        let updated = (repeat try Self.updateElement(
            each upstream,
            context: context,
            resetComponentsOnCompletion: resetComponentsOnCompletion
        ))
        let outputs = (repeat (each updated).output)
        upstream = (repeat (each updated).component)
        return try outputCombiner.combine(repeat each outputs)
    }

    private static func updateElement<Component>(
        _ component: CombinerElement<Component>,
        context: GestureComponentContext,
        resetComponentsOnCompletion: Bool
    ) throws -> (component: CombinerElement<Component>, output: GestureOutput<Component.Value>) {
        var component = component
        let output = try component.tracingUpdate(context: context)
        if resetComponentsOnCompletion, output.isFinal {
            component.reset()
        }
        return (component, output)
    }

    package mutating func reset() {
        upstream = (repeat {
            var element = each upstream
            element.reset()
            return element
        }())
    }

    package mutating func traits() -> GestureTraitCollection? {
        var result: GestureTraitCollection?
        upstream = (repeat Self.collectTraits(from: each upstream, into: &result))
        return result
    }

    private static func collectTraits<Component>(
        from component: CombinerElement<Component>,
        into result: inout GestureTraitCollection?
    ) -> CombinerElement<Component> {
        var component = component
        let traits = component.traits()
        let newResult: GestureTraitCollection?
        if let result, let traits {
            newResult = result.merging(traits)
        } else if let result {
            newResult = result
        } else {
            newResult = traits
        }
        result = newResult
        return component
    }

    package mutating func capacity<EventType: Event>(for eventType: EventType.Type) -> Int {
        let updated = (repeat {
            var component = each upstream
            let capacity = component.capacity(for: eventType)
            return (component: component, capacity: capacity)
        }())
        upstream = (repeat (each updated).component)

        var total = 0
        for capacity in repeat (each updated).capacity {
            total += capacity
        }
        return total
    }
}

// MARK: - CombinerElement

package struct CombinerElement<Upstream>: Sendable where Upstream: GestureComponent {
    package struct State: GestureComponentState, NestedCustomStringConvertible, Sendable {
        package var cachedOutput: GestureOutput<Upstream.Value>?
        package var isDirty: Bool

        package init() {
            cachedOutput = nil
            isDirty = false
        }
    }

    package var upstream: Upstream
    package var state: State

    package init(
        upstream: Upstream,
        state: State = State()
    ) {
        self.upstream = upstream
        self.state = state
    }
}

extension CombinerElement: ReplicatingValue {
    package func replicated() -> Self {
        var copy = self
        copy.reset()
        return copy
    }
}

extension CombinerElement: GestureComponent {
    package typealias Value = Upstream.Value

    package mutating func update(context: GestureComponentContext) throws -> GestureOutput<Value> {
        state.isDirty = true
        guard let cachedOutput = state.cachedOutput, cachedOutput.isFinal else {
            let output = try upstream.tracingUpdate(context: context)
            guard !output.isEmpty else {
                guard let cachedOutput = state.cachedOutput else {
                    return output
                }
                return cachedOutput.copyWithCombinedMetadata(
                    output.metadata ?? GestureOutputMetadata()
                )
            }
            state.cachedOutput = output.copyClearingMetadata()
            return output
        }
        return cachedOutput
    }

    package mutating func reset() {
        guard state.isDirty else {
            return
        }
        state = State()
        upstream.reset()
    }

    package mutating func traits() -> GestureTraitCollection? {
        state.isDirty = true
        return upstream.traits()
    }

    package mutating func capacity<EventType: Event>(for eventType: EventType.Type) -> Int {
        state.isDirty = true
        guard let cachedOutput = state.cachedOutput, cachedOutput.isFinal else {
            return upstream.capacity(for: eventType)
        }
        return 0
    }
}

extension CombinerElement: StatefulGestureComponent {}

extension CombinerElement: CompositeGestureComponent {}
