//
//  GestureComponentState.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - StatefulGestureComponent

/// A gesture component that maintains mutable state across updates.
public protocol StatefulGestureComponent: GestureComponent {
    associatedtype State: GestureComponentState
    var state: State { get set }
}

extension StatefulGestureComponent {
    public mutating func reset() {
        state = State()
    }
}

extension CompositeGestureComponent where Self: StatefulGestureComponent {
    public mutating func reset() {
        upstream.reset()
        state = State()
    }
}

// MARK: - GestureComponentState

public protocol GestureComponentState: Sendable {
    init()
}
