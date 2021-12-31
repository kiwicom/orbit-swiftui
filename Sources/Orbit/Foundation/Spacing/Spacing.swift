import CoreGraphics

/// Consistent spacing makes an interface more clear and easy to scan.
///
/// Our spacing is based on a 4-pixel grid.
///
/// - Note: [Orbit definition](https://orbit.kiwi/foundation/spacing/)
public enum Spacing {
    /// 2 pts spacing.
    public static let xxxSmall: CGFloat = 2
    /// 4 pts spacing.
    public static let xxSmall: CGFloat = 4
    /// 8 pts spacing.
    public static let xSmall: CGFloat = 8
    /// 12 pts spacing.
    public static let small: CGFloat = 12
    /// 16 pts spacing.
    public static let medium: CGFloat = 16
    /// 24 pts spacing.
    public static let large: CGFloat = 24
    /// 32 pts spacing.
    public static let xLarge: CGFloat = 32
    /// 40 pts spacing.
    public static let xxLarge: CGFloat = 40
    /// 52 pts spacing.
    public static let xxxLarge: CGFloat = 52
}

public extension CGFloat {
    /// 2 pts spacing.
    static let xxxSmall = Spacing.xxxSmall
    /// 4 pts spacing.
    static let xxSmall = Spacing.xxSmall
    /// 8 pts spacing.
    static let xSmall = Spacing.xSmall
    /// 12 pts spacing.
    static let small = Spacing.small
    /// 16 pts spacing.
    static let medium = Spacing.medium
    /// 24 pts spacing.
    static let large = Spacing.large
    /// 32 pts spacing.
    static let xLarge = Spacing.xLarge
    /// 40 pts spacing.
    static let xxLarge = Spacing.xxLarge
    /// 52 pts spacing.
    static let xxxLarge = Spacing.xxxLarge
}
