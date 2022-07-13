
public extension CountryFlag.CountryCode {

    init(_ string: String) {
        self = Self(rawValue: string.lowercased()) ?? .unknown
    }
}
