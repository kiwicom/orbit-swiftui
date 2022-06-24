import SwiftUI

/// Environment key for setting the visibility of separators in ``Tile``.
public struct IsTileSeparatorVisibleKey: EnvironmentKey {
    public static var defaultValue: Bool = true
}

public extension EnvironmentValues {

    /// Indicates whether a ``Tile``'s separator should be visible.
    var isTileSeparatorVisible: Bool {
        get { self[IsTileSeparatorVisibleKey.self] }
        set { self[IsTileSeparatorVisibleKey.self] = newValue }
    }
}
