//
//  ContentView.swift
//  CoreMaterialExample
//

import CoreMaterial
import Foundation
import SwiftUI

struct ContentView: View {
    @State private var recipe = MTCoreMaterialRecipe.platformContentLight
    @State private var category = MTCoreMaterialVisualStyleCategory.fill
    @State private var style = MTCoreMaterialVisualStyle.primary
    @State private var includeOptimizations = true
    @State private var reduceTransparency = false
    #if os(visionOS)
    @State private var filtersRepresentationV2 = true
    #endif

    var body: some View {
        Form {
            Section("Material") {
                Picker("Recipe", selection: $recipe) {
                    Text("Ultra thin light").tag(MTCoreMaterialRecipe.platformContentUltraThinLight)
                    Text("Ultra thin dark").tag(MTCoreMaterialRecipe.platformContentUltraThinDark)
                    Text("Thin light").tag(MTCoreMaterialRecipe.platformContentThinLight)
                    Text("Thin dark").tag(MTCoreMaterialRecipe.platformContentThinDark)
                    Text("Regular light").tag(MTCoreMaterialRecipe.platformContentLight)
                    Text("Regular dark").tag(MTCoreMaterialRecipe.platformContentDark)
                    Text("Thick light").tag(MTCoreMaterialRecipe.platformContentThickLight)
                    Text("Thick dark").tag(MTCoreMaterialRecipe.platformContentThickDark)
                    Text("Bar light").tag(MTCoreMaterialRecipe.platformChromeLight)
                    Text("Bar dark").tag(MTCoreMaterialRecipe.platformChromeDark)
                }
                Picker("Category", selection: $category) {
                    Text("Fill").tag(MTCoreMaterialVisualStyleCategory.fill)
                    Text("Stroke").tag(MTCoreMaterialVisualStyleCategory.stroke)
                }
                Picker("Style", selection: $style) {
                    Text("Primary").tag(MTCoreMaterialVisualStyle.primary)
                    Text("Secondary").tag(MTCoreMaterialVisualStyle.secondary)
                    Text("Tertiary").tag(MTCoreMaterialVisualStyle.tertiary)
                    Text("Quaternary").tag(MTCoreMaterialVisualStyle.quaternary)
                    Text("Separator").tag(MTCoreMaterialVisualStyle.separator)
                }
            }

            Section("Options") {
                Toggle("Include optimizations", isOn: $includeOptimizations)
                Toggle("Reduce transparency", isOn: $reduceTransparency)
                #if os(visionOS)
                Toggle("Use filter representation V2", isOn: $filtersRepresentationV2)
                #endif
            }

            Section("Dictionary") {
                if let dictionary = materialDescription {
                    if dictionary.isEmpty {
                        Text("The material dictionary is empty.")
                    }
                    ForEach(dictionary.keys.sorted(), id: \.self) { key in
                        if let value = dictionary[key] {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(key)
                                    .font(.headline)
                                Text(String(describing: value))
                                    .font(.system(.caption, design: .monospaced))
                                    .textSelection(.enabled)
                            }
                        }
                    }
                } else {
                    Text("CoreMaterial did not return a dictionary.")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .formStyle(.grouped)
    }

    private var materialDescription: [String: Any]? {
        var options: [String: Any] = [
            kMTDictionaryRepresentationOptionsIncludeOptimizationsKey: includeOptimizations,
            kMTDictionaryRepresentationOptionsReduceTransparencyKey: reduceTransparency,
        ]
        #if os(visionOS)
        options[kMTDictionaryRepresentationOptionsFiltersRepresentationV2Key] = filtersRepresentationV2
        #endif
        return MTVisualStylingCreateDictionaryRepresentation(recipe, category, style, options)
    }
}

#Preview {
    ContentView()
}
