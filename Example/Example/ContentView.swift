//
//  ContentView.swift
//  Example
//
//  Created by Kyle on 2024/12/26.
//

import AttributeGraph
import RenderBox
import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Test") {
            AGSubgraph.beginTreeElement(value: Attribute<Int>(identifier: .nil), flags: 0)
        }
    }
}

#Preview {
    ContentView()
}
