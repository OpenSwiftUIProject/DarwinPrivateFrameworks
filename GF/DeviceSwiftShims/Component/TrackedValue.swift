//
//  TrackedValue.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import CoreGraphics

// MARK: - TrackedValue

@frozen
package struct TrackedValue<Value: Sendable>: Sendable {
    package var current: Value
    package var previous: Value?
    package var initial: Value

    package init(current: Value, previous: Value?, initial: Value) {
        self.current = current
        self.previous = previous
        self.initial = initial
    }
}

// MARK: - TrackedValue + NestedCustomStringConvertible

extension TrackedValue: NestedCustomStringConvertible {}

// MARK: - TrackedValue + LocationContaining

extension TrackedValue: LocationContaining where Value: LocationContaining {
    package var location: CGPoint {
        current.location
    }

    package var locationTranslation: CGPoint {
        current.location - initial.location
    }
}

// MARK: - TrackedValue + Equatable

extension TrackedValue: Equatable where Value: Equatable {}
