//
//  Log.swift
//  Gestures

import Foundation
import Synchronization
import Darwin
package import os

private func logPreferencesChangedCallback(
    _ center: CFNotificationCenter?,
    _ observer: UnsafeMutableRawPointer?,
    _ name: CFNotificationName?,
    _ object: UnsafeRawPointer?,
    _ userInfo: CFDictionary?
) {
    Log.invalidateLoggingPreferencesCache()
}


// MARK: - LoggingEnabledState

package enum LoggingEnabledState: Int, AtomicRepresentable, Hashable, Sendable {
    case unknown
    case enabled
    case disabled
}

// MARK: - Log

package enum Log {
    private static let defaultsCacheState = Atomic(LoggingEnabledState.unknown)
    private static let observerRegistered = Atomic<UInt8>(0)

    package static let subsystem = "com.apple.Gestures"

    package static let hasInternalContent = true

    package static let isEnvironmentLoggingEnabled: Bool = {
        guard let value = getenv("GESTURES_LOGGING_ENABLED") else {
            return false
        }
        return atoi(value) != 0
    }()

    package static var isGesturesLoggingEnabled: Bool {
        guard hasInternalContent else {
            return false
        }
        if isEnvironmentLoggingEnabled {
            return true
        }
        switch defaultsCacheState.load(ordering: .acquiring) {
        case .unknown:
            break
        case .enabled:
            return true
        case .disabled:
            return false
        }
        guard let defaults = UserDefaults(suiteName: subsystem) else {
            return false
        }
        let isEnabled = defaults.bool(forKey: "LoggingEnabled")
        defaultsCacheState.store(
            isEnabled ? .enabled : .disabled,
            ordering: .releasing
        )
        registerLoggingPreferencesObserver()
        return isEnabled
    }

    fileprivate static func invalidateLoggingPreferencesCache() {
        defaultsCacheState.store(.unknown, ordering: .releasing)
    }

    private static func registerLoggingPreferencesObserver() {
        let result = observerRegistered.compareExchange(
            expected: 0,
            desired: 1,
            ordering: .acquiringAndReleasing
        )
        guard result.exchanged else {
            return
        }
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        let notificationName = "\(subsystem).LoggingPreferences" as CFString
        CFNotificationCenterAddObserver(
            center,
            nil,
            logPreferencesChangedCallback,
            notificationName,
            nil,
            .deliverImmediately
        )
    }

    private static let _nodes = Logger(subsystem: subsystem, category: "Nodes")

    package static var nodes: Logger {
        isGesturesLoggingEnabled ? _nodes : disabled
    }

    private static let _components = Logger(subsystem: subsystem, category: "Components")

    package static var components: Logger {
        isGesturesLoggingEnabled ? _components : disabled
    }

    package static let componentUpdates = Logger(subsystem: subsystem, category: "ComponentUpdates")

    private static let disabled = Logger(OSLog.disabled)

    @inline(__always)
    package static func logEnqueuedPhase(_ node: AnyGestureNode) {
        nodes.log("\(node.debugLabel) enqueued phase")
    }

    @inline(__always)
    package static func logFailedScheduledUpdate() {
        components.log("Failed to peform a scheduled update")
    }
}
