//
//  GestureNodeMatcher.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - GestureNodeMatcher

public enum GestureNodeMatcher: Hashable, Sendable {
    case id(GestureNodeID)
    case tag(GestureTag)
    case traits(GestureTraitCollection, position: RelativePosition)
    case any(position: RelativePosition)

    public enum RelativePosition: Hashable, Sendable {
        case any
        case above
        case below
    }
}

// MARK: - GestureNodeMatcher + Comparable

extension GestureNodeMatcher: Comparable {
    public static func < (lhs: GestureNodeMatcher, rhs: GestureNodeMatcher) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }

    private var sortOrder: Int {
        switch self {
        case .id: 0
        case .tag: 1
        case .traits: 2
        case .any: 3
        }
    }
}

// MARK: - GestureNodeMatcher + NestedCustomStringConvertible

extension GestureNodeMatcher: NestedCustomStringConvertible {
    package func populateNestedDescription(_ nested: inout NestedDescription) {
        nested.options.formUnion([.hideTypeName, .compact])
        nested.customPrefix = ""
        nested.customSuffix = ""
        switch self {
        case let .id(id):
            nested.append(id)
        case let .tag(tag):
            nested.append(tag)
        case let .traits(collection, position):
            nested.append(collection)
            nested.append(position, label: "position")
        case let .any(position):
            nested.append("any")
            nested.append(position, label: "position")
        }
    }
}
