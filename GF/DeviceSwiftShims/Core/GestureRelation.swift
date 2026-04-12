//
//  GestureRelation.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

package import OrderedCollections

// MARK: - GestureRelationType

public enum GestureRelationType: Hashable, Sendable {
    case exclusion
    case activeExclusion
    case failureRequirement
}

// MARK: - GestureRelationRole

public enum GestureRelationRole: Hashable, Sendable {
    case regular
    case blocking
}

// MARK: - GestureRelationDirection

public enum GestureRelationDirection: Hashable, Sendable {
    case outgoing
    case incoming
}

// MARK: - GestureRelation

public struct GestureRelation: Equatable, Sendable {
    public var type: GestureRelationType
    public var direction: GestureRelationDirection
    public var role: GestureRelationRole?
    public var target: GestureNodeMatcher

    public init(
        type: GestureRelationType,
        direction: GestureRelationDirection,
        role: GestureRelationRole?,
        target: GestureNodeMatcher
    ) {
        self.type = type
        self.direction = direction
        self.role = role
        self.target = target
    }
}

// MARK: - [GestureRelation] Default

extension [GestureRelation] {
    public static var `default`: [GestureRelation] {
        [
            GestureRelation(type: .exclusion, direction: .outgoing, role: .regular, target: .any(position: .any)),
            GestureRelation(type: .activeExclusion, direction: .outgoing, role: .regular, target: .any(position: .any)),
            GestureRelation(type: .activeExclusion, direction: .incoming, role: .blocking, target: .any(position: .any)),
        ]
    }
}

// MARK: - RelationMap

package struct RelationMap: Sendable {
    private var relations: OrderedDictionary<GestureNodeMatcher, Set<RelationDefinition>>

    package init() {
        self.relations = [:]
    }

    package init(relations: OrderedDictionary<GestureNodeMatcher, Set<RelationDefinition>>) {
        self.relations = relations
    }

    package mutating func add(_ definition: RelationDefinition, for matcher: GestureNodeMatcher) {
        relations[matcher, default: []].insert(definition)
    }

    package mutating func remove(_ definition: RelationDefinition, for matcher: GestureNodeMatcher) {
        relations[matcher]?.remove(definition)
        if relations[matcher]?.isEmpty == true {
            relations.removeValue(forKey: matcher)
        }
    }

    package mutating func addRelation(_ relation: GestureRelation) {
        let definition = RelationDefinition(
            type: relation.type,
            direction: relation.direction,
            role: relation.role
        )
        add(definition, for: relation.target)
    }

    package mutating func removeRelation(_ relation: GestureRelation) {
        let definition = RelationDefinition(
            type: relation.type,
            direction: relation.direction,
            role: relation.role
        )
        remove(definition, for: relation.target)
    }

    package func toRelations() -> [GestureRelation] {
        var result: [GestureRelation] = []
        for (matcher, definitions) in relations {
            for definition in definitions {
                result.append(GestureRelation(
                    type: definition.type,
                    direction: definition.direction,
                    role: definition.role,
                    target: matcher
                ))
            }
        }
        return result
    }
}

// MARK: - RelationMap + Sequence

extension RelationMap: Sequence {
    package func makeIterator() -> some IteratorProtocol {
        relations.makeIterator()
    }
}

// MARK: - RelationMap + NestedCustomStringConvertible

extension RelationMap: NestedCustomStringConvertible {
    package func populateNestedDescription(_ nested: inout NestedDescription) {
        nested.options.formUnion(.hideTypeName)
        for (matcher, definition) in relations {
            nested.append("\(matcher)", label: "\(definition)")
        }
    }
}

// MARK: - RelationDefinition

package struct RelationDefinition: Hashable, Sendable, CustomStringConvertible {
    package var type: GestureRelationType
    package var direction: GestureRelationDirection
    package var role: GestureRelationRole?

    package init(
        type: GestureRelationType,
        direction: GestureRelationDirection,
        role: GestureRelationRole? = nil
    ) {
        self.type = type
        self.direction = direction
        self.role = role
    }

    package var description: String {
        let dir = switch direction {
        case .outgoing: "out"
        case .incoming: "in"
        }
        let roleStr = if let role { "\(role)" } else { "dynamic" }
        return "\(type)[\(dir)]=\(roleStr)"
    }
}
