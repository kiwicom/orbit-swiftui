import SwiftUI

/// The expanding behaviour of compatible Orbit components in a view relative to their ideal size for each axis.
public struct IdealSizeValue {
    public var horizontal: Bool?
    public var vertical: Bool?
}

struct IdealSizeKey: EnvironmentKey {
    static let defaultValue = IdealSizeValue()
}

public extension EnvironmentValues {

    /// The expanding behaviour of compatible Orbit components in a view relative to their ideal size.
    var idealSize: IdealSizeValue {
        get { self[IdealSizeKey.self] }
        set { self[IdealSizeKey.self] = newValue }
    }
}

public extension View {

    /// Sets the expanding behaviour of compatible Orbit components in a view relative to their ideal size in specified direction.
    /// 
    /// For specified axis, a value of `true` will prevent component from expending beyond its ideal size,
    /// while a value of `false` will force component to expand to infinity. A value of `nil` keeps the default behaviour.
    ///
    /// - Note: To fix the view exactly to the ideal size, use `fixedSize` modifier instead.
    func idealSize(horizontal: Bool? = nil, vertical: Bool? = nil) -> some View {
        environment(\.idealSize, .init(horizontal: horizontal, vertical: vertical))
    }

    /// Prevents compatible Orbit components in a view from additionally expanding beyond its ideal size in both axis.
    ///
    /// To control separate axis and behaviour, use ``idealSize(horizontal:vertical:)`` modifier.
    ///
    /// - Note: To fix the view exactly to the ideal size, use `fixedSize` modifier instead.
    func idealSize() -> some View {
        idealSize(horizontal: true, vertical: true)
    }
}
