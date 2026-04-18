//
//  RingBuffer.swift
//  Gestures
//
//  Audited for 9126.1.5
//  Status: Complete

// MARK: - RingBuffer

package struct RingBuffer<Element> {
    package let capacity: Int
    package var count: Int
    package var storage: [Element]
    package var emptyValue: Element
    package var start: Int
    package var end: Int

    package init(capacity: Int, emptyValue: Element) {
        self.capacity = capacity
        self.count = 0
        self.storage = Array(repeating: emptyValue, count: capacity)
        self.emptyValue = emptyValue
        self.start = 0
        self.end = 0
    }

    package var isEmpty: Bool { count == 0 }

    package var isFull: Bool { count == capacity }

    package mutating func append(_ element: Element) {
        storage[end] = element
        end = (end + 1) % capacity
        if isFull {
            start = (start + 1) % capacity
        } else {
            count += 1
        }
    }

    @discardableResult
    package mutating func removeFirst() -> Element {
        let value = storage[start]
        storage[start] = emptyValue
        start = (start + 1) % capacity
        count -= 1
        return value
    }
}

// MARK: - RingBuffer + Sequence

extension RingBuffer: Sequence {
    package func makeIterator() -> RingBufferIterator<Element> {
        RingBufferIterator(
            ringBuffer: self,
            currentIndex: start,
            elementsRemaining: count
        )
    }
}

// MARK: - RingBuffer + Collection

extension RingBuffer: Collection {
    package var startIndex: Int { 0 }

    package var endIndex: Int { count }

    package func index(after i: Int) -> Int { i + 1 }

    package subscript(position: Int) -> Element {
        storage[(start + position) % capacity]
    }
}

// MARK: - RingBuffer + BidirectionalCollection

extension RingBuffer: BidirectionalCollection {
    package func index(before i: Int) -> Int { i - 1 }
}

// MARK: - RingBuffer + CustomStringConvertible

extension RingBuffer: CustomStringConvertible {
    package var description: String {
        "[" + map { "\($0)" }.joined(separator: ", ") + "]"
    }
}

// MARK: - RingBufferIterator

package struct RingBufferIterator<Element>: IteratorProtocol {
    package let ringBuffer: RingBuffer<Element>
    package var currentIndex: Int
    package var elementsRemaining: Int

    package init(
        ringBuffer: RingBuffer<Element>,
        currentIndex: Int,
        elementsRemaining: Int
    ) {
        self.ringBuffer = ringBuffer
        self.currentIndex = currentIndex
        self.elementsRemaining = elementsRemaining
    }

    package mutating func next() -> Element? {
        guard elementsRemaining > 0 else { return nil }
        let value = ringBuffer.storage[currentIndex]
        currentIndex = (currentIndex + 1) % ringBuffer.capacity
        elementsRemaining -= 1
        return value
    }
}

