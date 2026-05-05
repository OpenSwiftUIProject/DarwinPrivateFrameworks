//
//  UptimeTimeSource.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import Darwin

public struct UptimeTimeSource: TimeSourceImpl, Sendable {
    public init() {}

    public var _duration: Duration {
        let ns = clock_gettime_nsec_np(CLOCK_UPTIME_RAW)
        return .nanoseconds(Int64(ns))
    }
}
