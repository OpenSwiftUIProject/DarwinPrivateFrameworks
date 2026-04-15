//
//  TouchEvent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import CoreGraphics

// MARK: - TouchEvent

public struct TouchEvent: SpatialEvent, NestedCustomStringConvertible, Sendable {
    public var id: EventID
    public var phase: EventPhase
    public var timestamp: Timestamp
    public var location: CGPoint

    public init(id: EventID, phase: EventPhase, timestamp: Timestamp, location: CGPoint) {
        self.id = id
        self.phase = phase
        self.timestamp = timestamp
        self.location = location
    }
}
