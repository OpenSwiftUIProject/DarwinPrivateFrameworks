//
//  Mergeable.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - Mergeable

package protocol Mergeable {
    mutating func merge(_ other: Self)
}
