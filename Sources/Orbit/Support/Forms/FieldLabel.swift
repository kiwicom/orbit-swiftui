import SwiftUI

/// Orbit label above form fields.
public struct FieldLabel: View {

    let label: String
    let accentColor: UIColor?
    let linkColor: TextLink.Color

    public var body: some View {
        Text(label, size: .normal, weight: .medium, accentColor: accentColor, linkColor: linkColor)
            .accessibility(.fieldLabel)
    }

    /// Create Orbit form field label.
    public init(
        _ label: String,
        accentColor: UIColor? = nil,
        linkColor: TextLink.Color = .primary
    ) {
        self.label = label
        self.accentColor = accentColor
        self.linkColor = linkColor
    }
}

// MARK: - Identifiers
public extension AccessibilityID {

    static let fieldLabel = Self(rawValue: "orbit.field.label")
}

// MARK: - Previews
struct FieldLabelPreviews: PreviewProvider {

    static let longLabel = """
        <strong>Label</strong> with a \(String(repeating: "very ", count: 20))long \
        <ref>multiline</ref> label and <applink1>TextLink</applink1>
        """

    static var previews: some View {
        PreviewWrapper {
            FieldLabel("Form Field Label")
            FieldLabel(longLabel, accentColor: .orangeNormal, linkColor: .status(.critical))
        }
        .previewLayout(.sizeThatFits)
    }
}
