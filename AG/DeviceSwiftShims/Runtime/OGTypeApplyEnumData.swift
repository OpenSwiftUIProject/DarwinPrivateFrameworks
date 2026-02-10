//
//  AGTypeApplyEnumData.swift
//
//
//

// public import AttributeGraph

@discardableResult
public func withUnsafePointerToEnumCase<T>(
    of value: UnsafeMutablePointer<T>,
    do body: (Int, Any.Type, UnsafeRawPointer) -> ()
) -> Bool {
    // TODO: AGTypeApplyEnumData
    return true
}

@discardableResult
public func withUnsafeMutablePointerToEnumCase<T>(
    of value: UnsafeMutablePointer<T>,
    do body: (Int, Any.Type, UnsafeMutableRawPointer) -> ()
) -> Bool {
    // TODO: AGTypeApplyMutableEnumData
    return true
}
