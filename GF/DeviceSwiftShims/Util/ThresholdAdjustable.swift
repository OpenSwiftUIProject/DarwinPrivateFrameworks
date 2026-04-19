//
//  ThresholdAdjustable.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import CoreGraphics

// MARK: - ThresholdAdjustable

/// A value whose backing vector can consume a threshold-sized movement.
package protocol ThresholdAdjustable: VectorContaining {
    /// The scalar threshold type used to gate movement.
    associatedtype Threshold

    /// Consumes up to `threshold` units from `movement`.
    ///
    /// When `movement` reaches the threshold, this subtracts the threshold-sized
    /// portion of `movement` from `vector` and returns that consumed movement.
    /// Returns `nil` without mutation when `threshold` is not positive or
    /// `movement` is below threshold.
    mutating func consume(_ threshold: Threshold, from movement: VectorType) -> VectorType?
}

extension ThresholdAdjustable where Threshold == Double {
    package mutating func consume(_ threshold: Double, from movement: VectorType) -> VectorType? {
        guard threshold > 0 else { return nil }

        let movementMagnitude = movement.magnitude
        guard movementMagnitude >= threshold else { return nil }

        let scale = threshold / movementMagnitude
        let consumedMovement = movement.scaled(by: scale)
        vector -= consumedMovement
        return consumedMovement
    }
}

// MARK: - ThresholdAdjustable Conformance

extension Double: ThresholdAdjustable {
    package typealias Threshold = Double
}

extension CGPoint: ThresholdAdjustable {
    package typealias Threshold = Double
}

extension CGVector: ThresholdAdjustable {
    package typealias Threshold = Double
}
