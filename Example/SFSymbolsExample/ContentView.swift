//
//  ContentView.swift
//  DarwinPrivateFrameworks
//
//  Created by Yanan Li on 2026/3/3.
//

import SFSymbols
import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var symbolScope = SymbolScope.publicSymbols
    @State private var selectedSymbol: SymbolCatalog.Item?

    private let catalog = SymbolCatalog.system
    private let gridColumns = [
        GridItem(.adaptive(minimum: 120), spacing: 12),
    ]

    var body: some View {
        let matchingSymbols = catalog.symbols(
            matching: searchText,
            scope: symbolScope
        )

        NavigationStack {
            ScrollView {
                if matchingSymbols.isEmpty {
                    ContentUnavailableView(
                        "No Symbols Found",
                        systemImage: "magnifyingglass",
                        description: Text("Try another name or search scope.")
                    )
                    .frame(maxWidth: .infinity, minHeight: 300)
                } else {
                    LazyVGrid(columns: gridColumns, spacing: 12) {
                        ForEach(matchingSymbols) { symbol in
                            Button {
                                selectedSymbol = symbol
                            } label: {
                                SymbolTile(symbol: symbol)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("SF Symbols")
            .searchable(text: $searchText, prompt: "Search names and aliases")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Picker("Symbol scope", selection: $symbolScope) {
                        ForEach(SymbolScope.allCases) { scope in
                            Text(scope.title).tag(scope)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                ToolbarItem(placement: .status) {
                    Text("Showing \(matchingSymbols.count) of \(catalog.count(for: symbolScope)) symbols")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .sheet(item: $selectedSymbol) { symbol in
                SymbolDetailsView(symbol: symbol)
            }
        }
    }
}

#Preview {
    ContentView()
}
