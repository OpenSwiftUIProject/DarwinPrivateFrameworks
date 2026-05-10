//
//  Interpolatable.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import CoreGraphics

// MARK: - Interpolatable

package protocol Interpolatable: Sendable {
    func scaled(by rhs: Double) -> Self

    static func + (lhs: Self, rhs: Self) -> Self
}

// MARK: - Interpolatable Helpers

extension Interpolatable {
    package static func mix(
        _ lhs: Self,
        _ rhs: Self,
        by t: Double
    ) -> Self {
        rhs.scaled(by: 1 - t) + lhs.scaled(by: t)
    }

    package mutating func mix(
        with other: Self,
        by t: Double
    ) {
        self = Self.mix(other, self, by: t)
    }

    package func scaled(byInverseOf rhs: Double) -> Self {
        scaled(by: 1 / rhs)
    }
}

// MARK: - Interpolatable Conformance

extension CGPoint: Interpolatable {}

extension CGVector: Interpolatable {}
