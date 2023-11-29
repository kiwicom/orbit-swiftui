import SwiftUI

/// A `KeyValue` container with generic content.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/keyvalue/)
public struct KeyValueField<Content: View>: View {

    @Environment(\.multilineTextAlignment) private var multilineTextAlignment
    
    let key: String
    let size: KeyValue.Size
    @ViewBuilder let content: Content

    public var body: some View {
        VStack(alignment: .init(multilineTextAlignment), spacing: 0) {
            Text(key)
                .textSize(size.keySize)
                .textColor(.inkNormal)
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
        @ViewBuilder content: () -> Content
    ) {
        self.key = key
        self.size = size
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

            KeyValueField("Trailing") {
                contentPlaceholder
            }
            .multilineTextAlignment(.trailing)

            KeyValueField("Key") {
                Text("Custom text")
                    .kerning(10)
            }

            KeyValueField("Multiline and very long key") {
                Text("Multiline and very long value")
            }
            .frame(width: 100)
            .multilineTextAlignment(.trailing)
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        KeyValueField("Key") {
            Text("Value")
        }
        .previewDisplayName()
    }
}
