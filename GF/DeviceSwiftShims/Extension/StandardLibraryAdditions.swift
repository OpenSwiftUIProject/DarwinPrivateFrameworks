//
//  StandardLibraryAdditions.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

extension Duration {
    package func asTimeInterval() -> Double {
        let (seconds, attoseconds) = components
        return Double(seconds) + Double(attoseconds) / 1e18
    }

    package static var max: Duration {
        Duration(secondsComponent: .max, attosecondsComponent: .max)
    }
}
