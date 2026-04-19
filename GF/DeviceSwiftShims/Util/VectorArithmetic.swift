//
//  VectorArithmetic.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import CoreGraphics

// MARK: - VectorArithmetic

package protocol VectorArithmetic: _AdditiveArithmetic {
    var magnitude: Double { get }

    func scaled(by rhs: Double) -> Self
}

// MARK: - VectorArithmetic Conformance

extension Double: VectorArithmetic {
    package var magnitude: Double {
        abs(self)
    }

    package func scaled(by rhs: Double) -> Double {
        self * rhs
    }
}

extension CGPoint: VectorArithmetic {
    package var magnitude: Double {
        hypot(abs(x), abs(y))
    }

    package func scaled(by rhs: Double) -> CGPoint {
        CGPoint(x: x * rhs, y: y * rhs)
    }
}

extension CGVector: VectorArithmetic {
    package var magnitude: Double {
        hypot(abs(dx), abs(dy))
    }

    package func scaled(by rhs: Double) -> CGVector {
        CGVector(dx: dx * rhs, dy: dy * rhs)
    }
}

// MARK: - VectorContaining

package protocol VectorContaining {
    associatedtype VectorType: VectorArithmetic

    var vector: VectorType { get set }
}

// MARK: - VectorContaining Conformance

extension Double: VectorContaining {
    package typealias VectorType = Double

    package var vector: Double {
        get { self }
        set { self = newValue }
    }
}

extension CGPoint: VectorContaining {
    package typealias VectorType = CGPoint

    package var vector: CGPoint {
        get { self }
        set { self = newValue }
    }
}

extension CGVector: VectorContaining {
    package typealias VectorType = CGVector

    package var vector: CGVector {
        get { self }
        set { self = newValue }
    }
}
