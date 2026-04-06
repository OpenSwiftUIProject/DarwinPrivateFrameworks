//
//  GestureNodeID.swift
//  OpenGestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - GestureNodeID

/// A unique identifier for a gesture node.
@frozen
public struct GestureNodeID: Hashable, Comparable, Sendable, CustomStringConvertible {
    package let rawValue: UInt32

    package init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static func < (lhs: GestureNodeID, rhs: GestureNodeID) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public var description: String {
        rawValue.description
    }
}
