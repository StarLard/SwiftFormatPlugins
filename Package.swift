// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swift Format Plugins",
    products: [
        .plugin(
            name: "Lint",
            targets: ["SwiftFormatLintBuildToolPlugin"]
        ),
        .plugin(
            name: "Format",
            targets: ["SwiftFormatCommandToolPlugin"]
        ),
    ],
    targets: [
        .plugin(
            name: "SwiftFormatLintBuildToolPlugin",
            capability: .buildTool()
        ),
        .plugin(
            name: "SwiftFormatCommandToolPlugin",
            capability: .command(
                intent: .sourceCodeFormatting(),
                permissions: [.writeToPackageDirectory(reason: "Format source code")]
            )
        )
    ]
)
