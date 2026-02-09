public import AttributeGraph

/// A reactive property wrapper that automatically tracks dependencies and manages value updates.
///
/// `Attribute` is the core building block of the AttributeGraph reactive system. When you wrap a
/// property with `@Attribute`, it becomes reactive and can automatically track dependencies and
/// propagate changes.
///
///     @Attribute var count: Int = 0
///     @Attribute var doubledCount: Int = count * 2
///     
///     count = 5 // doubledCount automatically becomes 10
///
/// ## Key Features
///
/// - Automatic dependency tracking: Attributes automatically discover their dependencies
/// - Efficient updates: Only affected attributes are recomputed when changes occur
/// - Type safety: Full Swift type safety with compile-time checking
/// - Dynamic member lookup: Access nested properties as reactive attributes
/// - Property wrapper syntax: Clean, declarative syntax using `@Attribute`
///
/// ## Property Wrapper Usage
///
/// Use `@Attribute` to make any Swift value reactive:
///
///     struct CounterView {
///         @Attribute var count: Int = 0
///         
///         var body: some View {
///             Button("Count: \(count)") {
///                 count += 1
///             }
///         }
///     }
///
/// ## Dynamic Member Lookup
///
/// Access nested properties as separate attributes:
///
///     @Attribute var person: Person = Person(name: "Alice", age: 30)
///     let nameAttribute: Attribute<String> = person.name
///     let ageAttribute: Attribute<Int> = person.age
///
/// ## Integration with Rules
///
/// Create computed attributes using ``Rule`` or ``StatefulRule``:
///
///     struct DoubledRule: Rule {
///         typealias Value = Int
///         let source: Attribute<Int>
///         
///         func value() -> Int {
///             source.wrappedValue * 2
///         }
///     }
///
///     let doubled = Attribute(DoubledRule(source: count))
@frozen
@propertyWrapper
@dynamicMemberLookup
public struct Attribute<Value> {
    public var identifier: AnyAttribute
    
    // MARK: - Initializer
    
    /// Creates an attribute from a type-erased identifier.
    ///
    /// - Parameter identifier: The type-erased attribute identifier
    public init(identifier: AnyAttribute) {
        self.identifier = identifier
    }

    /// Creates an attribute by copying another attribute.
    ///
    /// - Parameter attribute: The attribute to copy
    public init(_ attribute: Attribute<Value>) {
        self = attribute
    }
        
    /// Creates an attribute with an initial value.
    ///
    /// - Parameter value: The initial value for the attribute
    public init(value: Value) {
        self = withUnsafePointer(to: value) { valuePointer in
            withUnsafePointer(to: External<Value>()) { bodyPointer in
                Attribute(body: bodyPointer, value: valuePointer, flags: .external) {
                    External<Value>._update
                }
            }
        }
    }
    
    public init(type _: Value.Type) {
        self = withUnsafePointer(to: External<Value>()) { bodyPointer in
            Attribute(body: bodyPointer, value: nil, flags: .external) {
                External<Value>._update
            }
        }
    }

    public init<Body: _AttributeBody>(
        body: UnsafePointer<Body>,
        value: UnsafePointer<Value>?,
        flags: _AttributeType.Flags = [],
        update: AttributeUpdateBlock
    ) {
        #if os(WASI)
        // This is a compiler issue and SwiftWasm toolchain enable the assertation
        // See https://github.com/swiftwasm/swift/issues/5569
        fatalError("Swift 5.9.1 Compiler issue - type mismatch of Unmanaged<AGGraphContext> and AGGraphContext")
        #else
        guard let context = Subgraph.currentGraphContext else {
            fatalError("attempting to create attribute with no subgraph: \(Value.self)")
        }
        let index = Graph.typeIndex(
            ctx: context,
            body: Body.self,
            valueType: Metadata(Value.self),
            flags: flags,
            update: update
        )
        identifier = AGGraphCreateAttribute(index: index, body: body, value: value)
        #endif
    }
    
    // MARK: - propertyWrapper
        
    /// The current value of the attribute.
    public var wrappedValue: Value {
        unsafeAddress {
            AGGraphGetValue(identifier, type: Value.self)
                .value
                .assumingMemoryBound(to: Value.self)
        }
        nonmutating set { _ = setValue(newValue) }
    }
    
    /// The attribute itself when accessed with the `$` prefix.
    public var projectedValue: Attribute<Value> {
        get { self }
        set { self = newValue }
    }

    // MARK: - dynamicMemberLookup
        
    public subscript<Member>(dynamicMember keyPath: KeyPath<Value, Member>) -> Attribute<Member> {
        self[keyPath: keyPath]
    }
    
    public subscript<Member>(keyPath keyPath: KeyPath<Value, Member>) -> Attribute<Member> {
        if let offset = MemoryLayout<Value>.offset(of: keyPath) {
            return unsafeOffset(at: offset, as: Member.self)
        } else {
            return Attribute<Member>(Focus(root: self, keyPath: keyPath))
        }
    }
        
