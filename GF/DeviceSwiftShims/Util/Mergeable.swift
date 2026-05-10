//
//  Mergeable.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - Mergeable

package protocol Mergeable {
    func merging(_ other: Self) -> Self
}

extension Mergeable {
    package mutating func merge(_ other: Self) {
        self = merging(other)
    }
}
