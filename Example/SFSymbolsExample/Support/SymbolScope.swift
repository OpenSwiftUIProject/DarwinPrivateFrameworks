//
//  SymbolScope.swift
//  Example
//
//  Created by Yanan Li on 2026/7/11.
//

import Foundation

enum SymbolScope: String, CaseIterable, Identifiable {
    case publicSymbols
    case privateSymbols
    case allSymbols

    var id: Self { self }

    var title: String {
        switch self {
        case .publicSymbols:
            "Public"
        case .privateSymbols:
            "Private"
        case .allSymbols:
            "All"
        }
    }
}
