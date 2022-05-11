import UIKit
import SwiftUI

var orbitFontNames: [Font.Weight: String] = [:]

public extension Font {

    /// Fonts used for rendering text in Orbit.
    static var orbitFonts: [Font.Weight: URL?] = [
        .regular: Bundle.current.url(forResource: "CircularPro-Book.otf", withExtension: nil),
        .medium: Bundle.current.url(forResource: "CircularPro-Medium.otf", withExtension: nil),
        .bold: Bundle.current.url(forResource: "CircularPro-Bold.otf", withExtension: nil)
    ]

    /// Creates Orbit font.
    static func orbit(size: CGFloat, weight: Weight = .regular, style: Font.TextStyle = .body) -> Font {

        if orbitFontNames.isEmpty {
            return .system(size: size, weight: weight)
        }

        guard let fontName = orbitFontNames[weight] else {
            assertionFailure("Unsupported font weight")
            return .system(size: size, weight: weight)
        }

        if #available(iOS 14.0, *) {
            return .custom(fontName, size: size, relativeTo: style)
        } else {
            return .custom(fontName, size: size)
        }
    }

    /// Creates Orbit icon font.
    static func orbitIcon(size: CGFloat) -> Font {
        .custom("orbit-icons", size: size)
    }

    /// Registers Orbit fonts set in the `orbitTextFonts` property
    static func registerOrbitFonts() {

        if let iconsFontURL = Bundle.current.url(forResource: "Icons.ttf", withExtension: nil) {
            _ = registerFont(at: iconsFontURL)
        }

        for case let (weight, url?) in orbitFonts {
            guard let font = registerFont(at: url) else { continue }

            orbitFontNames[weight] = font.postScriptName as String?
        }
    }

    static func registerFont(at url: URL) -> CGFont? {

        guard let data = try? Data(contentsOf: url),
              let dataProvider = CGDataProvider(data: data as CFData),
              let font = CGFont(dataProvider)
        else {
            fatalError("Unable to load custom font from \(url)")
        }

        var error: Unmanaged<CFError>?
        if CTFontManagerRegisterGraphicsFont(font, &error) == false {
            print("Custom font registration error: \(String(describing: error))")
        }

        return font
    }
}

extension Font.Weight {

    var uiKit: UIFont.Weight {
        switch self {
            case .regular:  return .regular
            case .bold:     return .bold
            case .medium:   return .medium
            default:        return .regular
        }
    }
}
