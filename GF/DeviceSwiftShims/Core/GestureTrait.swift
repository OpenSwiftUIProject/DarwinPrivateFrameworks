//
//  GestureTrait.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete
//  ID: 6B817C31FCBD37CBF6F881EA231AB252 (Gestures)

// MARK: - GestureTrait

public struct GestureTrait: Hashable, Identifiable, Sendable {
    public var id: GestureTraitID
    public var attributes: [AttributeKey: AttributeValue]

    public init(id: GestureTraitID, attributes: [AttributeKey: AttributeValue] = [:]) {
        self.id = id
        self.attributes = attributes
    }

    // MARK: - Factory Methods

    public static func tap(tapCount: Int? = nil, pointCount: Int? = nil) -> GestureTrait {
        var attrs: [AttributeKey: AttributeValue] = [:]
        if let tapCount {
            attrs[.tapCount] = .int(tapCount)
        }
        if let pointCount {
            attrs[.pointCount] = .int(pointCount)
        }
        return GestureTrait(id: .tap, attributes: attrs)
    }

    public static func longPress(
        pointCount: Int? = nil,
        minimumDuration: Duration? = nil,
        maximumMovement: Double? = nil
    ) -> GestureTrait {
        var attrs: [AttributeKey: AttributeValue] = [:]
        if let pointCount {
            attrs[.pointCount] = .int(pointCount)
        }
        if let minimumDuration {
            attrs[.minimumDuration] = .double(Double(minimumDuration))
        }
        if let maximumMovement {
            attrs[.maximumMovement] = .double(maximumMovement)
        }
        return GestureTrait(id: .longPress, attributes: attrs)
    }

    public static func pan() -> GestureTrait {
        GestureTrait(id: .pan, attributes: [:])
    }

    // MARK: - AttributeKey

    public struct AttributeKey: Hashable, Sendable, CustomStringConvertible {
        public let rawValue: Int

        public init(_ label: String) {
            self.rawValue = TraitLabelStore.shared.register(label)
        }

        package var label: String {
            TraitLabelStore.shared.label(for: rawValue)
        }

        public var description: String {
            label
        }

        public static let pointCount = AttributeKey("pointCount")
        public static let tapCount = AttributeKey("tapCount")
        public static let minimumDuration = AttributeKey("minimumDuration")
        public static let maximumMovement = AttributeKey("maximumMovement")
    }

    // MARK: - AttributeValue

    public enum AttributeValue: Hashable, Sendable, CustomStringConvertible {
        case bool(Bool)
        case int(Int)
        case double(Double)

        public var description: String {
            switch self {
            case let .bool(value):
                value ? "true" : "false"
            case let .int(value):
                "\(value)"
            case let .double(value):
                "\(value)"
            }
        }
    }
}

extension GestureTrait: NestedCustomStringConvertible {
    public var label: String {
        TraitLabelStore.shared.label(for: id.rawValue)
    }

    package func populateNestedDescription(_ nested: inout NestedDescription) {
        nested.options.formUnion([.hideTypeName, .compact])
        nested.customPrefix = ""
        nested.customSuffix = ""
        nested.options.formUnion(.hideIdentity)
        if attributes.isEmpty {
            nested.append(label)
        } else {
            nested.customPrefix = label + " {"
            nested.customSuffix = "}"
            for (key, value) in attributes {
                nested.append("\(key.label): \(value)")
            }
        }
    }
}

// MARK: - GestureTraitID

public struct GestureTraitID: Hashable, Sendable {
    public let rawValue: Int

    public init(_ label: String) {
        self.rawValue = TraitLabelStore.shared.register(label)
    }

    // MARK: - Static Properties

    public static let tap = GestureTraitID("tap")
    public static let longPress = GestureTraitID("longPress")
    public static let pan = GestureTraitID("pan")
}


// MARK: - GestureTraitCollection

public struct GestureTraitCollection: Hashable, Sendable {
    private var _traits: [GestureTraitID: GestureTrait]

    public init(traits: [GestureTrait] = []) {
        var dict: [GestureTraitID: GestureTrait] = [:]
        for trait in traits {
            dict[trait.id] = trait
        }
        self._traits = dict
    }

    public static func withTrait(_ trait: GestureTrait) -> GestureTraitCollection {
        GestureTraitCollection(traits: [trait])
    }

    public var allTraits: [GestureTrait] {
        Array(_traits.values)
    }

    public func containsSubtraits(from other: GestureTraitCollection) -> Bool {
        for (id, otherTrait) in other._traits {
            guard let selfTrait = _traits[id], selfTrait == otherTrait else {
                return false
            }
        }
        return true
    }
}

// MARK: - GestureTraitCollection + Sequence

@_spi(Private)
extension GestureTraitCollection: Sequence {
    public func makeIterator() -> some IteratorProtocol {
        _traits.values.makeIterator()
    }
}

// MARK: - GestureTraitCollection + CustomStringConvertible

extension GestureTraitCollection: NestedCustomStringConvertible {
    package func populateNestedDescription(_ nested: inout NestedDescription) {
        nested.options.formUnion([.hideTypeName, .compact])
        nested.customPrefix = ""
        nested.customSuffix = ""
        nested.append(_traits.values)
    }
}

// MARK: - GestureTraitCollection + Mergeable

extension GestureTraitCollection: Mergeable {
    package mutating func merge(_ other: GestureTraitCollection) {
        _traits.merge(other._traits) { $1 }
    }
}

import Synchronization
import os

// MARK: - TraitLabelStore

private final class TraitLabelStore {
    static let shared = TraitLabelStore()

    private static let counter = Atomic(0)

    private var labels: [Int: String] = [:]
    private let lock: OSAllocatedUnfairLock = .init()

    func register(_ label: String) -> Int {
        let (_, id) = Self.counter.add(1, ordering: .relaxed)
        lock.withLock {
            labels[id] = label
        }
        return id
    }

    func label(for rawValue: Int) -> String {
        lock.withLock {
            labels[rawValue]
        } ?? ""
    }
}
