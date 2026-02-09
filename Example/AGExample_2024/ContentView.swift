//
//  ContentView.swift
//  AGExample_2024
//
//  Created by Kyle on 2024/12/30.
//

import AttributeGraph
#if os(iOS) && !targetEnvironment(simulator)
import _AttributeGraphDeviceSwiftShims
#endif
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MetadataView()
            VersionView()
        }
    }
}

struct MetadataView: View {
    var metadata: Metadata { Metadata(Self.self) }
    
    var body: some View {
        VStack {
            Text("nominalDescriptorName \(String(cString: metadata.nominalDescriptorName!))")
            Text("description \(metadata.description)")
            Text("descriptor \(metadata.descriptor!)")
            Text("signature \(metadata.signature.bytes)")
        }
    }
}

struct VersionView: View {
    var body: some View {
        VStack {
            Text("AGVersion \(AGVersion)")
        }
    }
}

#Preview {
    ContentView()
}
