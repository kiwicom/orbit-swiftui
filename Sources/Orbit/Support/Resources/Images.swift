import SwiftUI

public extension Image {

    /// Orbit image asset.
    enum Asset: String, CaseIterable, AssetNameProviding, Sendable {

        case apple
        case facebook
        case google

        case logoKiwiComSymbol
        case logoKiwiComFull

        case navigateBack
        case navigateClose
    }
    
    /// Creates an image for selected Orbit asset.
    static func orbit(_ asset: Asset) -> Self {
        self.init(asset.assetName, bundle: .module)
    }
}
