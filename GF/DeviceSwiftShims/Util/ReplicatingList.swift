//
//  ReplicatingList.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - ReplicatingValue

package protocol ReplicatingValue: Sendable {
    func replicated() -> Self
}

extension ReplicatingValue {
    package func replications(count: Int) -> [Self] {
        Array(repeating: replicated(), count: count)
    }
}

// MARK: - ReplicatingList

package struct ReplicatingList<Element>: Collection, Sendable where Element: ReplicatingValue {
    package enum Storage: Sendable {
        case empty(Element)
        case single(Element)
        case multiple([Element])
    }

    package var storage: Storage

    // TBA
    package init(prototype: Element, count: Int = 0) {
        precondition(count >= 0, "Count must be non-negative")
        storage = .empty(prototype)
        if count > 0 {
            appendReplications(count)
        }
    }

    package var startIndex: Int { 0 }

    package var endIndex: Int {
        count
    }

    package var count: Int {
        switch storage {
        case .empty:
            return 0
        case .single:
            return 1
        case let .multiple(elements):
            return elements.count
        }
    }

    package func index(after index: Int) -> Int {
        index + 1
    }

    package subscript(position: Int) -> Element {
        get {
            switch storage {
            case .empty:
                preconditionFailure("Index out of range")
            case let .single(element):
                precondition(position == 0, "Index out of range")
                return element
            case let .multiple(elements):
                return elements[position]
            }
        }
        set {
            switch storage {
            case .empty:
                preconditionFailure("Index out of range")
            case .single:
                precondition(position == 0, "Index out of range")
                storage = .single(newValue)
            case var .multiple(elements):
                elements[position] = newValue
                storage = .multiple(elements)
            }
        }
    }

    package func prototype() -> Element {
        switch storage {
        case let .empty(element):
            return element
        case let .single(element):
            return element.replicated()
        case let .multiple(elements):
            return elements[0].replicated()
        }
    }

    package mutating func appendReplications(_ count: Int) {
        precondition(count >= 1, "Count must be positive")
        switch storage {
        case let .empty(prototype):
            if count == 1 {
                storage = .single(prototype.replicated())
            } else {
                storage = .multiple(prototype.replications(count: count))
            }
        case let .single(element):
            storage = .multiple(
                [element] + element.replications(count: count)
            )
        case let .multiple(elements):
            storage = .multiple(
                elements + elements[0].replications(count: count)
            )
        }
    }

    package mutating func removeLast(_ removedCount: Int) {
        precondition(removedCount >= 1, "Count must be positive")
        let newCount = count - removedCount
        guard newCount < count else {
            return
        }
        switch storage {
        case .empty:
            return
        case let .single(element):
            storage = .empty(element.replicated())
        case let .multiple(elements):
            switch newCount {
            case 0:
                storage = .empty(elements[0].replicated())
            case 1:
                storage = .single(elements[0])
            default:
                storage = .multiple(Array(elements.prefix(newCount)))
            }
        }
    }

    package mutating func remove(at index: Int) {
        switch storage {
        case .empty:
            preconditionFailure("Index out of range")
        case let .single(element):
            precondition(index == 0, "Index out of range")
            storage = .empty(element.replicated())
        case var .multiple(elements):
            elements.remove(at: index)
            switch elements.count {
            case 1:
                storage = .single(elements[0])
            default:
                storage = .multiple(elements)
            }
        }
    }

    package mutating func resize(to newCount: Int) {
        precondition(newCount >= 0, "Count must be non-negative")
        guard count != newCount else {
            return
        }
        if count > newCount {
            removeLast(count - newCount)
        } else {
            appendReplications(newCount - count)
        }
    }
}
