//
//  LocationContaining.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import CoreGraphics

// MARK: - LocationContaining

public protocol LocationContaining {
    var location: CGPoint { get }
}

// MARK: - CGPoint + LocationContaining

extension CGPoint: LocationContaining {
    public var location: CGPoint {
        self
    }
}

// MARK: - Never + LocationContaining

extension Never: LocationContaining {
    public var location: CGPoint {
        _gesturesUnreachableCode()
    }
}

// MARK: - IdentifiableLocation [WIP]

package struct IdentifiableLocation<ID> where ID: Hashable {
    package var id: ID
    package var location: CGPoint
}
