import SwiftUI

/// A pair of label and value to display read-only information.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/keyvalue/)
public struct KeyValue: View, PotentiallyEmptyView {

    let key: String
    let value: String
    let size: Size

    public var body: some View {
        if isEmpty == false {
            KeyValueField(key, size: size) {
                Text(value)
                    .textSize(size.valueSize)
                    .fontWeight(.medium)
                    .textIsCopyable()
            }
            .accessibilityElement(children: .ignore)
            .accessibility(label: .init(key))
            .accessibility(value: .init(value))
            .accessibility(addTraits: .isStaticText)
        }
    }
    
    var isEmpty: Bool {
        key.isEmpty && value.isEmpty
    }
}

// MARK: - Inits
extension KeyValue {

    /// Creates Orbit KeyValue component.
    public init(
        _ key: String = "",
        value: String = "",
        size: Size = .normal
    ) {
        self.key = key
        self.value = value
        self.size = size
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

// MARK: - Identifiers
public extension AccessibilityID {

    static let keyValueKey      = Self(rawValue: "orbit.keyvalue.key")
    static let keyValueValue    = Self(rawValue: "orbit.keyvalue.value")
}

// MARK: - Previews
struct KeyValuePreviews: PreviewProvider {

    static let key = "Key"
    static let value = "Value"
    static let longValue = "Some very very very very very long value"

    static var previews: some View {
        PreviewWrapper {
            standalone
            mix
        }
        .padding(.medium)
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            KeyValue(key, value: value)
            KeyValue()          // EmptyView
            KeyValue("")        // EmptyView
            KeyValue(value: "") // EmptyView
        }
        .previewDisplayName()
    }

    static var mix: some View {
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
                KeyValue("Trailing very long key", value: longValue)
                    .multilineTextAlignment(.trailing)
                Spacer()
                KeyValue("Centered very long key", value: longValue)
                    .multilineTextAlignment(.center)
                Spacer()
                KeyValue("Leading very long key", value: longValue)
                    .multilineTextAlignment(.leading)
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        mix
            .padding(.medium)
    }
}
