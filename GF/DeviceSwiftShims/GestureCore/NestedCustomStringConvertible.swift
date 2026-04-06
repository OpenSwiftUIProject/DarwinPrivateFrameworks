//
//  NestedCustomStringConvertible.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: WIP

// MARK: - NestedCustomStringConvertible

@_spi(Private)
public protocol NestedCustomStringConvertible: CustomDebugStringConvertible, CustomStringConvertible {
    var label: String { get }
}
