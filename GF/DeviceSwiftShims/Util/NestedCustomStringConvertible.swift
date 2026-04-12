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
    @_spi(Private)
    public var description: String {
        var nested = NestedDescription(depth: 0, target: self)
        populateNestedDescription(&nested)
        var result = nested.buildOpening()
        result += nested.buildBody()
        result += nested.buildClosing()
        return result
    }

    @_spi(Private)
    public var debugDescription: String {
        description
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
