// swift-tools-version: 6.0
import PackageDescription

/// PitchKit — absolute pitch + pitch-class leaf (no key / chord).
///
/// | Type | Role |
/// |------|------|
/// | ``Pitch`` | MIDI identity (`0...127`), octave / pitch-class derived |
/// | ``PitchClass`` | 12-TET class (`0...11`), sharp/flat names |
/// | ``PitchClassLabel`` / ``PitchLabel`` | SwiftUI name labels |
let package = Package(
    name: "PitchKit",
    platforms: [
        .iOS("26.5"),
        .macOS("26.5"),
    ],
    products: [
        .library(name: "PitchKit", targets: ["PitchKit"]),
    ],
    targets: [
        .target(name: "PitchKit"),
        .testTarget(
            name: "PitchKitTests",
            dependencies: ["PitchKit"]
        ),
    ]
)
