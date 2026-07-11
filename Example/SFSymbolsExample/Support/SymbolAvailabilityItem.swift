//
//  SymbolAvailabilityItem.swift
//  Example
//
//  Created by Yanan Li on 2026/7/11.
//

import Foundation
import SFSymbols

struct SymbolCatalog {
    static let system = SymbolCatalog()

    private let publicSymbols: [SymbolCatalog.Item]
    private let privateSymbols: [SymbolCatalog.Item]

    private init() {
        let publicAliases = Dictionary(grouping: SFSymbols.name_aliases.keys) {
            SFSymbols.name_aliases[$0] ?? ""
        }
        let privateAliases = Dictionary(grouping: SFSymbols.private_name_aliases.keys) {
            SFSymbols.private_name_aliases[$0] ?? ""
        }

        publicSymbols = SFSymbols.symbol_order.map { name in
            SymbolCatalog.Item(
                name: name,
                aliases: publicAliases[name, default: []].sorted(),
                filledSymbolName: SFSymbols.nofill_to_fill[name],
                isPrivate: false,
                availability: SFSymbols.SymbolMetadataStore.system.availability(forSystemName: name)
            )
        }
        privateSymbols = SFSymbols.private_symbol_order.map { name in
            SymbolCatalog.Item(
                name: name,
                aliases: privateAliases[name, default: []].sorted(),
                filledSymbolName: SFSymbols.private_nofill_to_fill[name],
                isPrivate: true,
                availability: SFSymbols.SymbolMetadataStore.system.availability(forSystemName: name)
            )
        }
    }

    func symbols(matching searchText: String, scope: SymbolScope) -> [SymbolCatalog.Item] {
        let symbols: [SymbolCatalog.Item]
        switch scope {
        case .publicSymbols:
            symbols = publicSymbols
        case .privateSymbols:
            symbols = privateSymbols
        case .allSymbols:
            symbols = publicSymbols + privateSymbols
        }

        guard !searchText.isEmpty else {
            return symbols
        }

        return symbols.filter { symbol in
            symbol.name.localizedCaseInsensitiveContains(searchText)
                || symbol.aliases.contains {
                    $0.localizedCaseInsensitiveContains(searchText)
                }
        }
    }

    func count(for scope: SymbolScope) -> Int {
        switch scope {
        case .publicSymbols:
            publicSymbols.count
        case .privateSymbols:
            privateSymbols.count
        case .allSymbols:
            publicSymbols.count + privateSymbols.count
        }
    }
    
    struct Item: Identifiable {
        let name: String
        let aliases: [String]
        let filledSymbolName: String?
        let isPrivate: Bool
        let availability: SFSymbols.Availability?

        var id: String {
            "\(isPrivate ? "private" : "public"):\(name)"
        }
    }
}
