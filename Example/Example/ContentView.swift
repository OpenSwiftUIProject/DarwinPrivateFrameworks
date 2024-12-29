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
        MetadataView()
    }
}

struct MetadataView: View {
    var body: some View {
        Text("nominalDescriptorName \(String(cString: Metadata(Self.self).nominalDescriptorName!))")
        Text("description \(Metadata(Self.self).description)")
    }
}

#Preview {
    ContentView()
}
