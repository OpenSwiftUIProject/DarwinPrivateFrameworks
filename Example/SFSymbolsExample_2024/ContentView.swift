//
//  ContentView.swift
//  DarwinPrivateFrameworks
//
//  Created by Yanan Li on 2026/3/3.
//

import SFSymbols
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Section("Public") {
                Text("Symbols count: \(SFSymbols.symbol_order.count)")
                Text("Name alias count: \(SFSymbols.name_aliases.count)")
                Text("No-fill-to-fill count: \(SFSymbols.nofill_to_fill.count)")
            }
            
            Divider()
            
            Section("Private") {
                Text("Symbols count: \(SFSymbols.private_symbol_order.count)")
                Text("Name alias count: \(SFSymbols.private_name_aliases.count)")
                Text("No-fill-to-fill count: \(SFSymbols.private_nofill_to_fill.count)")
            }
        }
    }
}

#Preview {
    ContentView()
}
