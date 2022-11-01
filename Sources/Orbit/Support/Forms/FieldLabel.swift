import SwiftUI

/// Orbit label above form fields.
public struct FieldLabel: View {

    let label: String
    let accentColor: UIColor?
    let linkColor: TextLink.Color
    let linkAction: TextLink.Action

    public var body: some View {
        Text(label, size: .normal, weight: .medium, accentColor: accentColor, linkColor: linkColor, linkAction: linkAction)
            .padding(.bottom, 1)
            .accessibility(.fieldLabel)
    }

    /// Create Orbit form field label.
    public init(
        _ label: String,
        accentColor: UIColor? = nil,
        linkColor: TextLink.Color = .primary,
        linkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.label = label
        self.accentColor = accentColor
        self.linkColor = linkColor
        self.linkAction = linkAction
    }
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
