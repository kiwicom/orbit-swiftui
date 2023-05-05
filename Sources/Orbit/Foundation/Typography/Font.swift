import UIKit
import SwiftUI

var orbitFontNames: [Font.Weight: String] = [:]

public extension Font {

    static let orbitIconFontName = "orbit-icons"

    /// Default ratio between font size and desired line height, used for calculating custom text sizes.
    static var fontSizeToLineHeightRatio: CGFloat = 1.3333
    
    /// Fonts used for rendering text in Orbit.
    static var orbitFonts: [Font.Weight: URL?] = [
        .ultraLight: Bundle.orbit.url(forResource: "Circular20-Book.otf", withExtension: nil),
        .thin: Bundle.orbit.url(forResource: "Circular20-Book.otf", withExtension: nil),
        .light: Bundle.orbit.url(forResource: "Circular20-Book.otf", withExtension: nil),
        .regular: Bundle.orbit.url(forResource: "Circular20-Book.otf", withExtension: nil),

        .medium: Bundle.orbit.url(forResource: "Circular20-Medium.otf", withExtension: nil),
        .semibold: Bundle.orbit.url(forResource: "Circular20-Medium.otf", withExtension: nil),

        .bold: Bundle.orbit.url(forResource: "Circular20-Bold.otf", withExtension: nil),

        .heavy: Bundle.orbit.url(forResource: "Circular20-Black.otf", withExtension: nil),
        .black: Bundle.orbit.url(forResource: "Circular20-Black.otf", withExtension: nil),
    ]

    /// Creates Orbit font.
    static func orbit(size: CGFloat, weight: Weight = .regular) -> Font {
        Font(UIFont.orbit(size: size, weight: weight.uiKit))
    }

    /// Creates Orbit icon font.
    static func orbitIcon(size: CGFloat) -> Font {
        customFont(orbitIconFontName, size: size)
    }

    /// Registers Orbit fonts set in the `orbitTextFonts` property.
    static func registerOrbitFonts() {

        if let iconsFontURL = Bundle.orbit.url(forResource: "Icons.ttf", withExtension: nil) {
            _ = registerFont(at: iconsFontURL)
        }

        var registeredFonts: [URL: CGFont] = [:]

        for case let (weight, url?) in orbitFonts {
            guard let font = registeredFonts[url] ?? registerFont(at: url) else { continue }

            if registeredFonts[url] == nil {
                registeredFonts[url] = font
            }

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

    private static func customFont(_ name: String, size: CGFloat) -> Font {
        .custom(name, size: size)
    }
}

extension Font.Weight {

    var uiKit: UIFont.Weight {
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

public extension ContentSizeCategory {

    /// Effective font size ratio.
    var ratio: CGFloat {
        switch self {
            case .extraSmall:                           return 0.8
            case .small:                                return 0.85
            case .medium:                               return 0.9
            case .large:                                return 1        // Default
            case .extraLarge:                           return 1.1
            case .extraExtraLarge:                      return 1.2
            case .extraExtraExtraLarge:                 return 1.35
            case .accessibilityMedium:                  return 1.6
            case .accessibilityLarge:                   return 1.9
            case .accessibilityExtraLarge:              return 2.35
            case .accessibilityExtraExtraLarge:         return 2.75
            case .accessibilityExtraExtraExtraLarge:    return 3.1
            @unknown default:                           return 1
        }
    }

    /// Effective size ratio for controls, based on font size ratio.
    /// The ratio is smaller than font size ratio and should be used for components or indicators that are already large enough.
    var controlRatio: CGFloat {
        1 + (ratio - 1) * 0.5
    }

    @available(iOS, deprecated: 15.0, message: "Use DynamicTypeSize.isAccessibilitySize instead from iOS 15.0")
    var isAccessibilitySize: Bool {
        ratio >= 1.6
    }
}
