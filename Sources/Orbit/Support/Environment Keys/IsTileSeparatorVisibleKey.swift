import SwiftUI

struct IsTileSeparatorVisibleKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

public extension EnvironmentValues {

    /// Indicates whether a ``Tile``'s separator should be visible.
    var isTileSeparatorVisible: Bool {
        get { self[IsTileSeparatorVisibleKey.self] }
        set { self[IsTileSeparatorVisibleKey.self] = newValue }
    }
}
