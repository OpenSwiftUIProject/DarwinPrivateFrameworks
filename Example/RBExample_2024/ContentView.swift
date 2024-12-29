//
//  ContentView.swift
//  RBExample_2024
//
//  Created by Kyle on 2024/12/30.
//

import RenderBox
import SwiftUI

struct ContentView: View {
    var body: some View {
        UUIDView(id: UUID())
    }
}

struct UUIDView: View {
    let id: UUID
    
    var body: some View {
        Text(String(reflecting: RBUUID(uuid: id)))
    }
}

#Preview {
    ContentView()
}
