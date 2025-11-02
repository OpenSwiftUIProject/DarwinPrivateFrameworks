//
//  UpdateXCFrameworksCommand.swift
//  DarwinPrivateFrameworks

import PackagePlugin
import Foundation

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
    }
    
    private func run(context: PackagePlugin.PluginContext, command: String, environment: [String: String]) throws {
        let process = Process()
        process.executableURL = try context.tool(named: "bash").url
        process.environment = environment
        process.arguments = [command]
        try process.run()
        process.waitUntilExit()
    }
}
