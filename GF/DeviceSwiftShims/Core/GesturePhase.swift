//
//  GesturePhase.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - GesturePhase

/// The phase of a gesture recognition state machine.
///
/// A gesture progresses through phases as it processes events:
///
/// ```
///          ┌──────────┐
///          │   idle   │
///          └────┬─────┘
///               ▼
///          ┌──────────┐
///          │ possible │
///          └──┬────┬──┘
///             ▼    └────►┌─────────┐
///          ┌────────┐◄──►│ blocked │
///          │ active │    └────┬────┘
///          └───┬────┘        ▼
///              ▼          ┌────────┐
///          ┌───────┐      │ failed │
///          │ ended │      └────────┘
///          └───────┘
/// ```
///
/// - `idle`: The gesture is not participating in recognition.
/// - `possible`: The gesture is evaluating incoming events.
/// - `active`: The gesture is actively recognized and producing values.
/// - `blocked`: The gesture is recognized but blocked by another gesture.
///   Can transition to `active` when the blocking gesture resolves.
/// - `ended`: The gesture completed successfully with a final value.
/// - `failed`: The gesture failed for a specific reason.
public enum GesturePhase<Value: Sendable>: Sendable {

    /// The gesture is not participating in recognition.
    case idle

    /// The gesture is evaluating incoming events.
    case possible

    /// The gesture is recognized but blocked by another gesture.
    case blocked(value: Value, blockedBy: GestureNodeID)

    /// The gesture is actively recognized and producing values.
    case active(value: Value)

    /// The gesture completed successfully.
    case ended(value: Value)

    /// The gesture failed.
    case failed(reason: GestureFailureReason)
}

extension GesturePhase {
    /// Whether the phase is ``idle``.
    public var isIdle: Bool {
        switch self {
        case .idle: true
        default: false
        }
    }

    /// Whether the phase is ``possible``.
    public var isPossible: Bool {
        switch self {
        case .possible: true
        default: false
        }
    }

    /// Whether the phase is ``active(value:)``.
    public var isActive: Bool {
        switch self {
        case .active: true
        default: false
        }
    }

    /// Whether the phase is ``blocked(value:blockedBy:)``.
    public var isBlocked: Bool {
        switch self {
        case .blocked: true
        default: false
        }
    }

    /// Whether the phase is ``ended(value:)``.
    public var isEnded: Bool {
        switch self {
        case .ended: true
        default: false
        }
    }

    /// Whether the phase is ``failed(reason:)``.
    public var isFailed: Bool {
        switch self {
        case .failed: true
        default: false
        }
    }

    /// Whether the phase is terminal (``ended(value:)`` or ``failed(reason:)``).
    ///
    /// A terminal phase indicates the gesture has finished processing
    /// and will not produce further updates.
    public var isTerminal: Bool {
        switch self {
        case .ended, .failed: true
        default: false
        }
    }

    /// Whether the gesture has been recognized.
    ///
    /// Returns `true` for ``blocked(value:blockedBy:)``, ``active(value:)``,
    /// and ``ended(value:)`` — all phases where the gesture has produced a value.
    public var isRecognized: Bool {
        switch self {
        case .blocked, .active, .ended: true
        default: false
        }
    }

    /// The associated value, if the phase carries one.
    ///
    /// Returns a value for ``blocked(value:blockedBy:)``, ``active(value:)``,
    /// and ``ended(value:)``. Returns `nil` for all other phases.
    public var value: Value? {
        switch self {
        case .blocked(let v, _): v
        case .active(let v): v
        case .ended(let v): v
        default: nil
        }
    }

    /// The failure reason, if the phase is ``failed(reason:)``.
    public var failureReason: GestureFailureReason? {
        if case .failed(let reason) = self { return reason }
        return nil
    }

    /// Returns a new phase with the value transformed by the given closure.
    ///
    /// For phases that carry a value (``blocked(value:blockedBy:)``,
    /// ``active(value:)``, ``ended(value:)``), the closure is applied to
    /// produce the new value. Other phases are passed through unchanged.
    public func mapValue<T: Sendable>(_ transform: (Value) -> T) -> GesturePhase<T> {
        switch self {
        case .blocked(let v, let id): .blocked(value: transform(v), blockedBy: id)
        case .active(let v): .active(value: transform(v))
        case .ended(let v): .ended(value: transform(v))
        case .failed(let r): .failed(reason: r)
        case .idle: .idle
        case .possible: .possible
        }
    }
}

// MARK: - GesturePhase + CustomStringConvertible

extension GesturePhase: CustomStringConvertible {
    public var description: String {
        switch self {
        case .blocked(_, let id): "blocked(by: \(id))"
        case .active: "active"
        case .ended: "ended"
        case .failed(let reason): "failed(\(reason))"
        case .idle: "idle"
        case .possible: "possible"
        }
    }
}

// MARK: - GestureFailureReason

/// The reason a gesture recognition failed.
///
/// Failure reasons fall into two categories:
/// - **External**: caused by another gesture (``excluded(by:)``, ``failureDependency(on:)``).
/// - **Internal**: caused by the gesture system or component logic
///   (``disabled``, ``removedFromContainer``, ``activationDenied``,
///   ``aborted``, ``coordinatorChanged``, ``custom(_:)``).
public enum GestureFailureReason: Sendable {

    /// The gesture was excluded by another gesture's exclusion relation.
    case excluded(by: GestureNodeID)

    /// The gesture failed because a required gesture dependency failed.
    case failureDependency(on: GestureNodeID)

    /// The gesture failed with a custom error from the component.
    case custom(any Error)

    /// The gesture node is disabled.
    case disabled

    /// The gesture node was removed from its container.
    case removedFromContainer

    /// The gesture's activation was denied by the coordinator.
    case activationDenied

    /// The gesture was aborted.
    case aborted

    /// The gesture's coordinator changed.
    case coordinatorChanged
}

// MARK: - GestureFailureReason + CustomStringConvertible

extension GestureFailureReason: CustomStringConvertible {
    public var description: String {
        switch self {
        case .excluded(let id): "excludedBy: \(id)"
        case .failureDependency(let id): "failureDependency(on: \(id))"
        case .custom(let error): "\(error)"
        case .disabled: "disabled"
        case .removedFromContainer: "removedFromContainer"
        case .activationDenied: "activationDenied"
        case .aborted: "aborted"
        case .coordinatorChanged: "coordinatorChanged"
        }
    }
}
