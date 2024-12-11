//
//  SwiftFormatCommandToolPlugin.swift
//  Swift Format Build Tool Plugins
//
//  Created by Caleb Friden on 12/10/24.
//

import PackagePlugin
import Foundation

@main
struct Format: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        // Find the swift tool to run.
        let swiftTool = try context.tool(named: "swift")
        for target in context.package.targets {
            // This plugin only runs for package targets that can have source files.
            guard let sourceModule = target.sourceModule else {
                Diagnostics.remark("Skipping target \"\(target.name)\", because it does not contain a source module.")
                continue
            }
            let sourceFiles = sourceModule.sourceFiles
            try performCommand(
                on: sourceFiles,
                with: swiftTool.url,
                for: target.name
            )
        }
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension Format: XcodeCommandPlugin {
    func performCommand(context: XcodeProjectPlugin.XcodePluginContext, arguments: [String]) throws {
        // Find the swift tool to run.
        let swiftTool = try context.tool(named: "swift")
        for target in context.xcodeProject.targets {
            try performCommand(
                on: target.inputFiles,
                with: swiftTool.url,
                for: target.displayName
            )
        }
    }
}

#endif

extension Format {
    /// Shared function that performs the command on the source files that should be processed.
    func performCommand(on sourceFiles: FileList, with swiftToolURL: URL, for targetName: String) throws {
        let configurationFileURL = sourceFiles.first(where: { file in file.url.pathExtension == "swift-format" })?.url
        let swiftSourceFiles = sourceFiles.filter { file in file.type == .source && file.url.pathExtension == "swift" }

        guard !swiftSourceFiles.isEmpty else {
            Diagnostics.remark("Target \"\(targetName)\" does not contain any swift source files.")
            return
        }

        var arguments = [
            "format",
            "format",
            "--in-place",
            "--parallel"
        ]
        if let configurationFileURL {
            let configurationFilePath = configurationFileURL.path(percentEncoded: false)
            Diagnostics.remark("Using configuration at \(configurationFilePath) for target \"\(targetName)\".")

            arguments += [
                "--configuration",
                configurationFilePath,
            ]
        }
        arguments += swiftSourceFiles.map({ file in file.url.path(percentEncoded: false) })

        let process = Process()
        process.executableURL = swiftToolURL
        process.arguments = arguments

        try process.run()
        process.waitUntilExit()

        switch process.terminationReason {
        case .exit:
            Diagnostics.remark("Formatted swift source files in target \"\(targetName)\"")
        case .uncaughtSignal:
            Diagnostics.error("Got uncaught signal while formatting swift source files in target \"\(targetName)\"")
        @unknown default:
            Diagnostics.error("Failed to format swift source files in target \"\(targetName)\" due to unexpected termination reason")
        }

        if process.terminationStatus != EXIT_SUCCESS {
            Diagnostics.error("Failed to format swift source files in target \"\(targetName)\" with termination reason \"\(process.terminationStatus)\"")
        }
    }
}
