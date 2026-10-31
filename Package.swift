// swift-tools-version: 5.9
// sWidget for iOS and macOS: SwidgetView, the widget configured in the Superroute back office, as a prebuilt
// XCFramework over sApp (SApp, SAppUI) and the sLocker customer kit (SLockerCustomer, SLockerUI).
// Documentation: https://open.superroute.ca/developer/swidget
import PackageDescription

let package = Package(
    name: "SWidget",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "SWidget", targets: ["SWidget", "SWidgetKits"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Goodneo-Solutions/sapp-releases", from: "0.2.5"),
        .package(url: "https://github.com/Goodneo-Solutions/slocker-customer-releases", from: "0.2.1"),
    ],
    targets: [
        .binaryTarget(
            name: "SWidget",
            url: "https://github.com/Goodneo-Solutions/swidget-releases/releases/download/0.2.0/SWidget.xcframework.zip",
            checksum: "78fa2d5a3a11dae2973a0c6d935234a61eff53ed2c9c01b8dc50acfee8c4a185"
        ),
        // A binary target cannot name dependencies: this empty target brings the kits into the product.
        .target(
            name: "SWidgetKits",
            dependencies: [
                .product(name: "SAppUI", package: "sapp-releases"),
                .product(name: "SLockerUI", package: "slocker-customer-releases"),
            ],
            path: "Sources/SWidgetKits"
        ),
    ]
)
