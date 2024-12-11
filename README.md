# SwiftFormatPlugins

[![SwiftPM compatible](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)
[![Swift Package Index](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStarLard%2FSwiftFormatPlugins%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/StarLard/SwiftFormatPlugins)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://github.com/StarLard/SwiftFormatPlugins/blob/main/LICENSE)

SwiftFormatPlugins adds [build tool plug-ins](https://github.com/swiftlang/swift-package-manager/blob/main/Documentation/Plugins.md) for Apple's [swift-format](https://github.com/swiftlang/swift-format) formatting tools. In contrast to the command plug-ins which are included as part of the `swift-format` project, these plug-ins allow you to run both the `lint` and `format` commands automatically before each build, removing the need to manually execute them.

## Note

This package depends on the `swift-format` installation [included](https://github.com/swiftlang/swift-format?tab=readme-ov-file#included-in-the-swift-toolchain) in the Swift toolchain with Swift 6 and higher.

## Installation

SwiftFormatPlugins is available through [Swift Package Manager](https://swift.org/package-manager/), a dependency manager built into Xcode.

If you are using Xcode 11 or higher, go to **File / Swift Packages / Add Package Dependency...** and enter package repository URL **https://github.com/StarLard/SwiftFormatPlugins.git**, then follow the instructions.

To remove the dependency, select the project and open **Swift Packages** (which is next to **Build Settings**). You can add and remove packages from this tab.

> Swift Package Manager can also be used [from the command line](https://swift.org/package-manager/).

## Usage

Both the 'Lint' and 'Format' plug-ins check each target they are executed against for an associated [.swift-format](https://github.com/swiftlang/swift-format?tab=readme-ov-file#configuring-the-command-line-tool) JSON file. If one is present, any subsequent invocations of `swift format` for that target will be passed the configuration file. If not, the default configuration will be used.

1. Select your project in the Xcode Project navigator pane and navigate to the target you wish to execute against.
2. Open the 'Build Phases' tab and click the + icon under the 'Run Build Tool Plug-ins' section.
3. Select the desired plugin from the dropdown and choose "Trust & Enable" from the subsequent prompt.

## Author

[@StarLard](https://github.com/StarLard)

## License

SwiftFormatPlugins is available under the Apache 2.0 license. See the LICENSE file for more info.
