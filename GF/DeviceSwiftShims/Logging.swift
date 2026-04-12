// MARK: - Logging

@_transparent
package func preconditionFailure(_ message: @autoclosure () -> String, file: StaticString, line: UInt) -> Never {
    Swift.fatalError(message(), file: file, line: line)
}

@_transparent
package func preconditionFailure(_ message: @autoclosure () -> String) -> Never {
    preconditionFailure(message(), file: #fileID, line: #line)
}

// MARK: - Abstract and stub call

@_transparent
package func _gesturesUnreachableCode(_ function: String = #function, file: StaticString = #fileID, line: UInt = #line) -> Never {
    preconditionFailure("", file: file, line: line)
}

@_transparent
package func _gesturesBaseClassAbstractMethod(_ function: String = #function, file: StaticString = #fileID, line: UInt = #line) -> Never {
    preconditionFailure("", file: file, line: line)
}

@_transparent
package func _gesturesEmptyStub(_ function: String = #function, file: StaticString = #fileID, line: UInt = #line) {
    // Intentionally empty - stub implementation
}
