// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TurenKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TurenKit",
            targets: ["TurenKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/RxSwiftCommunity/RxAlamofire.git", .upToNextMajor(from: "6.1.0")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/hmlongco/Factory.git", .upToNextMajor(from: "2.5.3")),
        .package(url: "https://github.com/Miles-Matheson/HandyJSON.git", branch: "master"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "8.0.0")),
        .package(url: "https://github.com/chiahsien/CHTCollectionViewWaterfallLayout.git", from: "0.9.9"),
        .package(url: "https://github.com/devxoul/URLNavigator.git", from: "2.5.1"),
        .package(url: "https://github.com/ashleymills/Reachability.swift.git", from: "5.2.4"),
        .package(url: "https://github.com/CoderMJLee/MJRefresh.git", .upToNextMajor(from: "3.7.9")),
        .package(url: "https://github.com/wxxsw/GSPlayer.git", .upToNextMajor(from: "0.2.30")),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.2"),
        .package(url: "https://github.com/eggswift/ESTabBarController.git", .upToNextMajor(from: "2.9.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TurenKit",
            dependencies: [
                .product(name: "RxAlamofire", package: "RxAlamofire"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "Factory", package: "Factory"),
                .product(name: "HandyJSON", package: "HandyJSON"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "CHTCollectionViewWaterfallLayout", package: "CHTCollectionViewWaterfallLayout"),
                .product(name: "URLNavigator", package: "URLNavigator"),
                .product(name: "Reachability", package: "Reachability.swift"),
                .product(name: "MJRefresh", package: "MJRefresh"),
                .product(name: "GSPlayer", package: "GSPlayer"),
                .product(name: "Lottie", package: "lottie-spm"),
                .product(name: "ESTabBarController", package: "ESTabBarController"),
            ]
        ),
        .testTarget(
            name: "TurenKitTests",
            dependencies: ["TurenKit"]
        ),
    ]
)
