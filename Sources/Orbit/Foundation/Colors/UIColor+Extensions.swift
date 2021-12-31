import UIKit

extension UIColor {

    static func fromResource(named: String) -> UIColor {
        guard let color = UIColor(named: named, in: Bundle.current, compatibleWith: nil) else {
            preconditionFailure("Cannot find color definition for '\(named)' in bundle")
        }

        return color
    }
}
