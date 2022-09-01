import SwiftUI

/// A `KeyValue` container with generic content.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/keyvalue/)
public struct KeyValueField<Content: View>: View {

    let key: String
    let size: KeyValue.Size
    let alignment: HorizontalAlignment
    @ViewBuilder let content: Content

    public var body: some View {
        VStack(alignment: alignment, spacing: 0) {
            Text(key, size: size.keySize, color: .inkNormal, alignment: .init(alignment))
                .accessibility(.keyValueKey)

            content
                .accessibility(.keyValueValue)
        }
    }
}

// MARK: - Inits
extension KeyValueField {

    /// Creates Orbit KeyValue component.
    public init(
        _ key: String = "",
        size: KeyValue.Size = .normal,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder content: () -> Content
    ) {
        self.key = key
        self.size = size
        self.alignment = alignment
        self.content = content()
    }
}

// MARK: - Previews
struct KeyValueFieldPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone

            KeyValueField("Key", size: .large) {
                Text("Value")
            }

            KeyValueField("Trailing", alignment: .trailing) {
                contentPlaceholder
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
