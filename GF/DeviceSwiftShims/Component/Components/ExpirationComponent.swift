//
//  ExpirationComponent.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import Synchronization

// MARK: - Expirable

package protocol Expirable: Sendable {
    associatedtype Value: Sendable

    var payload: ExpirablePayload<Value> { get }

    var expiration: Expiration? { get }
}

// MARK: - ExpirationComponent

package struct ExpirationComponent<Upstream>: Sendable where Upstream: GestureComponent, Upstream.Value: Expirable {

    package var upstream: Upstream

    package struct State: GestureComponentState, NestedCustomStringConvertible, Sendable {
        package var request: UpdateRequest?

        package init() {
            request = nil
        }

        package init(request: UpdateRequest?) {
            self.request = request
        }
    }

    package var state: State

    package init(
        upstream: Upstream,
        state: State = .init()
    ) {
        self.upstream = upstream
        self.state = state
    }

    package enum Failure: Error, Sendable {
        case timeout(reason: ExpirationReason)
    }
}

// MARK: - ExpirationComponent + GestureComponent

extension ExpirationComponent: GestureComponent {
    package typealias Value = Upstream.Value.Value
}

extension ExpirationComponent: CompositeGestureComponent {}

extension ExpirationComponent: StatefulGestureComponent {}

extension ExpirationComponent: ValueTransformingComponent {
    package mutating func transform(
        _ value: Upstream.Value,
        isFinal: Bool,
        context: GestureComponentContext
    ) throws -> GestureOutput<Value> {
        let metadata = try metadata(
            for: value.expiration,
            context: context
        )
        switch value.payload {
        case let .empty(reason):
            return .empty(reason, metadata: metadata)
        case let .value(payload):
            return .value(
                payload,
                isFinal: isFinal,
                metadata: metadata
            )
        }
    }

    private mutating func metadata(
        for expiration: Expiration?,
        context: GestureComponentContext
    ) throws -> GestureOutputMetadata {
        let updatesToSchedule: [UpdateRequest]
        let updatesToCancel: [UpdateRequest]
        if let expiration {
            guard context.currentTime < expiration.deadline else {
                throw Failure.timeout(reason: expiration.reason)
            }

            if state.request?.targetTime == expiration.deadline {
                updatesToSchedule = []
                updatesToCancel = []
            } else {
                updatesToCancel = cancelStoredRequest()
                updatesToSchedule = [scheduleRequest(for: expiration, context: context)]
            }
        } else {
            updatesToSchedule = []
            updatesToCancel = cancelStoredRequest()
        }
        return GestureOutputMetadata(
            updatesToSchedule: updatesToSchedule,
            updatesToCancel: updatesToCancel
        )
    }

    private mutating func cancelStoredRequest() -> [UpdateRequest] {
        guard let request = state.request else {
            return []
        }
        state.request = nil
        return [request]
    }

    private mutating func scheduleRequest(
        for expiration: Expiration,
        context: GestureComponentContext
    ) -> UpdateRequest {
        let request = UpdateRequest(
            id: ExpirationComponentRequestID.next(),
            creationTime: context.currentTime,
            targetTime: expiration.deadline,
            tag: expiration.reason.rawValue
        )
        state.request = request
        return request
    }
}

// MARK: - ExpirationComponentRequestID

// FIXE: Should it in UpdateRequest namespace?
private enum ExpirationComponentRequestID {
    private static let nextID = Atomic(UInt32.zero)

    static func next() -> UInt32 {
        let (_, id) = nextID.add(1, ordering: .relaxed)
        return id
    }
}

// MARK: - ExpirationRecord

package struct ExpirationRecord<Value: Sendable>: Expirable, NestedCustomStringConvertible, Sendable {
    package var payload: ExpirablePayload<Value>
    package var expiration: Expiration?

    package init(
        payload: ExpirablePayload<Value>,
        expiration: Expiration?
    ) {
        self.payload = payload
        self.expiration = expiration
    }
}

// MARK: - ExpirablePayload

package enum ExpirablePayload<Value: Sendable>: NestedCustomStringConvertible, Sendable {
    case empty(GestureOutputEmptyReason)
    case value(Value)

    package func populateNestedDescription(_ nested: inout NestedDescription) {
        switch self {
        case let .empty(reason):
            nested.append(reason, label: "reason")
        case let .value(value):
            nested.append(value, label: "value")
        }
    }
}

// MARK: - GestureOutput + ExpirationRecord

extension GestureOutput {
    package static func value(
        _ value: Value,
        isFinal: Bool,
        expiration: Expiration?
    ) -> GestureOutput<ExpirationRecord<Value>> {
        .value(
            ExpirationRecord(
                payload: .value(value),
                expiration: expiration
            ),
            isFinal: isFinal
        )
    }

    package func expired(
        with expiration: Expiration?
    ) -> GestureOutput<ExpirationRecord<Value>> {
        switch self {
        case let .empty(reason, metadata):
            return .value(
                ExpirationRecord<Value>(
                    payload: .empty(reason),
                    expiration: expiration
                ),
                metadata: metadata
            )
        case let .value(value, metadata):
            return .value(
                ExpirationRecord(
                    payload: .value(value),
                    expiration: expiration
                ),
                metadata: metadata
            )
        case let .finalValue(value, metadata):
            return .finalValue(
                ExpirationRecord(
                    payload: .value(value),
                    expiration: expiration
                ),
                metadata: metadata
            )
        }
    }
}
