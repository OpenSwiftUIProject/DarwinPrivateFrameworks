//
//  GFGesturePhase.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

extension GFGesturePhase: Swift.CustomStringConvertible {
    public var description: String {
        switch self {
        case .idle: "idle"
        case .possible: "possible"
        case .began: "began"
        case .changed: "changed"
        case .ended: "ended"
        case .cancelled: "cancelled"
        case .failed: "failed"
        @unknown default: preconditionFailure("Unknown phase: \(self)")
        }
    }
}
