//
//  UptimeTimeSource.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

public struct UptimeTimeSource: TimeSourceImpl, Sendable {
    public init() {}

    public var _duration: Duration {
        #if canImport(Darwin)
        let ns = clock_gettime_nsec_np(CLOCK_UPTIME_RAW)
        return .nanoseconds(Int64(ns))
        #else
        var ts = timespec()
        clock_gettime(CLOCK_MONOTONIC, &ts)
        let totalNs = Int64(ts.tv_sec) * 1_000_000_000 + Int64(ts.tv_nsec)
        return .nanoseconds(totalNs)
        #endif
    }
}
