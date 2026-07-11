//
//  SymbolDetailsView.swift
//  Example
//
//  Created by Yanan Li on 2026/7/11.
//

import SFSymbols
import SwiftUI

struct SymbolDetailsView: View {
    @Environment(\.dismiss) private var dismiss

    let symbol: SymbolCatalog.Item

    private let availabilityPlatforms: [SFSymbols.Availability.Platform] = [
        .sfSymbols,
        .iOS,
        .macOS,
        .macCatalyst,
        .watchOS,
        .tvOS,
        .visionOS,
    ]

    var body: some View {
        #if os(macOS)
        detailsContent
            .frame(width: 600, height: 640)
        #else
        detailsContent
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        #endif
    }

    private var detailsContent: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 16) {
                        Group {
                            if symbol.isPrivate {
                                Image(_internalSystemName: symbol.name)
                            } else {
                                Image(systemName: symbol.name)
                            }
                        }
                            .font(.system(size: 72))
                            .frame(height: 84)
                            .accessibilityHidden(true)

                        Text(symbol.name)
                            .font(.title3.monospaced())
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .textSelection(.enabled)

                        if !symbol.aliases.isEmpty {
                            Text("Previously: \(symbol.aliases.joined(separator: ", "))")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .textSelection(.enabled)
                        }

                        Text(symbol.isPrivate ? "Private" : "Public")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.quaternary, in: Capsule())
                    }
                    .frame(maxWidth: .infinity)

                    if let availability = symbol.availability {
                        DetailSection(title: "Availability") {
                            LazyVGrid(
                                columns: [GridItem(.adaptive(minimum: 150), spacing: 12)],
                                spacing: 12
                            ) {
                                ForEach(availabilityPlatforms, id: \.rawValue) { platform in
                                    if let version = availability.earliestSupportedRelease(for: platform) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(platform.rawValue)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            Text(version.description)
                                                .font(.body.monospacedDigit())
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(12)
                                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                    }

                    if let filledSymbolName = symbol.filledSymbolName {
                        DetailSection(title: "Filled Variant") {
                            HStack(spacing: 12) {
                                Group {
                                    if symbol.isPrivate {
                                        Image(_internalSystemName: filledSymbolName)
                                    } else {
                                        Image(systemName: filledSymbolName)
                                    }
                                }
                                    .font(.title2)
                                    .frame(width: 32)

                                Text(filledSymbolName)
                                    .font(.body.monospaced())
                                    .textSelection(.enabled)

                                Spacer()
                            }
                            .padding(14)
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding(24)
            }
            .navigationTitle("Symbol Details")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    struct DetailSection<Content: View>: View {
        let title: String
        @ViewBuilder let content: Content

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)

                content
            }
        }
    }
}
