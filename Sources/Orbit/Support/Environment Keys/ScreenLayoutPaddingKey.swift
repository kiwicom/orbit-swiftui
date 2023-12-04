import SwiftUI

struct ScreenLayoutPaddingKey: EnvironmentKey {
    static let defaultValue: ScreenLayoutPadding? = nil
}

public extension EnvironmentValues {

    /// Indicates whether the content is inside the Orbit `screenLayout` context
    /// and specifies its padding in case it is.
    var screenLayoutPadding: ScreenLayoutPadding? {
        get { self[ScreenLayoutPaddingKey.self] }
        set { self[ScreenLayoutPaddingKey.self] = newValue }
    }
}
