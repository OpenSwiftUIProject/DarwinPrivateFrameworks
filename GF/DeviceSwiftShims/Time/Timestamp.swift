//
//  Timestamp.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - Timestamp

@frozen
public struct Timestamp: Hashable, Comparable, Sendable, CustomStringConvertible {
    package let value: Duration

    package init(value: Duration) {
        self.value = value
    }

    // MARK: - Comparable

    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        lhs.value < rhs.value
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        value.description
    }

    // MARK: - Strideable-like

    public func advanced(by duration: Duration) -> Timestamp {
        Timestamp(value: value + duration)
    }

    public func duration(to other: Timestamp) -> Duration {
        other.value - value
    }

    // MARK: - Arithmetic with Duration

    public static func + (lhs: Timestamp, rhs: Duration) -> Timestamp {
        Timestamp(value: lhs.value + rhs)
    }

    public static func - (lhs: Timestamp, rhs: Duration) -> Timestamp {
        Timestamp(value: lhs.value - rhs)
    }

    public static func - (lhs: Timestamp, rhs: Timestamp) -> Duration {
        lhs.value - rhs.value
    }

    public static func += (lhs: inout Timestamp, rhs: Duration) {
        lhs = lhs + rhs
    }

    public static func -= (lhs: inout Timestamp, rhs: Duration) {
        lhs = lhs - rhs
    }
}
