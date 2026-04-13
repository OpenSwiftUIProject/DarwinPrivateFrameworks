//
//  UpdateScheduler.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - UpdateScheduler

public final class UpdateScheduler {
    package let timeScheduler: any TimeScheduler

    package var scheduledRequests: [UpdateRequest: TimeSchedulerToken]

    package init(
        timeScheduler: any TimeScheduler,
        scheduledRequests: [UpdateRequest : TimeSchedulerToken]
    ) {
        self.timeScheduler = timeScheduler
        self.scheduledRequests = scheduledRequests
    }
}

@_spi(Private)
extension UpdateScheduler: TimeSource {
    public var timestamp: Timestamp {
        timeScheduler.timestamp
    }
}

// MARK: - UpdateRequest

package struct UpdateRequest: Hashable, Identifiable, CustomStringConvertible {
    package let id: UInt32
    package let creationTime: Timestamp
    package let targetTime: Timestamp
    package let tag: String?

    package init(
        id: UInt32,
        creationTime: Timestamp,
        targetTime: Timestamp,
        tag: String?
    ) {
        self.id = id
        self.creationTime = creationTime
        self.targetTime = targetTime
        self.tag = tag
    }

    package var description: String {
        let duration = targetTime - creationTime
        var result = "{ \(id)"
        if let tag {
            result += " \"\(tag)\""
        }
        result += ", \(duration) }"
        return result
    }
}
