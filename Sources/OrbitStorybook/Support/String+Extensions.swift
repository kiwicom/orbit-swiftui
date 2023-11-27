
extension String {

    var titleCased: String {
        (first?.uppercased() ?? "") + dropFirst()
    }
}
