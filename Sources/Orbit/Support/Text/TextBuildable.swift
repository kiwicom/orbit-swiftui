import SwiftUI

// Modifiers that shadow the SwiftUI modifiers need to have the exact signature
// in order to prefer the method of the Text over the generic View version

protocol TextBuildable {

    var baselineOffset: CGFloat? { get set }
    var fontWeight: Font.Weight? { get set }
    var color: Color? { get set }
}

protocol FormattedTextBuildable: TextBuildable {

    var accentColor: Color? { get set }
    var baselineOffset: CGFloat? { get set }
    var isBold: Bool? { get set }
    var isItalic: Bool? { get set }
    var isUnderline: Bool? { get set }
    var kerning: CGFloat? { get set }
    var strikethrough: Bool? { get set }
    var isMonospacedDigit: Bool? { get set }
}

extension TextBuildable {

    func set<V>(_ keypath: WritableKeyPath<Self, V>, to value: V) -> Self {
        var copy = self
        copy[keyPath: keypath] = value
        return copy
    }
}
