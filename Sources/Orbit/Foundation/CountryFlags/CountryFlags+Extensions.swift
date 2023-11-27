
public extension CountryFlag.CountryCode {

    /// Create Orbit ``CountryCode`` from a `String`.
    init(_ string: String) {
        self = Self(rawValue: string.lowercased()) ?? .unknown
    }
}
