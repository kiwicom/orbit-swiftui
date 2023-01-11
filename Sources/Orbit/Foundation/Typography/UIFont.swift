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

        public var cgFloat: CGFloat {
            CGFloat(self.rawValue)
        }
    }

    /// Creates Orbit font.
    static func orbit(size: Size = .normal, weight: Weight = .regular) -> UIFont {
        orbit(size: size.cgFloat, weight: weight)
    }

    static var orbit: UIFont {
        orbit()
    }
}

extension UIFont {

    static func orbit(size: CGFloat, weight: Weight = .regular) -> UIFont {

        if orbitFontNames.isEmpty {
            return .systemFont(ofSize: size, weight: weight)
        }

        guard let fontName = orbitFontNames[weight.swiftUI], let font = UIFont(name: fontName, size: size) else {
            assertionFailure("Unsupported font weight")
            return .systemFont(ofSize: size, weight: weight)
        }

        return font
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
