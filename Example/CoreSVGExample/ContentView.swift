//
//  ContentView.swift
//  CoreSVGExample
//
//  Created by Kyle on 2026/4/25.
//

import CoreSVG
import Foundation
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            SVGDocumentView(data: sampleSVGData)
                .frame(width: 220, height: 220)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4)
            Text("CoreSVG.framework")
                .font(.title)
            Text(canvasDescription)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private var canvasDescription: String {
        guard let documentRef = CGSVGDocumentCreateFromData(sampleSVGData as CFData, nil) else {
            return "Failed to create SVG document"
        }
        let document = documentRef.takeRetainedValue()
        let size = CGSVGDocumentGetCanvasSize(document)
        return "Canvas: \(Int(size.width)) x \(Int(size.height))"
    }
}

private struct SVGDocumentView: View {
    let data: Data

    var body: some View {
        Canvas { context, size in
            guard let documentRef = CGSVGDocumentCreateFromData(data as CFData, nil) else {
                return
            }
            let document = documentRef.takeRetainedValue()

            let canvasSize = CGSVGDocumentGetCanvasSize(document)
            guard canvasSize.width > 0, canvasSize.height > 0 else {
                return
            }

            let scale = min(size.width / canvasSize.width, size.height / canvasSize.height)
            let fittedSize = CGSize(width: canvasSize.width * scale, height: canvasSize.height * scale)
            let origin = CGPoint(
                x: (size.width - fittedSize.width) / 2,
                y: (size.height - fittedSize.height) / 2
            )

            context.withCGContext { cgContext in
                cgContext.saveGState()
                cgContext.translateBy(x: origin.x, y: origin.y)
                cgContext.scaleBy(x: scale, y: scale)
                CGContextDrawSVGDocument(cgContext, document)
                cgContext.restoreGState()
            }
        }
    }
}

private let sampleSVGData = Data(
    """
    <svg xmlns="http://www.w3.org/2000/svg" width="180" height="180" viewBox="0 0 180 180">
      <defs>
        <linearGradient id="sky" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stop-color="#38bdf8"/>
          <stop offset="1" stop-color="#6366f1"/>
        </linearGradient>
      </defs>
      <rect width="180" height="180" rx="36" fill="url(#sky)"/>
      <circle cx="70" cy="68" r="34" fill="#fef3c7"/>
      <path d="M34 132 L78 90 L110 120 L132 98 L158 132 Z" fill="#14532d"/>
      <path d="M34 132 L78 90 L110 120 L132 98 L158 132 Z" fill="#22c55e" opacity="0.65"/>
    </svg>
    """.utf8
)

#Preview {
    ContentView()
}
