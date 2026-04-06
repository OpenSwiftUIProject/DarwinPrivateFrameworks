//
//  GestureNodeOptions.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - GestureNodeOptions

public struct GestureNodeOptions: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let isDisabled = GestureNodeOptions(rawValue: 0x1)
    public static let disallowExclusionWithUnresolvedFailureRequirements = GestureNodeOptions(rawValue: 0x2)
    public static let isGloballyScoped = GestureNodeOptions(rawValue: 0x4)
}

// MARK: - GestureNodeOptions + CustomStringConvertible

extension GestureNodeOptions: CustomStringConvertible {
    public var description: String {
        guard self != [] else {
            return "none"
        }
        var names: [String] = []
        if contains(.isDisabled) {
            names.append("isDisabled")
        }
        if contains(.disallowExclusionWithUnresolvedFailureRequirements) {
            names.append("disallowExclusionWithUnresolvedFailureRequirements")
        }
        if contains(.isGloballyScoped) {
            names.append("isGloballyScoped")
        }
        return "{ \(names.joined(separator: " | ")) }"
    }
}
