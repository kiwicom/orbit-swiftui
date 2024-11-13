import SwiftUI

/// Orbit component that displays a dropdown control to select from many options. 
/// A counterpart of the native `SwiftUI.Picker` with `default` style.
///
/// A ``Select`` consists of a label, value, icon and a default trailing disclosure.
///
/// ```swift
/// Select("Country", value: "Czechia") {
///     // Tap action
/// }
/// ```
/// 
/// The component can be disabled by ``disabled(_:)`` modifier.
/// 
/// ### Customizing appearance
///
/// The label and icon colors can be modified by ``textColor(_:)`` and ``iconColor(_:)`` modifiers.
/// The icon size can be modified by ``iconSize(custom:)`` modifier.
///
/// ```swift
/// Select("Country", value: "Czechia") {
///     // Tap action
/// }
/// .textColor(.blueLight)
/// .iconColor(.blueNormal)
/// .iconSize(.large)
/// ```
///
/// Before the action is triggered, a haptic feedback is fired via ``HapticsProvider/sendHapticFeedback(_:)``.
///
/// ### Layout
///
/// Component expands horizontally unless prevented by the native `fixedSize()` or ``idealSize()`` modifier.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/select/)
public struct Select<Label: View, Value: View, Prompt: View, Prefix: View, Suffix: View>: View {

    private let verticalTextPadding: CGFloat = .small // = 44 @ normal text size

    @Environment(\.iconColor) private var iconColor
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled
    @Environment(\.textColor) private var textColor

    @Binding private var messageHeight: CGFloat
    
    private let state: InputState
    private let labelStyle: InputLabelStyle
    private let message: Message?
    private let action: () -> Void
    @ViewBuilder private let label: Label
    @ViewBuilder private let value: Value
    @ViewBuilder private let prompt: Prompt
    @ViewBuilder private let prefix: Prefix
    @ViewBuilder private let suffix: Suffix

    public var body: some View {
        FieldWrapper(message: message, messageHeight: $messageHeight) {
            SwiftUI.Button {
                if isHapticsEnabled {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                }
                
                action()
            } label: {
                buttonLabel
                    .textColor(valueColor)
                    .accessibility(.selectValue)
                    .padding(.horizontal, .small)
                    .padding(.vertical, verticalTextPadding)
            }
            .buttonStyle(
                InputContentButtonStyle(state: state, message: message) {
                    compactLabel
                } prefix: {
                    prefix
                        .textColor(prefixIconColor)
                        .accessibility(.selectPrefix)
                } suffix: {
                    suffix
                        .accessibility(.selectSuffix)
                }
            )   
        } label: {
            defaultLabel
        }
        .accessibility {
            label
        } value: {
            value
        } hint: {
            SwiftUI.Text(messageDescription)
        }
        .accessibility(addTraits: .isButton)
        .accessibility(.select)
    }
    
    @ViewBuilder private var buttonLabel: some View {
        if value.isEmpty {
            prompt  
        } else {
            value
        }
    }

    @ViewBuilder private var defaultLabel: some View {
        switch labelStyle {
            case .default:          label
            case .compact:          EmptyView()
        }
    }

    @ViewBuilder private var compactLabel: some View {
        switch labelStyle {
            case .default:          EmptyView()
            case .compact:          label
        }
    }

    private var valueColor: Color {
        if isEnabled {
            return value.isEmpty
                ? state.placeholderColor
                : state.textColor
        } else {
            return .cloudDarkActive
        }
    }
    
    private var prefixIconColor: Color? {
        isEnabled
            ? iconColor ?? textColor ?? (labelStyle == .default ? .inkDark : .inkNormal)
            : .cloudDarkActive
    }

    private var messageDescription: String {
        message?.description ?? ""
    }
    
    /// Creates Orbit ``Select`` component with custom content.
    public init(
        state: InputState = .default,
        labelStyle: InputLabelStyle = .default,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label = { EmptyView() },
        @ViewBuilder value: () -> Value = { EmptyView() },
        @ViewBuilder prompt: () -> Prompt = { EmptyView() },
        @ViewBuilder prefix: () -> Prefix = { EmptyView() },
        @ViewBuilder suffix: () -> Suffix = { Icon(.chevronDown) }
    ) {
        self.state = state
        self.labelStyle = labelStyle
        self.message = message
        self._messageHeight = messageHeight
        self.action = action
        self.label = label()
        self.value = value()
        self.prompt = prompt()
        self.prefix = prefix()
        self.suffix = suffix()
    }
}

// MARK: - Convenience Inits
public extension Select where Prefix == Icon, Suffix == Icon, Label == Text, Value == SelectValue, Prompt == Text {
    
