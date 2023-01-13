import UIKit
import SwiftUI

var orbitFontNames: [Font.Weight: String] = [:]

public extension Font {

    static let orbitIconFontName = "orbit-icons"

    /// Default ratio between font size and desired line height, used for calculating custom text sizes.
    static var fontSizeToLineHeightRatio: CGFloat = 1.3333

    /// Ratio between font size and rendered single line text height.
    ///
    /// A custom font might need to provide a different value.
    ///
    /// Example:
    /// - Orbit Circular20 font 16pt size results in 19.33pt rendered height.
    static var fontSizeToHeightRatio: CGFloat = 1.208
    
    /// Fonts used for rendering text in Orbit.
    static var orbitFonts: [Font.Weight: URL?] = [
        .regular: Bundle.current.url(forResource: "Circular20-Book.otf", withExtension: nil),
        .medium: Bundle.current.url(forResource: "Circular20-Medium.otf", withExtension: nil),
        .bold: Bundle.current.url(forResource: "Circular20-Bold.otf", withExtension: nil),
        .black: Bundle.current.url(forResource: "Circular20-Black.otf", withExtension: nil),
    ]

    /// Creates Orbit font.
    static func orbit(size: CGFloat, scaledSize: CGFloat, weight: Weight = .regular) -> Font {

        if orbitFontNames.isEmpty {
            return nonScalingSystemFont(size: scaledSize, weight: weight)
        }

        guard let fontName = orbitFontNames[weight] else {
            assertionFailure("Unsupported font weight")
            return nonScalingSystemFont(size: scaledSize, weight: weight)
        }

        return customFont(fontName, size: size)
    }

    /// Creates Orbit icon font.
    static func orbitIcon(size: CGFloat) -> Font {
        customFont(orbitIconFontName, size: size)
    }

    /// Registers Orbit fonts set in the `orbitTextFonts` property.
    ///
    /// For more precise control over text line height and sizing,
    /// override `fontSizeToLineHeightRatio` and `fontSizeToHeightRatio` Font properties with custom values matching the font properties.
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

    private static func nonScalingSystemFont(size: CGFloat, weight: Font.Weight) -> Font {
        .system(size: size, weight: weight)
    }

    private static func customFont(_ name: String, size: CGFloat) -> Font {
        .custom(name, size: size)
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
