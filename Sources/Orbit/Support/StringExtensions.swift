
extension String {

    public var titleCased: String {
        (first?.uppercased() ?? "") + dropFirst()
    }
}
