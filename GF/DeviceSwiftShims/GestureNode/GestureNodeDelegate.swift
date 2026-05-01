//
//  GestureNodeDelegate.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - GestureNodeDelegate

/// Protocol for receiving gesture node state change notifications.
public protocol GestureNodeDelegate<Value>: AnyObject, Sendable {
    associatedtype Value: Sendable

    func gestureNodeShouldActivate(
        _ node: GestureNode<Value>
    ) -> Bool

    func gestureNode(
        _ node: GestureNode<Value>,
        didEnqueuePhase phase: GesturePhase<Value>
    )

    func gestureNode(
        _ node: GestureNode<Value>,
        didUpdatePhase newPhase: GesturePhase<Value>,
        oldPhase: GesturePhase<Value>
    )

    func gestureNode(
        _ node: GestureNode<Value>,
        roleForRelationType type: GestureRelationType,
        direction: GestureRelationDirection,
        relatedNode: AnyGestureNode
    ) -> GestureRelationRole?
}
