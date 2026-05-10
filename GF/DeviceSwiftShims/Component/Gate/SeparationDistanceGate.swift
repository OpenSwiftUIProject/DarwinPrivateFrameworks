//
//  SeparationDistanceGate.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import CoreGraphics

// MARK: - SeparationDistanceGate

package struct SeparationDistanceGate<Upstream>: Sendable
where Upstream: GestureComponent,
    Upstream.Value: Collection,
    Upstream.Value.Element: LocationContaining
{
    package enum Failure: Error, Hashable, Sendable {
        case exceedsAllowedDistance
    }

    package var upstream: Upstream
    package let distance: Double

    package init(
        upstream: Upstream,
        distance: Double
    ) {
        self.upstream = upstream
        self.distance = distance
    }
}

// MARK: - SeparationDistanceGate + GestureComponent

extension SeparationDistanceGate: GestureComponent {
    package typealias Value = Upstream.Value
}

// MARK: - SeparationDistanceGate + CompositeGestureComponent

extension SeparationDistanceGate: CompositeGestureComponent {}

// MARK: - SeparationDistanceGate + ValueTransformingComponent

extension SeparationDistanceGate: ValueTransformingComponent {
    package mutating func transform(
        _ value: Upstream.Value,
        isFinal: Bool,
        context: GestureComponentContext
    ) throws -> GestureOutput<Value> {
        if distance < .greatestFiniteMagnitude,
           let separationDistance = value.separationDistance,
           distance < separationDistance {
            throw Failure.exceedsAllowedDistance
        }
        return .value(value, isFinal: isFinal)
    }
}

// MARK: - Collection + Separation Distance

private extension Collection where Element: LocationContaining {
    var separationDistance: Double? {
        guard count >= 2 else {
            return nil
        }

        let rect = map { $0.location }.boundingRect
        let dx = Double(rect.minX - rect.maxX)
        let dy = Double(rect.minY - rect.maxY)
        return (dx * dx + dy * dy).squareRoot()
    }
}

// MARK: - CGPoint + Bounding Rect

extension Collection where Element == CGPoint {
    fileprivate var boundingRect: CGRect {
        guard !isEmpty else {
            return .null
        }
        let first = self[startIndex]
        var minX = Double(first.x)
        var minY = Double(first.y)
        var maxX = minX
        var maxY = minY
        for point in self {
            let x = Double(point.x)
            let y = Double(point.y)
            minX = Swift.min(minX, x)
            minY = Swift.min(minY, y)
            maxX = Swift.max(maxX, x)
            maxY = Swift.max(maxY, y)
        }
        return CGRect(
            x: minX,
            y: minY,
            width: maxX - minX,
            height: maxY - minY
        )
    }
}
