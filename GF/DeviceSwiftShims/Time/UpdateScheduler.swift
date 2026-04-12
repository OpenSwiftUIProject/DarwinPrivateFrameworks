// MARK: - UpdateRequest

public struct UpdateRequest: Hashable, Sendable, Identifiable {
    public let id: UInt32
    public let creationTime: Timestamp
    public let targetTime: Timestamp
    public let tag: String?
}

@_spi(Private)
extension UpdateRequest: CustomStringConvertible {
    public var description: String {
        let duration = targetTime - creationTime
        var result = "{ \(id)"
        if let tag {
            result += " \"\(tag)\""
        }
        result += ", \(duration) }"
        return result
    }
}