import SwiftUI

/// Consistent spacing makes an interface more clear and easy to scan.
///
/// Our spacing is based on a 4-pixel grid.
///
/// - Note: [Orbit definition](https://orbit.kiwi/foundation/spacing/)
public enum Spacing: CGFloat {
    /// 2 pts.
    case xxxSmall = 2
    /// 4 pts.
    case xxSmall = 4
    /// 8 pts.
    case xSmall = 8
    /// 12 pts.
    case small = 12
    /// 16 pts.
    case medium = 16
    /// 20 pts.
    case xMedium = 20
    /// 24 pts.
    case large = 24
    /// 32 pts.
    case xLarge = 32
    /// 44 pts.
    case xxLarge = 44
    /// 60 pts.
    case xxxLarge = 60
}

public extension CGFloat {
    /// 2 pts
    static let xxxSmall = Spacing.xxxSmall.rawValue
    /// 4 pts.
    static let xxSmall = Spacing.xxSmall.rawValue
    /// 8 pts.
    static let xSmall = Spacing.xSmall.rawValue
    /// 12 pts.
    static let small = Spacing.small.rawValue
    /// 16 pts.
    static let medium = Spacing.medium.rawValue
    /// 20 pts.
    static let xMedium = Spacing.xMedium.rawValue
    /// 24 pts.
    static let large = Spacing.large.rawValue
    /// 32 pts.
    static let xLarge = Spacing.xLarge.rawValue
    /// 44 pts.
    static let xxLarge = Spacing.xxLarge.rawValue
    /// 60 pts.
    static let xxxLarge = Spacing.xxxLarge.rawValue
}
