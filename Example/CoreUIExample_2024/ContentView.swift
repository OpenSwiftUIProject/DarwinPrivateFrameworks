//
//  ContentView.swift
//  CoreUIExample_2024
//
//  Created by Kyle on 2025/4/14.
//

import CoreUI
import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    var body: some View {
        VStack(alignment: .leading) {
            colorView(name: .red, text: "red")
            colorView(name: .orange, text: "orange")
            colorView(name: .yellow, text: "yellow")
            colorView(name: .green, text: "green")
        }.padding()
    }

    @ViewBuilder
    func colorView(name: CUIColorName, text: String) -> some View {
        HStack {
            ((try? color(name: name)) ?? .clear)
                .frame(width: 50, height: 50)
            Text(verbatim: text)
        }
    }

    private func color(
        name: CUIColorName
    ) throws -> Color {
        let traits = CUIDesignColorTraits(
            name: name,
            designSystem: 0,
            palette: 0,
            colorScheme: colorScheme == .dark ? .dark : .light,
            contrast: colorSchemeContrast == .increased ? .increased : .standard,
            styling: ._0,
            displayGamut: .P3
        )
        let color = try CUIDesignLibrary.color(with: traits)
        return Color(cgColor: color.cgColor)
    }
}

#Preview {
    ContentView()
}
