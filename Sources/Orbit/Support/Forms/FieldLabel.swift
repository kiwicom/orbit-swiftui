import SwiftUI

/// Orbit support component that displays label positioned above a form field.
public struct FieldLabel: View {

    private let label: String

    public var body: some View {
        Text(label)
            .fontWeight(.medium)
    }

    /// Creates Orbit ``FieldLabel``.
    public init(_ label: String) {
        self.label = label
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
            FieldLabel(longLabel)
                .textLinkColor(.status(.critical))
                .textAccentColor(.orangeNormal)
        }
        .previewLayout(.sizeThatFits)
    }
}
