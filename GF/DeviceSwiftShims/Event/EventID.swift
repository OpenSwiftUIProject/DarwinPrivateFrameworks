//
//  EventID.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - EventID

public struct EventID: Hashable, CustomStringConvertible, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public var description: String {
        rawValue.description
    }
}
