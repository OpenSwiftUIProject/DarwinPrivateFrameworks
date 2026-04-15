//
//  ScrollEvent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import CoreGraphics

// MARK: - ScrollEvent

/// A scroll event with delta values.
public protocol ScrollEvent: SpatialEvent {
    var delta: CGVector { get }
    var acceleratedDelta: CGVector { get }
}

// MARK: - Never + ScrollEvent

extension Never: ScrollEvent {
    public var delta: CGVector { _gesturesUnreachableCode() }
    public var acceleratedDelta: CGVector { _gesturesUnreachableCode() }
}

// MARK: - ConcreteScrollEvent

public struct ConcreteScrollEvent: ScrollEvent, NestedCustomStringConvertible, Sendable {
    public var id: EventID
    public var phase: EventPhase
    public var timestamp: Timestamp
    public var location: CGPoint
    public var delta: CGVector
    public var acceleratedDelta: CGVector

    public init(
        id: EventID,
        phase: EventPhase,
        timestamp: Timestamp,
        location: CGPoint,
        delta: CGVector,
        acceleratedDelta: CGVector
    ) {
        self.id = id
        self.phase = phase
        self.timestamp = timestamp
        self.location = location
        self.delta = delta
        self.acceleratedDelta = acceleratedDelta
    }
}
