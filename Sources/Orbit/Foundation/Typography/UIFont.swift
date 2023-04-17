import UIKit
import SwiftUI

public extension UIFont {

    static var orbit: UIFont {
        orbit(size: Text.Size.normal.value)
    }

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
}

extension UIFont {

    private static let fractionPaddingFix: CGFloat = UIScreen.main.scale == 2 ? 0.24 : 0.16
    private static var lineHeights = [CGFloat: CGFloat]()

    static func lineHeight(size: CGFloat) -> CGFloat {
        lineHeights[size] ?? 0
    }
}

private extension UIFont.Weight {

    var swiftUI: Font.Weight {
        switch self {
            case .ultraLight:   return .ultraLight
            case .thin:         return .thin
            case .light:        return .light
            case .regular:      return .regular
            case .medium:       return .medium
            case .semibold:     return .semibold
            case .bold:         return .bold
            case .heavy:        return .heavy
            case .black:        return .black
            default:            return .regular
        }
    }
}
