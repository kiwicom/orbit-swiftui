
public protocol AssetNameProviding: RawRepresentable {

    var assetName: String { get }
}

public extension AssetNameProviding {

    var assetName: String {
        defaultAssetName
    }

    var defaultAssetName: String {
        let name = String(describing: self)
        return "\(name.prefix(1).capitalized)\(name.dropFirst())"
    }
}
