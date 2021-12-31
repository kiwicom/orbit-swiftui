import UIKit
import SwiftUI

public extension Font {

    /// Creates Orbit font.
    static func orbit(size: CGFloat, weight: Weight = .regular) -> Font {
        Font.custom(weight.name, size: size)
    }

    /// Creates Orbit icon font.
    static func orbitIcon(size: CGFloat) -> Font {
        Font.custom("orbit-icons", size: size)
    }

    /// Registers Orbit fonts.
    static func registerOrbitFonts() {
        for fontName in ["CircularPro-Book.otf", "CircularPro-Bold.otf", "CircularPro-Medium.otf", "Icons.ttf"] {
            guard let url = Bundle.current.url(forResource: fontName, withExtension: nil),
                  let data = try? Data(contentsOf: url),
                  let dataProvider = CGDataProvider(data: data as CFData),
                  let font = CGFont(dataProvider)
            else {
                fatalError("Unable to load custom font [\(fontName)]")
            }

            var error: Unmanaged<CFError>?
            if CTFontManagerRegisterGraphicsFont(font, &error) == false {
                print("Custom font registration error: \(String(describing: error))")
            }
        }
    }
}

extension Font.Weight {

    var name: String {
        switch self {
            case .regular:
                return "CircularPro-Book"
            case .bold:
                return "CircularPro-Bold"
            case .medium:
                return "CircularPro-Medium"
            default:
                assertionFailure("Unsupported font weight")
                return "CircularPro-Book"
        }
    }

    var uiKit: UIFont.Weight {
        switch self {
            case .regular:  return .regular
            case .bold:     return .bold
            case .medium:   return .medium
            default:        return .regular
        }
    }
}
