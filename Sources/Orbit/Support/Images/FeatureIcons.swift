import UIKit

// swiftlint:disable convenience_type

/// A feature icon matching Orbit name.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/feature-icon/)
public struct FeatureIcon {
    // FIXME: SwiftUI Component TBD
}

public extension FeatureIcon {
    
    enum Symbol: CaseIterable, AssetNameProviding {
        case ticketFlexi
        case ticketSaver
        case ticketStandard
    }
}

public extension UIImage {

    static func orbit(featureIcon: FeatureIcon.Symbol) -> UIImage {
        image(featureIcon)
    }
}
