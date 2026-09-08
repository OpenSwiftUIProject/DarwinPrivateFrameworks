//
//  ContentView.swift
//  DarwinPrivateFrameworks

import FeatureFlags
import SwiftUI

private struct GestureContainerKey: FeatureFlagsKey {
    var domain: StaticString { "SwiftUI" }

    var feature: StaticString { "gestureContainer" }
}

struct ContentView: View {
    @State private var isEnabled = FeatureFlags.isFeatureEnabled(GestureContainerKey())

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent("Domain", value: "SwiftUI")
                    LabeledContent("Feature", value: "gestureContainer")
                    LabeledContent("Status") {
                        Label(
                            isEnabled ? "Enabled" : "Disabled",
                            systemImage: isEnabled ? "checkmark.circle.fill" : "minus.circle"
                        )
                        .foregroundStyle(isEnabled ? .green : .secondary)
                    }
                } footer: {
                    Text("The result comes from the system feature flag service.")
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Feature Flags")
            .toolbar {
                Button("Refresh", systemImage: "arrow.clockwise") {
                    isEnabled = FeatureFlags.isFeatureEnabled(GestureContainerKey())
                }
            }
        }
        #if os(macOS)
        .frame(minWidth: 400, minHeight: 260)
        #endif
    }
}

#Preview {
    ContentView()
}
