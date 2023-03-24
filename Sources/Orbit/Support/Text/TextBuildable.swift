import SwiftUI

protocol TextBuildable {

    var accentColor: UIColor? { get set }
}

extension TextBuildable {

    func withAccentColor(_ accentColor: UIColor?) -> Self {
        var copy = self
        copy.accentColor = accentColor
        return copy
    }
}

public extension Text {

    /// Returns a modified Text with provided accent color.
    ///
    /// When the value is `nil`, the environment value will be used instead.
    ///
    /// - Parameters:
    ///   - color: A color that will be used in `<ref>` tags in this text.
    func textAccentColor(_ accentColor: UIColor?) -> Self {
        withAccentColor(accentColor)
    }
}

public extension Heading {

    /// Returns a modified Heading with provided accent color.
    ///
    /// When the value is `nil`, the environment value will be used instead.
    ///
    /// - Parameters:
    ///   - color: A color that will be used in `<ref>` tags in this heading.
    func textAccentColor(_ accentColor: UIColor?) -> Self {
        withAccentColor(accentColor)
    }
}
