//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftOpenAPIGenerator open source project
//
// Copyright (c) 2023 Apple Inc. and the SwiftOpenAPIGenerator project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftOpenAPIGenerator project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//
import PackagePlugin
import Foundation

struct ExtensionsFile: Decodable {
    var naming: String?
}

@main
struct SwiftOpenAPIGeneratorPlugin {
    func createBuildCommands(
        pluginWorkDirectory: Path,
        tool: (String) throws -> PluginContext.Tool,
        sourceFiles: FileList,
        targetName: String
    ) throws -> [Command] {
        let inputs = try PluginUtils.validateInputs(
            workingDirectory: pluginWorkDirectory,
            tool: tool,
            sourceFiles: sourceFiles,
            targetName: targetName,
            pluginSource: .build
        )
        var arguments = inputs.arguments

        if let extensionsFile =
            sourceFiles
            .first(where: { $0.path.lastComponent == "openapi-generator-extensions.json" })
        {
            let data = try Data(contentsOf: URL(fileURLWithPath: extensionsFile.path.string))
            let extensions = try JSONDecoder().decode(ExtensionsFile.self, from: data)
            if let naming = extensions.naming {
                arguments.append(contentsOf: [
                    "--compute-name-extension-path",
                    
                    // TODO: This doesn't work :(
                    // The plugin from SOAR get access to the tool built
                    // for the dependency.
                    try tool(naming).path.string,
                ])
            }
        }

        let outputFiles: [Path] = GeneratorMode.allCases.map { inputs.genSourcesDir.appending($0.outputFileName) }
        return [
            .buildCommand(
                displayName: "Running swift-openapi-generator",
                executable: inputs.tool.path,
                arguments: arguments,
                environment: [:],
                inputFiles: [
                    inputs.config,
                    inputs.doc,
                ],
                outputFiles: outputFiles
            )
        ]
    }
}

extension SwiftOpenAPIGeneratorPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PluginContext,
        target: Target
    ) async throws -> [Command] {
        guard let swiftTarget = target as? SwiftSourceModuleTarget else {
            throw PluginError.incompatibleTarget(name: target.name)
        }
        return try createBuildCommands(
            pluginWorkDirectory: context.pluginWorkDirectory,
            tool: context.tool,
            sourceFiles: swiftTarget.sourceFiles,
            targetName: target.name
        )
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftOpenAPIGeneratorPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(
        context: XcodePluginContext,
        target: XcodeTarget
    ) throws -> [Command] {
        return try createBuildCommands(
            pluginWorkDirectory: context.pluginWorkDirectory,
            tool: context.tool,
            sourceFiles: target.inputFiles,
            targetName: target.displayName
        )
    }
}
#endif
