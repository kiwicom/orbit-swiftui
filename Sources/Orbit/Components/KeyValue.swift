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
    let size: Size
    let alignment: HorizontalAlignment
    let valueAccessibilityIdentifier: String

    public var body: some View {
        KeyValueField(key, size: size, alignment: alignment) {
            Text(value, size: size.valueSize, weight: .medium, alignment: .init(alignment), isSelectable: true)
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
        size: Size = .normal,
        alignment: HorizontalAlignment = .leading,
        valueAccessibilityIdentifier: String = ""
    ) {
        self.key = key
        self.value = value
        self.size = size
        self.alignment = alignment
        self.valueAccessibilityIdentifier = valueAccessibilityIdentifier
    }
}

// MARK: - Types
extension KeyValue {

    public enum Size {
        case normal
        case large

        var keySize: Text.Size {
            switch self {
                case .normal:   return .small
                case .large:    return .normal
            }
        }

        var valueSize: Text.Size {
            switch self {
                case .normal:   return .normal
                case .large:    return .large
            }
        }
    }
}

// MARK: - Previews
struct KeyValuePreviews: PreviewProvider {

    static let key = "Key"
    static let value = "Value"
    static let longValue = "Some very very very very very long value"

    static var previews: some View {
        PreviewWrapper {
            standalone
            storybook
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            KeyValue(key, value: value)
            KeyValue()          // EmptyView
            KeyValue("")        // EmptyView
            KeyValue(value: "") // EmptyView
        }
        .padding(.medium)
    }

    static var storybook: some View {
        VStack(alignment: .leading, spacing: .large) {
            KeyValue("Key", value: value)
            KeyValue("Key", value: value, size: .large)
            Separator()
            HStack(alignment: .firstTextBaseline, spacing: .large) {
                KeyValue("Key with no value")
                Spacer()
                KeyValue(value: "Value with no key")
            }
            Separator()
            HStack(alignment: .firstTextBaseline, spacing: .large) {
                KeyValue("Trailing very long key", value: longValue, alignment: .trailing)
                Spacer()
                KeyValue("Centered very long key", value: longValue, alignment: .center)
                Spacer()
                KeyValue("Leading very long key", value: longValue, alignment: .leading)
            }
        }
        .padding(.medium)
    }
}
