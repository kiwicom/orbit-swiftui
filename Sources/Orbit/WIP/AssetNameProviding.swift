
public protocol AssetNameProviding {

    var assetName: String { get }
}

extension AssetNameProviding {

    public var assetName: String {
        let name = String(describing: self)
        return "\(name.prefix(1).capitalized)\(name.dropFirst())"
    }
}
