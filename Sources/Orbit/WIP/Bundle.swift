import Foundation

private class CurrentBundleFinder {}

public extension Bundle {

    /// Workaround for a SwiftPM bug to be able to access bundle resources from test targets and SwiftUI previews.
    /// Normally, `Bundle.module` would be used instead.
    /// Returns the resource bundle associated with the current Swift module.
    /// Xcode bug (rdar://8802612, BUG:FB8893830).
    static var current: Bundle = {
        let bundleName = "Orbit_Orbit"

        let candidates = [
            main.resourceURL,
            Bundle(for: CurrentBundleFinder.self).resourceURL,
            main.bundleURL,
            Bundle(for: CurrentBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent(),
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }

            let bundleRootPath = candidate?.appendingPathComponent("../" + bundleName + ".bundle")
            if let bundle = bundleRootPath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        fatalError("unable to find bundle named \(bundleName)")
    }()
}
