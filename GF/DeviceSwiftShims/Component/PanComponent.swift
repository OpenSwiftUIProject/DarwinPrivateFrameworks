////
////  PanComponent.swift
////  Gestures
////
////  Audited for 9126.1.5
////  Status: WIP
//
//public import OpenCoreGraphicsShims
//
//// MARK: - PanComponent
//
///// A gesture component that recognizes pan (drag) gestures.
//public struct PanComponent<Upstream: GestureComponent>: Sendable where Upstream: Sendable {
//    public var hysteresis: Double
//    public var maximumSeparationDistance: Double
//    public var pointCountTimeout: Duration
//    public var minimumPointCount: Int
//    public var maximumPointCount: Int
//    public var failOnExceedingMaximumPointCount: Bool
//    public var invertScrollingDirection: Bool
//    public var preferNonAcceleratedScrollingDelta: Bool
//    public var ignoreStationaryPoints: Bool
//    public var upstream: Upstream
//}
//
//// MARK: - CompositeGestureComponent
//
//extension PanComponent: CompositeGestureComponent {
//    public typealias Value = Upstream.Value
//
//    public func traits() -> GestureTraitCollection? {
//        .withTrait(.pan())
//    }
//
//    public mutating func update(context: GestureComponentContext) throws -> GestureOutput<Value> {
//        // TODO: Full pan recognition (hysteresis, translation, velocity)
//        try upstream.update(context: context)
//    }
//
//    public mutating func reset() {
//        upstream.reset()
//    }
//}
//
//// MARK: - PanComponentValue
//
///// Value produced by a pan gesture, including location, translation, and velocity.
//public struct PanComponentValue: Sendable {
//    public var location: CGPoint
//    public var translation: CGVector
//    package var _velocity: CGVector
//
//    public var velocity: CGVector {
//        let predicted = predictedEndLocation
//        return CGVector(
//            dx: (predicted.x - location.x) * 4.0,
//            dy: (predicted.y - location.y) * 4.0
//        )
//    }
//
//    public var predictedEndLocation: CGPoint {
//        CGPoint(
//            x: location.x + _velocity.dx * 0.25,
//            y: location.y + _velocity.dy * 0.25
//        )
//    }
//
//    public var predictedEndTranslation: CGVector {
//        CGVector(
//            dx: translation.dx + _velocity.dx * 0.25,
//            dy: translation.dy + _velocity.dy * 0.25
//        )
//    }
//
//    public init(
//        location: CGPoint,
//        translation: CGVector,
//        velocity: CGVector
//    ) {
//        self.location = location
//        self.translation = translation
//        self._velocity = velocity
//    }
//}
//
//extension PanComponentValue: NestedCustomStringConvertible {}
