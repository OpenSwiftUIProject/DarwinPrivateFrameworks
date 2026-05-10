//
//  MapComponent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - MapComponent

package struct MapComponent<Upstream, Output>: Sendable
where Upstream: GestureComponent, Output: Sendable {
    package var upstream: Upstream
    package let map: @Sendable (GestureOutput<Upstream.Value>) throws -> GestureOutput<Output>

    package init(
        upstream: Upstream,
        map: @escaping @Sendable (GestureOutput<Upstream.Value>) throws -> GestureOutput<Output>
    ) {
        self.upstream = upstream
        self.map = map
    }
}

// MARK: - MapComponent + GestureComponent

extension MapComponent: GestureComponent {
    package typealias Value = Output

    package mutating func update(context: GestureComponentContext) throws -> GestureOutput<Output> {
        try map(upstream.tracingUpdate(context: context))
    }
}

// MARK: - MapComponent + CompositeGestureComponent

extension MapComponent: CompositeGestureComponent {}
