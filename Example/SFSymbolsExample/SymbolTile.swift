//
//  SymbolTile.swift
//  Example
//
//  Created by Yanan Li on 2026/7/11.
//

import SwiftUI

struct SymbolTile: View {
    let symbol: SymbolCatalog.Item

    var body: some View {
        VStack(spacing: 12) {
            Group {
                if symbol.isPrivate {
                    Image(_internalSystemName: symbol.name)
                } else {
                    Image(systemName: symbol.name)
                }
            }
            .font(.system(size: 30))
            .frame(height: 36)
            .accessibilityHidden(true)

            Text(symbol.name)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            if !symbol.aliases.isEmpty {
                Text(symbol.aliases.joined(separator: "\n"))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }

            if symbol.isPrivate {
                Text("Private")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(.fill.secondary, in: .rect(cornerRadius: 12))
        .contentShape(RoundedRectangle(cornerRadius: 12))
    }
}
