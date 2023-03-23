import CoreGraphics
import UIKit

/// Defines Orbit border widths.
public enum BorderWidth {
    /// 1 pixel border width.
    public static let hairline: CGFloat = 1.0 / UIScreen.main.scale
    /// 0.5 pt border width.
    public static let thin: CGFloat = 0.5
    /// A default 1 pt border.
    public static let `default`: CGFloat = 1.0
    /// 2 pt border width used for actively selected or highlighted components.
    public static let active: CGFloat = 2.0
}

public extension CGFloat {
    /// 1 pixel size.
    static let hairline: Self = BorderWidth.hairline
}