    /// Creates Orbit ``Select`` component with custom content.
    @_disfavoredOverload
    init(
        _ label: some StringProtocol = String(""),
        value: String?,
        prompt: some StringProtocol = String(""),
        prefix: Icon.Symbol? = nil,
        suffix: Icon.Symbol? = .chevronDown,
        state: InputState = .default,
        labelStyle: InputLabelStyle = .default,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        action: @escaping () -> Void
    ) {
        self.init(
            state: state,
            labelStyle: labelStyle,
            message: message,
            messageHeight: messageHeight
        ) {
            action()
        } label: {
            Text(label)
        } value: {
            SelectValue(value: value)
        } prompt: {
            Text(prompt)
        } prefix: {
            Icon(prefix)
        } suffix: {
            Icon(suffix)
                .iconColor(.inkDark)
        }
    }
    
    /// Creates Orbit ``Select`` component with localizable label.
    @_semantics("swiftui.init_with_localization")
    init(
        _ label: LocalizedStringKey = "",
        value: String?,
        prompt: LocalizedStringKey = "",
        prefix: Icon.Symbol? = nil,
        suffix: Icon.Symbol? = .chevronDown,
        state: InputState = .default,
        labelStyle: InputLabelStyle = .default,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        tableName: String? = nil,
        bundle: Bundle? = nil,
        labelComment: StaticString? = nil,
        action: @escaping () -> Void
    ) {
        self.init(
            state: state,
            labelStyle: labelStyle,
            message: message,
            messageHeight: messageHeight
        ) {
            action()
        } label: {
            Text(label, tableName: tableName, bundle: bundle)
        } value: {
            SelectValue(value: value)
        } prompt: {
            Text(prompt, tableName: tableName, bundle: bundle)
        } prefix: {
            Icon(prefix)
        } suffix: {
            Icon(suffix)
                .iconColor(.inkDark)
        }
    }
}

// MARK: - Types

public struct SelectValue: View, PotentiallyEmptyView {
    
    let value: String?

    public var body: some View {
        if let value {
            Text(value)
        }
    }
    
    public var isEmpty: Bool {
        value == nil
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let select           = Self(rawValue: "orbit.select")
    static let selectPrefix     = Self(rawValue: "orbit.select.prefix")
    static let selectSuffix     = Self(rawValue: "orbit.select.suffix")
    static let selectValue      = Self(rawValue: "orbit.select.value")
}

// MARK: - Previews
struct SelectPreviews: PreviewProvider {

