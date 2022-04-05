import SwiftUI

/// A `KeyValue` container with generic content.
///
/// - Related components:
///   - ``InputField``
///   - ``Text``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/keyvalue/)
public struct KeyValueField<Content: View>: View {

    let key: String
    let content: () -> Content
    let alignment: HorizontalAlignment

    public var body: some View {
        VStack(alignment: alignment, spacing: 0) {
            Text(key, size: .small, color: .inkLight, alignment: .init(alignment))

            content()
        }
    }
}

// MARK: - Inits
extension KeyValueField {

    /// Creates Orbit KeyValue component.
    public init(
        _ key: String = "",
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.key = key
        self.alignment = alignment
        self.content = content
    }
}

// MARK: - Previews
struct KeyValueFieldPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone

            KeyValueField("Trailing", alignment: .trailing) {
                customContentPlaceholder
            }

            KeyValueField("Key") {
                SwiftUI.Text("Custom text").kerning(10)
            }

            KeyValueField("Multiline and very long key", alignment: .trailing) {
                Text("Multiline and very long value", alignment: .trailing)
            }
            .frame(width: 100)
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        KeyValueField("Key") {
            Text("Value")
        }
    }
}
