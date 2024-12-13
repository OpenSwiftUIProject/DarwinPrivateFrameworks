//
//  UpdateModuleCommand.swift
//  PrivateFrameworks

import PackagePlugin
import Foundation

@main
struct UpdateModuleCommand: CommandPlugin {
    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        try run(context: context, command: "AG/reset.sh", environment: ["DARWIN_PRIVATE_FRAMEWORKS_TARGET_RELEASE": "2021"])
        try run(context: context, command: "AG/reset.sh", environment: ["DARWIN_PRIVATE_FRAMEWORKS_TARGET_RELEASE": "2024"])
        try run(context: context, command: "AG/update.sh", environment: ["DARWIN_PRIVATE_FRAMEWORKS_TARGET_RELEASE": "2021"])
        try run(context: context, command: "AG/update.sh", environment: ["DARWIN_PRIVATE_FRAMEWORKS_TARGET_RELEASE": "2024"])
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
