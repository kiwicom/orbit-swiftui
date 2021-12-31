import SwiftUI

public extension SwiftUI.Text {

    /// Creates a native SwiftUI Text from attributed string.
    @available(iOS, deprecated: 15.0, message: "Will be replaced with a native init")
    init(_ string: NSAttributedString) {
        self.init("")

        let fullRange = NSRange(location: 0, length: string.length)

        string.enumerateAttributes(in: fullRange, options: []) { attributes, range, _ in

            var text = Self(verbatim: string.attributedSubstring(from: range).string)

            if let color = attributes[.foregroundColor] as? UIColor {
                text = text.foregroundColor(Color(color))
            }

            if let font = attributes[.font] as? UIFont {
                text = text.font(.init(font))
            }

            if let kern = attributes[.kern] as? CGFloat {
                text = text.kerning(kern)
            }

            if let strikethrough = attributes[.strikethroughStyle] as? NSNumber, strikethrough != 0 {
                if let strikeColor = (attributes[.strikethroughColor] as? UIColor) {
                    text = text.strikethrough(true, color: Color(strikeColor))
                } else {
                    text = text.strikethrough(true)
                }
            }

            if let baseline = attributes[.baselineOffset] as? NSNumber {
                text = text.baselineOffset(CGFloat(baseline.floatValue))
            }

            if let underline = attributes[.underlineStyle] as? NSNumber, underline != 0 {
                if let underlineColor = (attributes[.underlineColor] as? UIColor) {
                    text = text.underline(true, color: Color(underlineColor))
                } else {
                    text = text.underline(true)
                }
            }

            // swiftlint:disable shorthand_operator
            self = self + text
        }
    }
}
