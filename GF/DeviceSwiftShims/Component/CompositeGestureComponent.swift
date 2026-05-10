//
//  CompositeGestureComponent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - CompositeGestureComponent

/// A gesture component that wraps an upstream component, enabling chaining.
public protocol CompositeGestureComponent: GestureComponent {
    associatedtype Upstream: GestureComponent
    var upstream: Upstream { get set }
}

extension CompositeGestureComponent {
    public mutating func reset() {
        upstream.reset()
    }

    public mutating func traits() -> GestureTraitCollection? {
        upstream.traits()
    }

    public mutating func capacity<E: Event>(for eventType: E.Type) -> Int {
        upstream.capacity(for: eventType)
    }
}
