//
//  LocationContaining.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import CoreGraphics

package protocol LocationContaining {
    var location: CGPoint { get }
}

extension CGPoint: LocationContaining {
    package var location: CGPoint {
        self
    }
}

extension Never: LocationContaining {
    package var location: CGPoint {
        _gesturesUnreachableCode()
    }
}
