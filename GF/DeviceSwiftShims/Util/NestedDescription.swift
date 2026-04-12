//
//  NestedDescription.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

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
        _ content: @autoclosure () -> T?,
        label: String? = nil
    ) {
        guard let content = content() else {
            return
        }
        var result: String = ""
        if let label {
            result += "\(label): "
        }
        result += "\(content)"
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
