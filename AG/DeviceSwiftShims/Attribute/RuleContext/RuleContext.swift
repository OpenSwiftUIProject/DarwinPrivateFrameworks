//
//  RuleContext.swift
//  AttributeGraph
//
//  Audited for RELEASE_2021
//  Status: Complete

public import AttributeGraph

/// Context object providing access to rule evaluation state and input values.
@frozen
public struct RuleContext<Value>: Equatable {
    public var attribute: Attribute<Value>

    public init(attribute: Attribute<Value>) {
        self.attribute = attribute
    }
    
    public subscript<V>(attribute: Attribute<V>) -> V {
        unsafeAddress {
            AGGraphGetInputValue(self.attribute.identifier, input: attribute.identifier, type: V.self)
                .value
                .assumingMemoryBound(to: V.self)
        }
    }
    
    public subscript<V>(weakAttribute: WeakAttribute<V>) -> V? {
        weakAttribute.attribute.map { attribute in
            AGGraphGetInputValue(self.attribute.identifier, input: attribute.identifier, type: V.self)
                .value
                .assumingMemoryBound(to: V.self)
                .pointee
        }
    }

    public subscript<V>(optionalAttribute: OptionalAttribute<V>) -> V? {
        optionalAttribute.attribute.map { attribute in
            AGGraphGetInputValue(self.attribute.identifier, input: attribute.identifier, type: V.self)
                .value
                .assumingMemoryBound(to: V.self)
                .pointee
        }
    }

    public var value: Value {
        unsafeAddress {
            Graph.outputValue()!
        }
        nonmutating set {
            withUnsafePointer(to: newValue) { value in
                Graph.setOutputValue(value)
            }
        }
    }
    
    public var hasValue: Bool {
        let valuePointer: UnsafePointer<Value>? = Graph.outputValue()
        return valuePointer != nil
    }
        
    public func valueAndFlags<V>(of input: Attribute<V>, options: AGValueOptions = []) -> (value: V, flags: AGChangedValueFlags) {
        let value = AGGraphGetInputValue(attribute.identifier, input: input.identifier, options: options, type: V.self)
        return (
            value.value.assumingMemoryBound(to: V.self).pointee,
            value.flags
        )
    }
    
    public func changedValue<V>(of input: Attribute<V>, options: AGValueOptions = []) -> (value: V, changed: Bool) {
        let value = AGGraphGetInputValue(attribute.identifier, input: input.identifier, options: options, type: V.self)
        return (
            value.value.assumingMemoryBound(to: V.self).pointee,
            value.flags.contains(.changed)
        )
    }
    
    public func update(body: () -> Void) {
        AGGraphWithUpdate(attribute.identifier, body: body)
    }
}

@_silgen_name("AGGraphGetInputValue")
@inline(__always)
@inlinable
func AGGraphGetInputValue<Value>(_ attribute: AnyAttribute, input: AnyAttribute, options: AGValueOptions = [], type: Value.Type = Value.self) -> AGValue

@_silgen_name("AGGraphWithUpdate")
@inline(__always)
@inlinable
func AGGraphWithUpdate(_ attribute: AnyAttribute, body: () -> Void)
