//
//  SwiftFormatLintBuildToolPlugin.swift
//  Swift Format Build Tool Plugins
//
//  Created by Caleb Friden on 12/10/24.
//

import PackagePlugin
import Foundation

@main
struct Lint: BuildToolPlugin {
    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        // This plugin only runs for package targets that can have source files.
        guard let sourceFiles = target.sourceModule?.sourceFiles else { return [] }

        // Find the swift tool to run.
        let swiftTool = try context.tool(named: "swift")
        let configurationFileURL = sourceFiles.first(where: { file in file.url.pathExtension == "swift-format" })?.url
        let swiftSourceFiles = sourceFiles.filter { file in file.type == .source && file.url.pathExtension == "swift" }

        return [
            createBuildCommand(
                for: swiftSourceFiles.map(\.url).compactMap(\.self),
                configurationFileURL: configurationFileURL,
                in: context.pluginWorkDirectoryURL,
                with: swiftTool.url
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension Lint: XcodeBuildToolPlugin {
    // Entry point for creating build commands for targets in Xcode projects.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        // Find the swift tool to run.
        let swiftTool = try context.tool(named: "swift")
        let configurationFileURL = target.inputFiles.first(where: { file in file.url.pathExtension == "swift-format" })?.url
        let swiftSourceFiles = target.inputFiles.filter { file in file.type == .source && file.url.pathExtension == "swift" }

        return [
            createBuildCommand(
                for: swiftSourceFiles.map(\.url).compactMap(\.self),
                configurationFileURL: configurationFileURL,
                in: context.pluginWorkDirectoryURL,
                with: swiftTool.url
            )
        ]
    }
}

#endif

extension Lint {
    /// Shared function that returns a configured build command if the input files is one that should be processed.
    func createBuildCommand(
        for swiftSourceFileURLS: [URL],
        configurationFileURL: URL?,
        in outputFilesDirectoryURL: URL,
        with swiftToolURL: URL
    ) -> Command {
        var arguments = [
            "format",
            "lint",
            "--parallel"
        ]
        if let configurationFileURL {
            let configurationFilePath = configurationFileURL.path(percentEncoded: false)
            Diagnostics.remark("Using configuration at \(configurationFilePath).")

            arguments += [
                "--configuration",
                configurationFilePath,
            ]
        }
        arguments += swiftSourceFileURLS.map({ url in url.path(percentEncoded: false) })
        return .prebuildCommand(
            displayName: "Run swift format lint",
            executable: swiftToolURL,
            arguments: arguments,
            environment: [:],
            outputFilesDirectory: outputFilesDirectoryURL
        )
    }
}