    static let longValue = "Value with a very very very very very long value.."
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            customContent
            idealSize
            sizing
            styles
            mix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: .medium) {
            Select(InputFieldPreviews.label, value: InputFieldPreviews.value) {
                // No action
            }
            Select(InputFieldPreviews.label, value: InputFieldPreviews.value, prefix: .grid) {
                // No action
            }
            Select(InputFieldPreviews.label, value: InputFieldPreviews.value, prefix: .grid, labelStyle: .compact) {
                // No action
            }
            Select(InputFieldPreviews.label, value: nil, prompt: "Prompt", prefix: .grid, labelStyle: .compact) {
                // No action
            }
            Select(InputFieldPreviews.label, value: nil, prompt: "Prompt", labelStyle: .compact) {
                // No action
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var customContent: some View {
        VStack(spacing: .medium) {
            Select {
                // No action
            } value: {
                Text(longValue)
            } prefix: {
                EmptyView()
            } suffix: {
                EmptyView()
            }

            Select {
                // No action
            } value: {
                Text(longValue)
            } prefix: {
                CountryFlag("")
            } suffix: {
                CountryFlag("")
            }

            // FIXME: conditional content EmptyView padding
            StateWrapper(false) { state in
                Select {
                    state.wrappedValue.toggle()
                } value: {
                    Text(longValue)
                } prefix: {
                    if state.wrappedValue {
                        CountryFlag("us")
                    }
                } suffix: {
                    if state.wrappedValue {
                        CountryFlag("us")
                    }
                }
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var idealSize: some View {
        VStack(spacing: .medium) {
            Select("Ideal size", value: InputFieldPreviews.value, prefix: .grid, action: {})
            Select("Ideal size", value: InputFieldPreviews.value, prefix: .grid, suffix: nil, action: {})
            Select("Ideal size", value: InputFieldPreviews.value, suffix: nil, action: {})
        }
        .idealSize()
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .small) {
            Group {
                select("", value: "")
                select("", value: "Value with a very long value")
                select("", value: "Value", prefix: .none, suffix: .none)
                select("", value: nil, prefix: .none, suffix: .none)
                select("", value: nil, prompt: "", prefix: .none, suffix: .none)
            }
            .frame(width: 200)
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var styles: some View {
        VStack(spacing: .medium) {
            Select(value: "", prompt: InputFieldPreviews.prompt, prefix: .grid, action: {})
            Select(value: "", prompt: InputFieldPreviews.prompt, prefix: .grid, message: .help(InputFieldPreviews.helpMessage), action: {})
            Select(value: "", prompt: InputFieldPreviews.prompt, prefix: .grid, message: .error(InputFieldPreviews.errorMessage), action: {})

            Separator()

            Group {
                Select(value: InputFieldPreviews.value, prompt: InputFieldPreviews.prompt, prefix: .grid, action: {})
                Select(value: InputFieldPreviews.value, prompt: InputFieldPreviews.prompt, prefix: .grid, message: .help(InputFieldPreviews.helpMessage), action: {})
                Select(value: InputFieldPreviews.value, prompt: InputFieldPreviews.prompt, prefix: .grid, message: .error(InputFieldPreviews.errorMessage), action: {})
                Select(value: InputFieldPreviews.value, prompt: InputFieldPreviews.prompt, prefix: .grid, action: {})
                Select("Inline", value: InputFieldPreviews.value, prompt: InputFieldPreviews.prompt, prefix: .grid, labelStyle: .compact, action: {})
                Select("Inline", value: InputFieldPreviews.value, prompt: InputFieldPreviews.prompt, labelStyle: .compact, action: {})
                Select("Inline", value: nil, prompt: InputFieldPreviews.prompt, labelStyle: .compact, action: {})
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func select(
        _ label: String = InputFieldPreviews.label,
        value: String?,
        prompt: String = InputFieldPreviews.prompt,
        prefix: Icon.Symbol? = .grid,
        suffix: Icon.Symbol? = .chevronDown,
        message: Message? = nil
    ) -> some View {
        Select(label, value: value, prompt: prompt, prefix: prefix, suffix: suffix, message: message, action: {})
    }

    @ViewBuilder static var mix: some View {
        VStack(spacing: .medium) {
            Group {
                Select("No Value", value: "", suffix: .none, action: {})
                Select("No Suffix", value: "Value", suffix: .none, action: {})
                Select("Label", value: "Value", action: {})
                Select("", value: "Value", prefix: .grid, action: {})
                Select("", value: nil, prompt: "Please select", prefix: .airplane, action: {})
                Select("Label (Empty Value)", value: "", prefix: .airplane, action: {})
                Select("Label (No Value)", value: nil, prompt: "Please select", prefix: .airplane, action: {})
                Select("Label", value: "Value", prefix: .phone, action: {})
                Select("Label", value: "Value", prefix: .map, action: {})
            }

            Group {
                Select("Label (Disabled)", value: "Value", prefix: .airplane, action: {})
                    .disabled(true)

                Select(
                    "Label (Disabled)",
                    value: nil,
                    prompt: "Please select",
                    prefix: .airplane,
                    action: {}
                )
                .disabled(true)

                Select("Label (Modified)", value: "Modified Value", prefix: .airplane, state: .modified, action: {})
                Select(
                    "Label (Modified)",
                    value: nil,
                    prompt: "Please select",
                    prefix: .airplane,
                    state: .modified,
                    action: {}
                )
                Select(
                    "Label (Info)",
                    value: "Value",
                    prefix: .informationCircle,
                    message: .help("Help message, also very long and multi-line to test that it works."),
                    action: {}
                )

                Select(
                    "Multiline\nLabel",
                    value: "Bad Value with a very long text that should overflow",
                    prefix: .grid,
                    message: .error("Error message, but also very long and multi-line to test that it works."),
                    action: {}
                )
                .textLinkColor(.status(.critical))
                .textAccentColor(.orangeNormal)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var live: some View {
        StateWrapper(false) { state in
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: .xxSmall) {
                        Heading("Some content", style: .title3)
                        Text("Very long and multi-line follow-up text to test that it still all works correctly.")

                        Select(
                            "Label (Error) with a long multiline label to test that it works",
                            value: "Bad Value with a very long text that should overflow",
                            prefix: .grid,
                            message: state.wrappedValue
                                ? .error("Error message, but also very long and multi-line to test that it works.")
                                : .none
                        ) {
                            state.wrappedValue.toggle()
                        }
                        .padding(.vertical, .medium)

                        Heading("Some content", style: .title3)
                        Text("Very long and multi-line follow-up text to test that it still all works correctly.")
                    }
                }
                .overlay(
                    Button("Toggle error") {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            state.wrappedValue.toggle()
                        }
                    },
                    alignment: .bottom
                )
                .padding()
                .navigationBarTitle("Live Preview")
            }
            .navigationViewStyle(.stack)
        }
        .previewDisplayName()
    }
}
