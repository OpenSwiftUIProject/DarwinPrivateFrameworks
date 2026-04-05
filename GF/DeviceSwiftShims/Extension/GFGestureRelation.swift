//
//  GFGestureRelation.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

extension GFGestureRelationType: Swift.CustomStringConvertible {
    public var description: String {
        switch self {
        case .canExclude: "canExclude"
        case .canBeExcluded: "canBeExcluded"
        case .canExcludeActive: "canExcludeActive"
        case .canBeExcludedWhenActive: "canBeExcludedWhenActive"
        case .requiresFailure: "requiresFailure"
        case .requiredToFail: "requiredToFail"
        @unknown default: preconditionFailure("Unknown type: \(self)")
        }
    }
}

extension GFGestureRelationRole: Swift.CustomStringConvertible {
    public var description: String {
        switch self {
        case .regular: "regular"
        case .blocking: "blocking"
        @unknown default: preconditionFailure("Unknown role: \(self)")
        }
    }
}
