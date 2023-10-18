import UIKit
import Orbit

public extension UIImage {

    static func orbit(illustration: Illustration.Asset) -> UIImage {
        image(illustration.assetName)
    }
}
