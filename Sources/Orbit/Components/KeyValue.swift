import SwiftUI

struct AccessibilityLabelValueModifier<Label: View, Value: View>: ViewModifier {
    
    @Environment(\.localizationBundle) private var localizationBundle
    @Environment(\.locale) private var locale
    
    @ViewBuilder let label: Label
    @ViewBuilder let value: Value
    
    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: isLabelAndValueTextual ? .ignore : .contain)
            .accessibility(label: textualLabel ?? SwiftUI.Text(""))
            .accessibility(value: textualValue ?? SwiftUI.Text(""))
//            .accessibility(addTraits: isLabelAndValueTextual ? .isStaticText : [])
    }
    
    var isLabelAndValueTextual: Bool {
        textualLabel != nil && textualValue != nil
    }
    
    var textualLabel: SwiftUI.Text? {
        label.text(locale: locale, localizationBundle: localizationBundle)
    }
    
    var textualValue: SwiftUI.Text? {
        value.text(locale: locale, localizationBundle: localizationBundle)
    }
    
}

extension View {
    
    /// Textual representation of view.
    func text(locale: Locale, localizationBundle: Bundle) -> SwiftUI.Text? {
        switch self {
            case let text as SwiftUI.Text:          text
            case let text as TextRepresentable:     text.text(environment: .init(locale: locale, localizationBundle: localizationBundle))
            default:                                nil
        }
    }
    
    func accessibility<Label: View, Value: View>(
        @ViewBuilder label: () -> Label, 
        @ViewBuilder value: () -> Value = { EmptyView() }
    ) -> some View {
        modifier(AccessibilityLabelValueModifier(label: label, value: value))
    }
}


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

    @Environment(\.localizationBundle) var localizationBundle
    @Environment(\.locale) var locale
    @Environment(\.multilineTextAlignment) private var multilineTextAlignment
    
    @ViewBuilder private let key: Key
    @ViewBuilder private let value: Value

    public var body: some View {
        if isEmpty == false {
            VStack(alignment: .init(multilineTextAlignment), spacing: 0) {
                key
                    .textColor(.inkNormal)
                    .accessibility(.keyValueKey)

                value
                    .textFontWeight(.medium)
                    .textSize(.large)
                    .textIsCopyable()
                    .accessibility(.keyValueValue)
            }
            .accessibility {
                key
            } value: {
                value
            }
            .accessibility(addTraits: .isStaticText)
            .accessibility(.keyValue)
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
        _ value: LocalizedStringKey,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        keyComment: StaticString? = nil
    ) {
        self.init {
            Text(value, tableName: tableName, bundle: bundle)
        } key: {
            Text(key, tableName: tableName, bundle: bundle)
        }
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    
    static let keyValue         = Self(rawValue: "orbit.keyvalue")
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
                Text("Key")
                    .textSize(.small)
            }
            KeyValue("Key", value: value)
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
