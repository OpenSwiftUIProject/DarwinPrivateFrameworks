//
//  NestedCustomStringConvertible.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - NestedCustomStringConvertible

package protocol NestedCustomStringConvertible: CustomDebugStringConvertible, CustomStringConvertible {
    func populateNestedDescription(_ nested: inout NestedDescription)
}

extension NestedCustomStringConvertible {
    package func populateNestedDescription(_ nested: inout NestedDescription) {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            guard let label = child.label else { continue }
            var value: Any = child.value
            if let optional = value as? OptionalProtocol {
                guard !optional.isNil else { continue }
                value = optional.value!
            }
            if let collection = value as? any Collection {
                guard !collection.isEmpty else { continue }
            }
            nested.append(value, label: label)
        }
    }

    @_spi(Private)
    public var description: String {
        var nested = NestedDescription(depth: 0, target: self)
        populateNestedDescription(&nested)
        return nested.description
    }

    @_spi(Private)
    public var debugDescription: String {
        description
    }
}

// MARK: - OptionalProtocol

package protocol OptionalProtocol {
    var isNil: Bool { get }
    var value: Any? { get }
}

extension Optional: OptionalProtocol {
    package var isNil: Bool {
        switch self {
        case .none: true
        case .some: false
        }
    }

    package var value: Any? {
        switch self {
        case .none: nil
        case let .some(value): value
        }
    }
}

// MARK: - Standard Library Conformances

extension Array: NestedCustomStringConvertible where Element: NestedCustomStringConvertible {
    package func populateNestedDescription(_ nested: inout NestedDescription) {
        for element in self {
            var child = NestedDescription(depth: nested.depth + 1, target: element)
            element.populateNestedDescription(&child)
            nested.append(child.description)
        }
    }
}

extension Set: NestedCustomStringConvertible where Element: NestedCustomStringConvertible {
    package func populateNestedDescription(_ nested: inout NestedDescription) {
        for element in self {
            var child = NestedDescription(depth: nested.depth + 1, target: element)
            element.populateNestedDescription(&child)
            nested.append(child.description)
        }
    }
}

extension Dictionary: NestedCustomStringConvertible where Value: NestedCustomStringConvertible {
    package func populateNestedDescription(_ nested: inout NestedDescription) {
        for (key, value) in self {
            var child = NestedDescription(depth: nested.depth + 1, target: value)
            value.populateNestedDescription(&child)
            nested.append(child.description, label: String(describing: key))
        }
    }
}

// MARK: - NestedDescription

package struct NestedDescription {
    package struct Options: OptionSet {
        package let rawValue: Int

        package init(rawValue: Int) {
            self.rawValue = rawValue
        }

        package static let hideTypeName = Self(rawValue: 1 << 0)
        package static let hideIdentity = Self(rawValue: 1 << 1)
        package static let hideClassAddress = Self(rawValue: 1 << 2)
        package static let compact = Self(rawValue: 1 << 3)
    }
    package var options: Options
    package var customPrefix: String?
    package var customSuffix: String?
    package let depth: Int
    package let target: Any
    package var buffer: [String]

    package init(
        options: Options = [],
        customPrefix: String? = nil,
        customSuffix: String? = nil,
        depth: Int,
        target: Any,
        buffer: [String] = []
    ) {
        self.options = options
        self.customPrefix = customPrefix
        self.customSuffix = customSuffix
        self.depth = depth
        self.target = target
        self.buffer = buffer
    }

    mutating package func append<T>(
        _ content: T?,
        label: String? = nil
    ) {
        guard let content else {
            return
        }
        var result: String = ""
        if let label {
            result += "\(label): "
        }
        if let nestedConvertible = content as? any NestedCustomStringConvertible {
            var childNested = NestedDescription(depth: depth + 1, target: nestedConvertible)
            nestedConvertible.populateNestedDescription(&childNested)
            result += childNested.description
        } else {
            result += "\(content)"
        }
        if !result.isEmpty {
            buffer.append(result)
        }
    }

    // MARK: - Build

    package func buildOpening() -> String {
        if let customPrefix {
            return customPrefix
        }
        var result: String
        if !options.contains(.hideTypeName) {
            result = "\(type(of: target))"
        } else {
            result = ""
        }
        var hasClassIdentity = false
        if !options.contains(.hideClassAddress) {
            let dynamicType = type(of: target)
            if dynamicType is AnyObject.Type {
                let obj = target as AnyObject
                let address = UInt(bitPattern: ObjectIdentifier(obj))
                let addressString = "0x\(String(address, radix: 16, uppercase: false))"
                result += " <\(addressString)"
                hasClassIdentity = true
            }
        }
        if !options.contains(.hideIdentity),
           let identifiable = target as? any Identifiable {
            if hasClassIdentity {
                result += " \(identifiable.id)>"
            } else {
                result += " <\(identifiable.id)>"
            }
        } else if hasClassIdentity {
            result += ">"
        }
        result += result.isEmpty ? "" : " "
        result += "{"
        result += buffer.isEmpty ? "" : " "
        return result
    }

    package func buildBody() -> String {
        guard !options.contains(.compact) else {
            return buffer.joined(separator: ", ")
        }
        let separator: String
        if buffer.isEmpty {
            separator = ""
        } else {
            let depth = depth + 1
            let indent = String(repeating: " ", count: 2)
            let indentWithDepth = String(repeating: indent, count: depth)
            separator = "\n" + indentWithDepth
        }
        return separator + buffer.joined(separator: separator)
    }

    package func buildClosing() -> String {
        var result = customSuffix ?? "}"
        guard !buffer.isEmpty else {
            return result
        }
        let leading: String
        if options.contains(.compact) {
            leading = customSuffix == nil ? " " : ""
        } else {
            let indent = String(repeating: " ", count: 2)
            let indentWithDepth = String(repeating: indent, count: depth)
            leading = "\n\(indentWithDepth)"
        }
        result = leading + result
        return result
    }

    package var description: String {
        buildOpening() + buildBody() + buildClosing()
    }
}
