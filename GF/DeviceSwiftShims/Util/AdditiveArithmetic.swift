//
//  AdditiveArithmetic.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import CoreGraphics

// MARK: - _AdditiveArithmetic

package protocol _AdditiveArithmetic: Equatable {
    static var zero: Self { get }

    static func + (lhs: Self, rhs: Self) -> Self
    static func += (lhs: inout Self, rhs: Self)
    static func - (lhs: Self, rhs: Self) -> Self
    static func -= (lhs: inout Self, rhs: Self)
}

extension _AdditiveArithmetic {
    package static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    package static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}

// MARK: - Double + _AdditiveArithmetic

extension Double: _AdditiveArithmetic {}

// MARK: - CGPoint + _AdditiveArithmetic

extension CGPoint: _AdditiveArithmetic {
    package static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    package static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

// MARK: - CGVector + _AdditiveArithmetic

extension CGVector: _AdditiveArithmetic {
    package static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    package static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
}

// MARK: - CGSize + _AdditiveArithmetic

extension CGSize: _AdditiveArithmetic {
    package static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    package static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
}
