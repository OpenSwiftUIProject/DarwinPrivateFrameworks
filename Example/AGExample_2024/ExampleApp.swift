//
//  ExampleApp.swift
//  AGExample_2024
//
//  Created by Kyle on 2024/12/30.
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
