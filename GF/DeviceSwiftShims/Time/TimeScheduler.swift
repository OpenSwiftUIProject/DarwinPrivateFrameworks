//
//  TimeScheduler.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

public import Dispatch

// MARK: - TimeScheduler

public protocol TimeScheduler: AnyObject, TimeSource {
    func schedule(
        after duration: Duration,
        handler: @escaping () -> Void,
        cancelHandler: (() -> Void)?
    ) -> TimeSchedulerToken

    func cancel(token: TimeSchedulerToken)
}

// MARK: - TimeSchedulerToken

public struct TimeSchedulerToken: Hashable, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - ScheduledJob

package struct ScheduledJob {
    package let workItem: DispatchWorkItem
    package let cancelHandler: (() -> Void)?

    package init(workItem: DispatchWorkItem, cancelHandler: (() -> Void)? = nil) {
        self.workItem = workItem
        self.cancelHandler = cancelHandler
    }
}

// MARK: - DispatchTimeScheduler

public final class DispatchTimeScheduler: @unchecked Sendable, TimeScheduler {
    public let queue: DispatchQueue
    public let timeSource: any TimeSource
    package var scheduledJobs: [TimeSchedulerToken: ScheduledJob] = [:]
    package var counter: Int = 0

    public init(queue: DispatchQueue, timeSource: any TimeSource) {
        self.queue = queue
        self.timeSource = timeSource
    }

    // MARK: - TimeSource

    public var timestamp: Timestamp {
        timeSource.timestamp
    }

    // MARK: - TimeScheduler

    public func schedule(
        after duration: Duration,
        handler: @escaping () -> Void,
        cancelHandler: (() -> Void)? = nil
    ) -> TimeSchedulerToken {
        counter += 1
        let token = TimeSchedulerToken(rawValue: counter)
        let workItem = DispatchWorkItem(block: handler)
        let job = ScheduledJob(workItem: workItem, cancelHandler: cancelHandler)
        scheduledJobs[token] = job
        let interval = duration.asTimeInterval()
        queue.asyncAfter(
            deadline: .now() + interval,
            execute: workItem
        )
        return token
    }

    public func cancel(token: TimeSchedulerToken) {
        guard let job = scheduledJobs.removeValue(forKey: token) else {
            return
        }
        guard !job.workItem.isCancelled else {
            return
        }
        job.workItem.cancel()
        job.cancelHandler?()
    }
}
