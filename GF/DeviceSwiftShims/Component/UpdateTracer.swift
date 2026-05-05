//
//  UpdateTracer.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

import os

// MARK: - UpdateTracer

/// Records nested gesture component updates and renders the resulting trace tree.
///
/// An update trace starts with ``beginTrace()`` and is completed with
/// ``endTrace(snapshot:)``. Completed traces are linked through
/// ``Trace/upstreamTraces`` so the final head trace can be rendered and emitted
/// by ``logTrace()``.
package class UpdateTracer: @unchecked Sendable {
    /// The monotonically increasing identifier assigned to newly started traces.
    package var seed: Int16

    /// The most recently completed trace tree waiting to be attached or logged.
    package var traceHead: Trace?

    /// The stack of traces currently being updated.
    package var activeTraces: [Trace]

    /// Completed trace heads waiting for their active parent trace to finish.
    package var pendingBranches: [Int16: [Trace]]

    /// Snapshot data keyed by trace identifier.
    package var dataSnapshots: [Int16: TraceDataSnapshot]

    /// Creates an update tracer with the supplied internal state.
    ///
    /// - Parameters:
    ///   - seed: The current trace identifier seed.
    ///   - traceHead: The most recently completed trace tree, if any.
    ///   - activeTraces: The stack of in-flight traces.
    ///   - pendingBranches: Completed trace heads waiting for a parent trace.
    ///   - dataSnapshots: Snapshot data keyed by trace identifier.
    package init(
        seed: Int16 = 0,
        traceHead: Trace? = nil,
        activeTraces: [Trace] = [],
        pendingBranches: [Int16: [Trace]] = [:],
        dataSnapshots: [Int16: TraceDataSnapshot] = [:]
    ) {
        self.seed = seed
        self.traceHead = traceHead
        self.activeTraces = activeTraces
        self.pendingBranches = pendingBranches
        self.dataSnapshots = dataSnapshots
    }

    /// Starts a new active trace.
    ///
    /// If a completed trace head already exists while another trace is active,
    /// the head is staged as a pending upstream branch for the active trace.
    package func beginTrace() {
        seed = seed &+ 1
        if let traceHead, let activeTrace = activeTraces.last {
            pendingBranches[activeTrace.id, default: []].append(traceHead)
            self.traceHead = nil
        }
        activeTraces.append(Trace(id: seed))
    }

    /// Completes the current active trace with its captured snapshot.
    ///
    /// The completed trace becomes ``traceHead`` after attaching any previous
    /// trace head and pending branches as upstream traces.
    ///
    /// - Parameter snapshot: The captured component, state, and result summary
    ///   for the current trace.
    package func endTrace(snapshot: TraceDataSnapshot) {
        var trace = activeTraces.popLast()!
        dataSnapshots[trace.id] = snapshot
        if let traceHead {
            trace.upstreamTraces.append(traceHead)
        }
        if let pending = pendingBranches.removeValue(forKey: trace.id) {
            trace.upstreamTraces.append(contentsOf: pending)
        }
        traceHead = trace
    }

    /// Emits the current trace tree to the component update log.
    ///
    /// If there is no completed trace head, this method returns without logging.
    package func logTrace() {
        guard let traceHead else {
            return
        }
        let renderedTrace = traceHead.rendered(using: dataSnapshots)
        Log.componentUpdates.log("\(renderedTrace)")
    }

    /// Clears all recorded trace state.
    ///
    /// Calling this on a fresh tracer is a no-op.
    package func reset() {
        guard seed != 0 else {
            return
        }
        seed = 0
        traceHead = nil
        activeTraces = []
        pendingBranches = [:]
        dataSnapshots = [:]
    }
}

// MARK: - TraceDataSnapshot

/// Lazily captured strings used to render a completed trace node.
package struct TraceDataSnapshot: Sendable {
    /// Returns the component description for the trace node.
    package var component: @Sendable () -> String

    /// Returns the output or error description for the trace node.
    package var result: @Sendable () -> String

    /// Returns the component state description for the trace node.
    package var state: @Sendable () -> String

    /// Indicates whether ``result`` should be rendered as output or error text.
    package var isSuccess: Bool

    /// Creates a trace data snapshot.
    ///
    /// - Parameters:
    ///   - component: A closure returning the component description.
    ///   - result: A closure returning the output or error description.
    ///   - state: A closure returning the component state description.
    ///   - isSuccess: Whether `result` should use the `Output` or `Error`
    ///     render label.
    package init(
        component: @escaping @Sendable () -> String,
        result: @escaping @Sendable () -> String,
        state: @escaping @Sendable () -> String,
        isSuccess: Bool
    ) {
        self.component = component
        self.result = result
        self.state = state
        self.isSuccess = isSuccess
    }
}

// MARK: - Trace

