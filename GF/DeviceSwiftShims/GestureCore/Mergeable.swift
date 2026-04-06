//
//  Mergeable.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - Mergeable

@_spi(Private)
public protocol Mergeable {
    mutating func merge(_ other: Self)
}
