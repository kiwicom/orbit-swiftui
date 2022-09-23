import SwiftUI

struct IdealSizeValue {
    var horizontal: Bool?
    var vertical: Bool?
}

struct IdealSizeKey: EnvironmentKey {
    static var defaultValue = IdealSizeValue()
}

extension EnvironmentValues {

    var idealSize: IdealSizeValue {
        get { self[IdealSizeKey.self] }
        set { self[IdealSizeKey.self] = newValue }
    }
}

public extension View {

    /// Sets expanding behaviour of view relative to its ideal size in specified direction.
    /// For specified axis, a value of `true` will prevent view from expending beyond its ideal size,
    /// while a value of `false` will force view to expand to infinity.
    ///
    /// To fix the view exactly to the ideal size, use `fixedSize` modifier instead.
    func idealSize(horizontal: Bool? = nil, vertical: Bool? = nil) -> some View {
        environment(\.idealSize, .init(horizontal: horizontal, vertical: vertical))
    }

    /// Prevents view from additionally expanding beyond its ideal size in both axis.
    ///
    /// To fix the view exactly to the ideal size, use `fixedSize` modifier instead.
    func idealSize() -> some View {
        idealSize(horizontal: true, vertical: true)
    }
}