/// A node in an update trace tree.
package struct Trace: Hashable, Identifiable, Sendable {
    /// The identifier used to find this node's ``TraceDataSnapshot``.
    package var id: Int16

    /// Traces that fed into this trace and are rendered as upstream branches.
    package var upstreamTraces: [Trace]

    /// Creates a trace node.
    ///
    /// - Parameters:
    ///   - id: The identifier used to find this trace's snapshot.
    ///   - upstreamTraces: The upstream traces to render beneath this node.
    package init(id: Int16, upstreamTraces: [Trace] = []) {
        self.id = id
        self.upstreamTraces = upstreamTraces
    }
}

// MARK: - Trace + Rendering

extension Trace {
    /// Renders this trace tree using the supplied snapshot data.
    ///
    /// The rendered tree includes the component summary, an optional result
    /// summary, and any upstream traces. If no snapshot exists for a trace
    /// identifier, the node is rendered as `UnknownComponent`.
    ///
    /// - Parameters:
    ///   - snapshots: Snapshot data keyed by trace identifier.
    ///   - prefix: Text prepended to the first rendered line for this trace.
    ///   - childPrefix: Text prepended to continuation lines and child traces.
    /// - Returns: The rendered trace tree.
    package func rendered(
        using snapshots: [Int16: TraceDataSnapshot],
        prefix: String = "",
        childPrefix: String = ""
    ) -> String {
        let chunks = Self.renderedChunks(for: snapshots[id])
        let prefixedComponentSummary = Self.prefixedChunk(
            chunks.componentSummary,
            prefix: childPrefix,
            preservingFirstLine: true
        )
        let prefixedResultSummary = Self.prefixedChunk(
            chunks.resultSummary,
            prefix: childPrefix,
            preservingFirstLine: false
        )
        var result = prefix
        result += prefixedComponentSummary
        result += "\n"
        result += prefixedResultSummary
        result += "\n"
        guard !upstreamTraces.isEmpty else {
            return result
        }
        result += "\(childPrefix)↑\n\(childPrefix)│\n"
        for (index, upstreamTrace) in upstreamTraces.enumerated() {
            let isLast = index == upstreamTraces.index(before: upstreamTraces.endIndex)
            let branch = isLast ? "└── " : "├── "
            let continuation = isLast ? "    " : "│   "
            result += upstreamTrace.rendered(
                using: snapshots,
                prefix: childPrefix + branch,
                childPrefix: childPrefix + continuation
            )
            if !isLast {
                result += childPrefix + "│\n"
            }
        }
        return result
    }

    /// Formats an optional snapshot into the two text chunks used by a trace node.
    ///
    /// Missing snapshots render as `UnknownComponent` with an empty result
    /// summary. Present snapshots trim generic arguments from the component
    /// summary, append the state suffix, and render nonempty results with either
    /// the `Output` or `Error` label.
    ///
    /// - Parameter snapshot: The snapshot to format, or `nil` for an unknown
    ///   component.
    /// - Returns: The component summary and optional result summary.
    private static func renderedChunks(
        for snapshot: TraceDataSnapshot?
    ) -> (componentSummary: String, resultSummary: String) {
        guard let snapshot else {
            return ("UnknownComponent", "")
        }
        var componentSummary = snapshot.component()
        if let genericStart = componentSummary.firstIndex(of: "<") {
            componentSummary = String(componentSummary[..<genericStart])
        }
        componentSummary += String(snapshot.state().dropFirst(5))
        let resultDescription = snapshot.result()
        let resultLabel = snapshot.isSuccess ? "Output" : "Error"
        guard !resultDescription.isEmpty else {
            return (componentSummary, "")
        }
        return (componentSummary, "\(resultLabel): \(resultDescription)")
    }

    /// Applies a trace-tree prefix to a multiline chunk.
    ///
    /// The chunk is split on newlines while omitting empty subsequences. When
    /// `preservingFirstLine` is true, the first nonempty line is left unchanged
    /// and the prefix is applied only to following lines. Otherwise, every
    /// nonempty line receives the prefix.
    ///
    /// - Parameters:
    ///   - chunk: The chunk to split and prefix.
    ///   - prefix: The prefix to apply to selected lines.
    ///   - preservingFirstLine: Whether to leave the first line unprefixed.
    /// - Returns: The prefixed chunk, joined with newline separators.
    private static func prefixedChunk(
        _ chunk: String,
        prefix: String,
        preservingFirstLine: Bool
    ) -> String {
        guard !chunk.isEmpty else {
            return ""
        }
        let lines = chunk.split(separator: "\n", omittingEmptySubsequences: true)
        if preservingFirstLine {
            guard let firstLine = lines.first else {
                return ""
            }
            return ([String(firstLine)] + lines.dropFirst().map { prefix + $0 })
                .joined(separator: "\n")
        } else {
            return lines
                .map { prefix + $0 }
                .joined(separator: "\n")
        }
    }
}
