import SwiftUI

/// A pair of label and value to display read-only information.
///
/// - Related components:
///   - ``InputField``
///   - ``Text``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/keyvalue/)
public struct KeyValue: View {

    let key: String
    let value: String
    let alignment: HorizontalAlignment
    let valueAccessibilityIdentifier: String

    public var body: some View {
        KeyValueField(key, alignment: alignment) {
            Text(value, weight: .medium, alignment: .init(alignment), isSelectable: true)
                .accessibility(identifier: valueAccessibilityIdentifier)
        }
    }
}

// MARK: - Inits
extension KeyValue {

    /// Creates Orbit KeyValue component.
    public init(
        _ key: String = "",
        value: String = "",
        alignment: HorizontalAlignment = .leading,
        valueAccessibilityIdentifier: String = ""
    ) {
        self.key = key
        self.value = value
        self.alignment = alignment
        self.valueAccessibilityIdentifier = valueAccessibilityIdentifier
    }
}

// MARK: - Previews
struct KeyValuePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            KeyValue("Trailing", value: "Some value", alignment: .trailing)
            KeyValue("Centered", value: "Some value", alignment: .center)
            KeyValue("Multiline and very long key", value: "Multiline and very long value", alignment: .trailing)
                .frame(width: 100)
        }
        .padding()
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        KeyValue("Key", value: "Value")
    }
}
