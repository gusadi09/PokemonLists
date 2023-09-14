// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PokemonDataSource",
    defaultLocalization: "id",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PokemonDataSource",
            targets: ["PokemonDataSource"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
        .package(name: "PokemonExtensions", path: "PokemonExtensions"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PokemonDataSource",
            dependencies: ["Moya", "PokemonExtensions"],
            resources: [.process("./LocalDB/Model"), .process("./Localizable/String")]
        ),
        .testTarget(
            name: "PokemonDataSourceTests",
            dependencies: ["PokemonDataSource"]),
    ]
)
