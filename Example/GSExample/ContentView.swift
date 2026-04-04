//
//  ContentView.swift
//  GSExample
//
//  Created by Kyle on 2026/4/4.
//

import SwiftUI
import Gestures

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "hand.tap")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Gestures.framework Example")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
