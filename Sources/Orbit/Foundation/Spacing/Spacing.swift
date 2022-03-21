import CoreGraphics

/// Consistent spacing makes an interface more clear and easy to scan.
///
/// Our spacing is based on a 4-pixel grid.
///
/// - Note: [Orbit definition](https://orbit.kiwi/foundation/spacing/)
public enum Spacing {
    /// 2 pts.
    public static let xxxSmall: CGFloat = 2
    /// 4 pts.
    public static let xxSmall: CGFloat = 4
    /// 8 pts.
    public static let xSmall: CGFloat = 8
    /// 12 pts.
    public static let small: CGFloat = 12
    /// 16 pts.
    public static let medium: CGFloat = 16
    /// 20 pts.
    public static let xMedium: CGFloat = 20
    /// 24 pts.
    public static let large: CGFloat = 24
    /// 32 pts.
    public static let xLarge: CGFloat = 32
    /// 44 pts.
    public static let xxLarge: CGFloat = 44
    /// 60 pts.
    public static let xxxLarge: CGFloat = 60
}

public extension CGFloat {
    /// 2 pts
    static let xxxSmall = Spacing.xxxSmall
    /// 4 pts.
    static let xxSmall = Spacing.xxSmall
    /// 8 pts.
    static let xSmall = Spacing.xSmall
    /// 12 pts.
    static let small = Spacing.small
    /// 16 pts.
    static let medium = Spacing.medium
    /// 20 pts.
    static let xMedium = Spacing.xMedium
    /// 24 pts.
    static let large = Spacing.large
    /// 32 pts.
    static let xLarge = Spacing.xLarge
    /// 44 pts.
    static let xxLarge = Spacing.xxLarge
    /// 60 pts.
    static let xxxLarge = Spacing.xxxLarge
}
