////
////  TapComponent.swift
////  Gestures
////
////  Audited for 9126.1.5
////  Status: WIP
//
//// MARK: - TapComponent
//
///// A gesture component that recognizes tap gestures.
//public struct TapComponent<Upstream: GestureComponent>: Sendable where Upstream: Sendable {
//    public var maximumMovement: Double
//    public var maximumSeparationDistance: Double
//    public var tapInterval: Duration
//    public var pointCountTimeout: Duration
//    public var minimumDuration: Duration
//    public var maximumDuration: Duration
//    public var tapCount: Int
//    public var pointCount: Int
//    public var failOnExceedingMaximumPointCount: Bool
//    public var upstream: Upstream
//}
//
//// MARK: - CompositeGestureComponent
//
//extension TapComponent: CompositeGestureComponent {
//    public typealias Value = Upstream.Value
//
//    public func traits() -> GestureTraitCollection? {
//        .withTrait(.tap(tapCount: tapCount, pointCount: pointCount))
//    }
//
//    public mutating func update(context: GestureComponentContext) throws -> GestureOutput<Value> {
//        // TODO: Full tap recognition state machine
//        try upstream.update(context: context)
//    }
//
//    public mutating func reset() {
//        upstream.reset()
//    }
//}
