//
//  GFGestureNode.swift
//  Gestures
//
//  Created by Kyle on 4/19/26.
//

import Foundation

@objc
class AnyGestureNodeShim: NSObject, @unchecked Sendable {

    package var node: AnyGestureNode {
        _gesturesBaseClassAbstractMethod()
    }

//    override var container: (any GestureNodeContainer)? {
//        didSet {
//            // TODO
//        }
//    }
//
//    override func abort() throws {
//        _gesturesBaseClassAbstractMethod()
//    }
}
