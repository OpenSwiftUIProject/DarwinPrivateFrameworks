//
//  GesturePhaseQueue.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - GesturePhaseQueue

/// A queue of gesture phase transitions.
package struct GesturePhaseQueue<Value: Sendable> {
    package var timeSource: (any TimeSource)?
    package var currentPhase: GesturePhase<Value>
    package var pendingPhases: RingBuffer<GesturePhase<Value>>

    package init(
        timeSource: (any TimeSource)? = nil,
        currentPhase: GesturePhase<Value> = .idle,
        pendingPhases: RingBuffer<GesturePhase<Value>> = .init(capacity: 5, emptyValue: .idle)
    ) {
        self.timeSource = timeSource
        self.currentPhase = currentPhase
        self.pendingPhases = pendingPhases
    }

    package var latestPhase: GesturePhase<Value> {
        pendingPhases.last ?? currentPhase
    }

    package mutating func enqueue(_ phase: GesturePhase<Value>) throws {
        let latestPhase = latestPhase
        guard latestPhase.canTransition(to: phase) else {
            throw InvalidTransition(phase: latestPhase, targetPhase: phase)
        }
        pendingPhases.append(phase)
    }

    package mutating func processNextPhase() -> (oldPhase: GesturePhase<Value>, newPhase: GesturePhase<Value>)? {
        guard !pendingPhases.isEmpty else { return nil }
        let oldPhase = currentPhase
        let newPhase = pendingPhases.removeFirst()
        currentPhase = newPhase
        return (oldPhase, newPhase)
    }
}

// MARK: - GesturePhaseQueue.InvalidTransition

extension GesturePhaseQueue {
    package struct InvalidTransition: Error {
        package var phase: GesturePhase<Value>
        package var targetPhase: GesturePhase<Value>

        package init(phase: GesturePhase<Value>, targetPhase: GesturePhase<Value>) {
            self.phase = phase
            self.targetPhase = targetPhase
        }
    }
}

extension GesturePhaseQueue.InvalidTransition: NestedCustomStringConvertible {}

// MARK: - GesturePhase Transition Rules

extension GesturePhase {
    package func canTransition(to targetPhase: GesturePhase<Value>) -> Bool {
        switch (self, targetPhase) {
        case (.idle, .possible):
            true
        case (.possible, .blocked),
             (.possible, .active),
             (.possible, .ended),
             (.possible, .failed):
            true
        case (.blocked, .blocked),
             (.blocked, .active),
             (.blocked, .ended),
             (.blocked, .failed):
            true
        case (.active, .active),
             (.active, .ended),
             (.active, .failed):
            true
        case (.ended, .idle),
             (.failed, .idle):
            true
        default:
            false
        }
    }
}
