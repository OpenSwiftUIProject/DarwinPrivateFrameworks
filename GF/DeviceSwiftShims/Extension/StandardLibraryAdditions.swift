//
//  StandardLibraryAdditions.swift
//  Gestures

extension Double {
    package init(_ duration: Duration) {
        let (seconds, attoseconds) = duration.components
        self = Double(seconds) + Double(attoseconds) / 1e18
    }
}
