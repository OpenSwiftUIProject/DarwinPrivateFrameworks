//
//  MouseEvent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import CoreGraphics

// MARK: - MouseEvent

public struct MouseEvent: SpatialEvent, NestedCustomStringConvertible, Sendable {
    public let id: EventID
    public let phase: EventPhase
    public let timestamp: Timestamp
    public let location: CGPoint
    public let button: Button

    public init(id: EventID, phase: EventPhase, timestamp: Timestamp, location: CGPoint, button: Button) {
        self.id = id
        self.phase = phase
        self.timestamp = timestamp
        self.location = location
        self.button = button
    }

    // MARK: - Button

    public struct Button: RawRepresentable, Sendable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let primary = Button(rawValue: 1)

        public static let secondary = Button(rawValue: 2)

        public static let tertiary = Button(rawValue: 3)
    }
}