    public subscript<Member>(offset body: (inout Value) -> PointerOffset<Value, Member>) -> Attribute<Member> {
        unsafeOffset(at: PointerOffset.offset(body).byteOffset, as: Member.self)
    }
    
    // MARK: - Transform
    
    public func unsafeCast<V>(to type: V.Type) -> Attribute<V> {
        identifier.unsafeCast(to: type)
    }
    
    public func unsafeOffset<Member>(at offset: Int, as _: Member.Type) -> Attribute<Member> {
        Attribute<Member>(
            identifier: identifier.create(
                offset: offset,
                size: numericCast(MemoryLayout<Member>.size)
            )
        )
    }
    
    public func applying<Member>(offset: PointerOffset<Value, Member>) -> Attribute<Member> {
        unsafeOffset(at: offset.byteOffset, as: Member.self)
    }
    
    public func visitBody<Body: AttributeBodyVisitor>(_ visitor: inout Body) {
        identifier.visitBody(&visitor)
    }
    
    public func mutateBody<V>(as type: V.Type, invalidating: Bool, _ body: (inout V) -> Void) {
        identifier.mutateBody(as: type, invalidating: invalidating, body)
    }

    public func breadthFirstSearch(options: SearchOptions = [], _ body: (AnyAttribute) -> Bool) -> Bool {
        identifier.breadthFirstSearch(options: options, body)
    }
    
    // MARK: - Graph
    
    public var graph: Graph {
        #if os(WASI)
        fatalError("Compiler Bug")
        #else
        identifier.graph
        #endif
    }
    public var subgraph: Subgraph {
        #if os(WASI)
        fatalError("Compiler Bug")
        #else
        identifier.subgraph
        #endif
    }
    
    // MARK: - Value
    
    public var value: Value {
        unsafeAddress {
            AGGraphGetValue(identifier, type: Value.self)
                .value
                .assumingMemoryBound(to: Value.self)
        }
        nonmutating set { _ = setValue(newValue) }
    }
    
    public var valueState: ValueState { identifier.valueState }
    
    public func valueAndFlags(options: AGValueOptions = []) -> (value: Value, flags: AGChangedValueFlags) {
        let value = AGGraphGetValue(identifier, options: options, type: Value.self)
        return (
            value.value.assumingMemoryBound(to: Value.self).pointee,
            value.flags
        )
    }
    
    public func changedValue(options: AGValueOptions = []) -> (value: Value, changed: Bool) {
        let value = AGGraphGetValue(identifier, options: options, type: Value.self)
        return (
            value.value.assumingMemoryBound(to: Value.self).pointee,
            value.flags.contains(.changed)
        )
    }
    
    public func setValue(_ value: Value) -> Bool {
        withUnsafePointer(to: value) { valuePointer in
            AGGraphSetValue(identifier, valuePointer: valuePointer)
        }
    }
    
    public var hasValue: Bool { identifier.hasValue }
    public func updateValue() { identifier.updateValue() }
    public func prefetchValue() { identifier.prefetchValue() }
    public func invalidateValue() { identifier.invalidateValue() }
    public func validate() { identifier.verify(type: Metadata(Value.self)) }

    // MARK: - Input
    
    public func addInput(_ attribute: AnyAttribute, options: AGInputOptions = [], token: Int) {
        identifier.addInput(attribute, options: options, token: token)
    }
    
    public func addInput<V>(_ attribute: Attribute<V>, options: AGInputOptions = [], token: Int) {
        identifier.addInput(attribute, options: options, token: token)
    }
    
    // MARK: - Flags

    public typealias Flags = AnyAttribute.Flags

    public var flags: Flags {
        get { identifier.flags }
        nonmutating set { identifier.flags = newValue }
    }
    
    public func setFlags(_ newFlags: Flags, mask: Flags) {
        identifier.setFlags(newFlags, mask: mask)
    }
}

extension Attribute: Hashable {}

extension Attribute: CustomStringConvertible {
    public var description: String {
        identifier.description
    }
}

// MARK: Attribute + Rule

extension Attribute {
    public init<R: Rule>(_ rule: R) where R.Value == Value {
        self = withUnsafePointer(to: rule) { pointer in
            Attribute(body: pointer, value: nil) { R._update }
        }
    }
    
    public init<R: StatefulRule>(_ rule: R) where R.Value == Value {
        self = withUnsafePointer(to: rule) { pointer in
            Attribute(body: pointer, value: nil) { R._update }
        }
    }
}

@_silgen_name("AGGraphCreateAttribute")
@inline(__always)
@inlinable
func AGGraphCreateAttribute(index: Int, body: UnsafeRawPointer, value: UnsafeRawPointer?) -> AnyAttribute

@_silgen_name("AGGraphGetValue")
@inline(__always)
@inlinable
func AGGraphGetValue<Value>(_ attribute: AnyAttribute, options: AGValueOptions = [], type: Value.Type = Value.self) -> AGValue

@_silgen_name("AGGraphSetValue")
@inline(__always)
@inlinable
func AGGraphSetValue<Value>(_ attribute: AnyAttribute, valuePointer: UnsafePointer<Value>) -> Bool
