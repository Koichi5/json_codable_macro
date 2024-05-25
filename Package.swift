// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "JsonCodableMacro",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "JsonCodableMacro",
            targets: ["JsonCodableMacro"]
        ),
        .executable(
            name: "JsonCodableMacroClient",
            targets: ["JsonCodableMacroClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-04-25-b"),
    ],
    targets: [
        .macro(
            name: "JsonCodableMacroPlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "JsonCodableMacro", dependencies: ["JsonCodableMacroPlugin"]),

        .executableTarget(name: "JsonCodableMacroClient", dependencies: ["JsonCodableMacro"]),

        .testTarget(
            name: "JsonCodableMacroTests",
            dependencies: [
                "JsonCodableMacroPlugin",
                "JsonCodableMacroClient",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
