import SwiftUI

struct LocalizationBundleKey: EnvironmentKey {
    static let defaultValue: Bundle = .main
}

public extension EnvironmentValues {

    /// A bundle used for Orbit localization using `LocalizedStringKey` stored in a view’s environment. 
    /// The `Bundle.main` is used by default.
    var localizationBundle: Bundle {
        get { self[LocalizationBundleKey.self] }
        set { self[LocalizationBundleKey.self] = newValue }
    }
}

public extension View {

    /// Set the default bundle used for Orbit localization of `LocalizedStringKey` based texts in this view. 
    /// 
    /// Only applies to texts where the bundle is not explicitly specified. 
    ///
    /// - Parameters:
    ///   - bundle: A bundle that will be used to localize Orbit texts within the view hierarchy.
    /// - Important: Does not affect texts specified using `LocalizedStringResource` where the bundle is embedded.
    func localizationBundle(_ bundle: Bundle) -> some View {
        environment(\.localizationBundle, bundle)
    }
}
