import SwiftUI

/// Orbit label positioned above a form field.
public struct FieldLabel: View {

    private let label: String

    public var body: some View {
        Text(label, size: .normal)
            .fontWeight(.medium)
            .accessibility(.fieldLabel)
    }

    /// Create Orbit form field label.
    public init(_ label: String) {
        self.label = label
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
            FieldLabel(longLabel)
                .textLinkColor(.status(.critical))
                .textAccentColor(.orangeNormal)
        }
        .previewLayout(.sizeThatFits)
    }
}
