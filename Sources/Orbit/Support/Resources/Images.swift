import UIKit
import SwiftUI

public extension Image {

    /// All other implicit Orbit related images.
    enum Symbol: CaseIterable, AssetNameProviding {

        case apple
        case facebook
        case google

        case logoKiwiComSymbol
        case logoKiwiComFull

        case navigateBack
        case navigateClose
    }

    static func orbit(_ image: Symbol) -> Image {
        Image(image.assetName, bundle: .current)
    }
}

public extension UIImage {

    /// Gets UIImage out of image resource.
    static func image(_ resource: String) -> UIImage {
        // swiftlint:disable:next use_orbit_not_image_named
        guard let uiImage = UIImage(named: resource, in: Bundle.current, compatibleWith: nil) else {
            assertionFailure("Cannot find image \(resource) in bundle")
            return UIImage()
        }

        return uiImage
    }

    /// A shorthand for `UIImage.image()`
    static func orbit(image: Image.Symbol) -> UIImage {
        Self.image(image.assetName)
    }

    static func orbit(illustration: Illustration.Image) -> UIImage {
        image(illustration.assetName)
    }
}
