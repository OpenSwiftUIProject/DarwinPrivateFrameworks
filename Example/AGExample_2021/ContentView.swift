//
//  ContentView.swift
//  AGExample_2021
//
//  Created by Kyle on 2024/12/26.
//

import AttributeGraph
import SwiftUI

struct ContentView: View {
    var body: some View {
        MetadataView()
    }
}

struct MetadataView: View {
    var body: some View {
        VStack {
            Text("nominalDescriptorName \(String(cString: Metadata(Self.self).nominalDescriptorName!))")
            Text("description \(Metadata(Self.self).description)")
        }.onAppear {
            // _ = Metadata(Self.self).descriptor
        }
    }
}

#Preview {
    ContentView()
}
