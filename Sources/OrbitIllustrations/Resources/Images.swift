import UIKit
import Orbit

public extension UIImage {

    static func orbit(illustration: Illustration.Image) -> UIImage {
        image(illustration.assetName)
    }
}
