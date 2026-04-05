//
//  ContentView.swift
//  GFExample
//
//  Created by Kyle on 2026/4/4.
//

import SwiftUI
import Gestures

struct ContentView: View {
    @State private var nodeInfo: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "hand.tap")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Gestures.framework")
                .font(.title)
            Text(nodeInfo)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .onAppear {
            let coordinator = GFGestureNodeCoordinatorCreate(nil, nil)
            let node = GFGestureNodeCreateDefault(1)
            let defaultValue = GFGestureNodeDefaultValue()
            let phase = GFGesturePhase(rawValue: 0)
            let isTerminated = GFGestureFailureTypeIsTerminated(phase)
            nodeInfo = """
            Coordinator: \(coordinator)
            Node: \(node)
            DefaultValue: \(String(describing: defaultValue))
            Phase(0) terminated: \(isTerminated)
            """
        }
    }
}

#Preview {
    ContentView()
}
