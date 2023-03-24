import SwiftUI

/// Orbit label above form fields.
public struct FieldLabel: View {

    let label: String
    let accentColor: UIColor?

    public var body: some View {
        Text(label, size: .normal, weight: .medium, accentColor: accentColor)
            .accessibility(.fieldLabel)
    }

    /// Create Orbit form field label.
    public init(
        _ label: String,
        accentColor: UIColor? = nil
    ) {
        self.label = label
        self.accentColor = accentColor
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
            FieldLabel(longLabel, accentColor: .orangeNormal)
                .textLinkColor(.status(.critical))
        }
        .previewLayout(.sizeThatFits)
    }
}
