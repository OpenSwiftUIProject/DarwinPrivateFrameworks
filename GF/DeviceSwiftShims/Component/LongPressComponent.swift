////
////  LongPressComponent.swift
////  Gestures
////
////  Audited for 9126.1.5
////  Status: WIP
//
//// MARK: - LongPressComponent
//
///// A gesture component that recognizes long press gestures.
//public struct LongPressComponent<Upstream: GestureComponent>: Sendable where Upstream: Sendable {
//    public var maximumMovement: Double
//    public var maximumSeparationDistance: Double
//    public var pointCountTimeout: Duration
//    public var minimumDuration: Duration
//    public var maximumDuration: Duration
//    public var pointCount: Int
//    public var failOnExceedingMaximumPointCount: Bool
//    public var upstream: Upstream
//}
//
//// MARK: - CompositeGestureComponent
//
//extension LongPressComponent: CompositeGestureComponent {
//    public typealias Value = Upstream.Value
//
//    public func traits() -> GestureTraitCollection? {
//        .withTrait(.longPress(
//            pointCount: pointCount,
//            minimumDuration: minimumDuration,
//            maximumMovement: maximumMovement
//        ))
//    }
//
//    public mutating func update(context: GestureComponentContext) throws -> GestureOutput<Value> {
//        // TODO: Full long press recognition
//        try upstream.update(context: context)
//    }
//
//    public mutating func reset() {
//        upstream.reset()
//    }
//}
