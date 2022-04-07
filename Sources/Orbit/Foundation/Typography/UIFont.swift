import UIKit
import SwiftUI

public extension UIFont {

    enum Size: Int, Comparable {

        // MARK: Text

        /// Size 10.
        case smaller = 10
        /// Size 12. Equals to `Title 5`.
        case small = 12
        /// Size 14. Equals to `Title 4`.
        case normal = 14
        /// Size 16. Equals to `Title 3`.
        case large = 16

        // MARK: Headings

        /// Size 18. Non-Orbit. Will be removed.
        case xLarge = 18

        /// Size 22. Equals to `Display Subtitle`.
        case title2 = 22
        /// Size 28.
        case title1 = 28

        /// Size 40.
        case displayTitle = 40

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
