import SwiftUI

/// Environment key for setting the context for the `screenLayout` modifier.
public struct ScreenLayoutPaddingKey: EnvironmentKey {

    public static var defaultValue: ScreenLayoutPadding?
}

public extension EnvironmentValues {

    /// Indicates whether the content is inside the `screenLayout` context
    /// and specifies its padding in case it is.
    var screenLayoutPadding: ScreenLayoutPadding? {
        get { self[ScreenLayoutPaddingKey.self] }
        set { self[ScreenLayoutPaddingKey.self] = newValue }
    }
}
