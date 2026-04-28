//
//  UpdateXCFrameworksCommand.swift
//  DarwinPrivateFrameworks

import PackagePlugin
import Foundation

private struct CommandFailedError: LocalizedError {
    var command: String
    var status: Int32

    var errorDescription: String? {
        "Command failed with exit code \(status): \(command)"
    }
}

@main
struct UpdateXCFrameworksCommand: CommandPlugin {
    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        // AttributeGraph
        try run(context: context, command: "AG/reset.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2021"])
        try run(context: context, command: "AG/update.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2021"])
        try run(context: context, command: "AG/reset.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2024"])
        try run(context: context, command: "AG/update.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2024"])
        // RenderBox
        try run(context: context, command: "RB/reset.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2024"])
        try run(context: context, command: "RB/update.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2024"])
        // CoreUI
        try run(context: context, command: "CoreUI/reset.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2024"])
        try run(context: context, command: "CoreUI/update.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2024"])
        // BacklightServices
        try run(context: context, command: "BLS/reset.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2024"])
        try run(context: context, command: "BLS/update.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2024"])
        // SFSymbols
        try run(context: context, command: "SFSymbols/reset.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2024"])
        try run(context: context, command: "SFSymbols/update.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2024"])
        // CoreSVG
        try run(context: context, command: "CoreSVG/reset.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2024"])
        try run(context: context, command: "CoreSVG/update.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2024"])
        #if compiler(>=6.2)
        // Gestures
        try run(context: context, command: "GF/reset.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2025"])
        try run(context: context, command: "GF/update.sh", environment: ["DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE": "2025"])
        #endif
    }
    
    private func run(context: PackagePlugin.PluginContext, command: String, environment: [String: String]) throws {
        let process = Process()
        process.executableURL = try context.tool(named: "bash").url
        process.environment = ProcessInfo.processInfo.environment.merging(environment) { _, new in
            new
        }
        process.arguments = [command]
        try process.run()
        process.waitUntilExit()
        guard process.terminationStatus == 0 else {
            throw CommandFailedError(command: command, status: process.terminationStatus)
        }
    }
}
