//
//  Expiration.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - Expiration

package struct Expiration: Sendable {
    package var deadline: Timestamp
    package var reason: ExpirationReason

    package init(
        deadline: Timestamp,
        reason: ExpirationReason
    ) {
        self.deadline = deadline
        self.reason = reason
    }
}

// MARK: - ExpirationReason

package struct ExpirationReason: ExpressibleByStringLiteral, CustomStringConvertible, Sendable {
    package let rawValue: String

    package init(rawValue: String) {
        self.rawValue = rawValue
    }

    package init(stringLiteral value: String) {
        self.rawValue = value
    }

    package var description: String {
        rawValue
    }
}
