import SwiftUI

/// Orbit support component that displays a pair of label and a content.
///
/// A ``KeyValueField`` consists of a label and a content.
///
/// ```swift
/// KeyValueField("First Name") {
///     Text("Pavel")
/// }
/// ```
///
/// ### Layout
///
/// The text alignment can be modified by ``multilineTextAlignment(_:)``.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/keyvalue/)
public struct KeyValueField<Content: View>: View {

    @Environment(\.multilineTextAlignment) private var multilineTextAlignment
    
    private let key: String
    private let size: KeyValue.Size
    @ViewBuilder private let content: Content

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
public extension KeyValueField {

    /// Creates Orbit ``KeyValueField`` support component.
    init(
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
            .multilineTextAlignment(.trailing)
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
