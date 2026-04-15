//
//  Event.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - Event

public protocol Event: Identifiable {
    var id: EventID { get }
    var phase: EventPhase { get }
    var timestamp: Timestamp { get }
}

// MARK: - Never + Event

extension Never: Event {
    public var id: EventID { _gesturesUnreachableCode() }
    public var phase: EventPhase { _gesturesUnreachableCode() }
}

// MARK: - EventPhase

public enum EventPhase: Hashable, Sendable {
    case began
    case active
    case ended
    case failed
}
