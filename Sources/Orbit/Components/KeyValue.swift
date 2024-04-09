import SwiftUI

/// Orbit component that displays a pair of label and a value.
///
/// A ``KeyValue`` consists of a label and a value that is copyable by default.
///
/// ```swift
/// KeyValue("First Name", value: "Pavel")
/// ```
///
/// ### Layout
///
/// The text alignment can be modified by ``multilineTextAlignment(_:)``.
///
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/keyvalue/)
public struct KeyValue<Key: View, Value: View>: View, PotentiallyEmptyView {

    @Environment(\.multilineTextAlignment) private var multilineTextAlignment
    
    @ViewBuilder private let key: Key
    @ViewBuilder private let value: Value

    public var body: some View {
        if isEmpty == false {
            VStack(alignment: .init(multilineTextAlignment), spacing: 0) {
                key
                    .textColor(.inkNormal)

                value
                    .textFontWeight(.medium)
                    .textIsCopyable()
            }
            .accessibility {
                key
            } value: {
                value
            }
            .accessibility(addTraits: .isStaticText)
            .accessibility(.keyValue)
            .textSize(.large)
        }
    }
    
    var isEmpty: Bool {
        key.isEmpty && value.isEmpty
    }
    
    /// Creates Orbit ``KeyValue`` component with custom content.
    public init(
        @ViewBuilder value: () -> Value,
        @ViewBuilder key: () -> Key
    ) {
        self.value = value()
        self.key = key()
    }
}

// MARK: - Convenience Inits
public extension KeyValue where Key == Text, Value == Text {

    /// Creates Orbit ``KeyValue`` component.
    @_disfavoredOverload
    init(
        _ key: some StringProtocol = String(""),
        value: some StringProtocol = String("")
    ) {
        self.init {
            Text(value)
        } key: {
            Text(key)
        }
    }
    
    /// Creates Orbit ``KeyValue`` component with localizable content.
    @_semantics("swiftui.init_with_localization")
    init(
        _ key: LocalizedStringKey,
        value: some StringProtocol = String(""),
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil
    ) {
        self.init {
            Text(value)
        } key: {
            Text(key, tableName: tableName, bundle: bundle)
        }
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let keyValue         = Self(rawValue: "orbit.keyvalue")
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
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack { 
            KeyValue(key, value: value)
            
            // EmptyView
            Group {
                KeyValue()
                KeyValue("")
                KeyValue(value: "")
                KeyValue {
                    Text("")
                } key: {
                    Text("")
                }
            }
            .border(.redNormal)
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .large) {
            KeyValue {
                Text(value)
                    .textSize(.normal)
            } key : {
                Text(key)
                    .textSize(.small)
            }
            KeyValue(key, value: value)
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
