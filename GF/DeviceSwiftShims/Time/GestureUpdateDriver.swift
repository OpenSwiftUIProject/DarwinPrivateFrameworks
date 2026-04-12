//
//  GestureUpdateDriver.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - GestureUpdateDriver

/// Protocol for driving gesture update cycles.
public protocol GestureUpdateDriver: Sendable {
    func register(_ handler: @escaping () -> Void) -> GestureUpdateDriverToken

    func unregister(token: GestureUpdateDriverToken)
}

/// Token returned by GestureUpdateDriver.register.
public struct GestureUpdateDriverToken: Hashable, Sendable {
    public var value: UInt32

    public init(value: UInt32) {
        self.value = value
    }
}

#if canImport(Darwin)
import Foundation

// MARK: - RunLoopUpdateDriver

/// Drives gesture updates via CFRunLoop observer, synced with the main run loop.
package final class RunLoopUpdateDriver: GestureUpdateDriver, @unchecked Sendable {

    private static var lastToken: UInt32 = 0

    package var listeners: [GestureUpdateDriverToken: () -> Void] = [:]

    private lazy var runLoopObserver: CFRunLoopObserver! = CFRunLoopObserverCreateWithHandler(
        nil,
        CFRunLoopActivity.beforeWaiting.rawValue,
        true,
        0
    ) { [weak self] _, _ in
        self?.fireHandlers()
    }

    package init() {}

    package func register(_ handler: @escaping () -> Void) -> GestureUpdateDriverToken {
        Self.lastToken += 1
        let token = GestureUpdateDriverToken(value: Self.lastToken)
        listeners[token] = handler
        if listeners.count == 1 {
            CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, .commonModes)
        }
        return token
    }

    package func unregister(token: GestureUpdateDriverToken) {
        listeners.removeValue(forKey: token)
        if listeners.isEmpty {
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, .commonModes)
        }
    }

    private func fireHandlers() {
        for handler in listeners.values {
            handler()
        }
    }

    deinit {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, .commonModes)
    }
}

#endif
