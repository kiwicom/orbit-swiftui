import UIKit
import SwiftUI

public extension UIFont {

    enum Size: Int, Comparable {

        /// Size 13. Equals to `Title 5`.
        case small = 13
        /// Size 15. Equals to `Title 4`.
        case normal = 15
        /// Size 16. Equals to `Title 3`.
        case large = 16
        /// Size 18.
        case xLarge = 18
        /// Size 22. Equals to `Title 2`.
        case title2 = 22
        /// Size 28. Equals to `Title 1`.
        case title1 = 28

        // MARK: iOS Specific
        /// Size 11.
        case tabBar = 11
        /// Size 17.
        case navigationBar = 17

        public static func < (lhs: Size, rhs: Size) -> Bool {
            lhs.rawValue < rhs.rawValue
        }

        public var value: CGFloat {
            CGFloat(self.rawValue)
        }
    }

    /// Creates Orbit font.
    static func orbit(size: Size = .normal, weight: Weight = .regular) -> UIFont {
        orbit(size: size.value, weight: weight)
    }

    static var orbit: UIFont {
        orbit()
    }
}

extension UIFont {

    private static let fractionPaddingFix: CGFloat = UIScreen.main.scale == 2 ? 0.24 : 0.16
    private static var lineHeights = [CGFloat: CGFloat]()

    static func orbit(size: CGFloat, weight: Weight = .regular) -> UIFont {
        let font: UIFont

        if let fontName = orbitFontNames[weight.swiftUI], let orbitFont = UIFont(name: fontName, size: size) {
            font = orbitFont
        } else {
            font = .systemFont(ofSize: size, weight: weight)
        }

        if lineHeights.keys.contains(size) == false {
            lineHeights[size] = round((font.lineHeight + fractionPaddingFix) * UIScreen.main.scale) / UIScreen.main.scale
        }

        return font
    }

    static func lineHeight(size: CGFloat) -> CGFloat {
        lineHeights[size] ?? 0
    }
}

private extension UIFont.Weight {

    var swiftUI: Font.Weight {
        switch self {
            case .regular:  return .regular
            case .bold:     return .bold
            case .medium:   return .medium
            default:        return .regular
        }
    }
}
