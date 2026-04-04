//
//  ExampleApp.swift
//  BLSExample
//
//  Created by Kyle on 2025/9/13.
//

import SwiftUI

@main
struct ExampleApp: App {
    init() {
        #if AG_EXAMPLE_OBJC
        ag_example_main()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
