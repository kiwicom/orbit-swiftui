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
public struct Select<Prefix: View, Suffix: View>: View {

    private let verticalTextPadding: CGFloat = .small // = 44 @ normal text size

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    @Binding private var messageHeight: CGFloat
    
    private let label: String
    private let value: String?
    private let prompt: String
    private let state: InputState
    private let labelStyle: InputLabelStyle
    private let message: Message?
    private let action: () -> Void
    @ViewBuilder private let prefix: Prefix
    @ViewBuilder private let suffix: Suffix

    public var body: some View {
        FieldWrapper(defaultLabel, message: message, messageHeight: $messageHeight) {
            SwiftUI.Button {
                if isHapticsEnabled {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                }
                
                action()
            } label: {
                Text(value ?? prompt)
                    .textColor(valueColor)
                    .accessibility(.selectValue)
                    .padding(.horizontal, .small)
                    .padding(.vertical, verticalTextPadding)
            }
            .buttonStyle(
                InputContentButtonStyle(
                    state: state,
                    label: compactLabel,
                    message: message
                ) {
                    prefix
                        .accessibility(.selectPrefix)
                } suffix: {
                    suffix
                        .accessibility(.selectSuffix)
                }
            )
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: .init(label))
        .accessibility(value: .init(value ?? ""))
        .accessibility(hint: .init(messageDescription.isEmpty ? prompt : messageDescription))
        .accessibility(addTraits: .isButton)
    }

    private var defaultLabel: String {
        switch labelStyle {
            case .default:          return label
            case .compact:          return ""
        }
    }

    private var compactLabel: String {
        switch labelStyle {
            case .default:          return ""
            case .compact:          return label
        }
    }

    private var valueColor: Color {
        if isEnabled {
            return value == nil
                ? state.placeholderColor
                : state.textColor
        } else {
            return .cloudDarkActive
        }
    }

    private var messageDescription: String {
        message?.description ?? ""
    }
}

// MARK: - Inits
public extension Select {
 
    /// Creates Orbit ``Select`` component.
    init(
        _ label: String = "",
        prefix: Icon.Symbol? = nil,
        value: String?,
        prompt: String = "",
        suffix: Icon.Symbol? = .chevronDown,
        state: InputState = .default,
        labelStyle: InputLabelStyle = .default,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        action: @escaping () -> Void
    ) where Prefix == Icon, Suffix == Icon {
        self.init(
            label,
            value: value,
            prompt: prompt,
            state: state,
            labelStyle: labelStyle,
            message: message,
            messageHeight: messageHeight
        ) {
            action()
        } prefix: {
            Icon(prefix)
        } suffix: {
            Icon(suffix)
                .iconColor(.inkDark)
        }
    }


   /// Creates Orbit ``Select`` component with custom prefix or suffix.
   init(
       _ label: String = "",
       value: String?,
       prompt: String = "",
       state: InputState = .default,
       labelStyle: InputLabelStyle = .default,
       message: Message? = nil,
       messageHeight: Binding<CGFloat> = .constant(0),
       action: @escaping () -> Void,
       @ViewBuilder prefix: () -> Prefix,
       @ViewBuilder suffix: () -> Suffix = { Icon(.chevronDown) }
   ) {
       self.label = label
       self.value = value
       self.prompt = prompt
       self.state = state
       self.labelStyle = labelStyle
       self.message = message
       self._messageHeight = messageHeight
       self.action = action
       self.prefix = prefix()
       self.suffix = suffix()
   }
}

// MARK: - Identifiers
public extension AccessibilityID {

    static let selectPrefix     = Self(rawValue: "orbit.select.prefix")
    static let selectSuffix     = Self(rawValue: "orbit.select.suffix")
    static let selectValue      = Self(rawValue: "orbit.select.value")
}

// MARK: - Previews
struct SelectPreviews: PreviewProvider {

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
            Select(InputFieldPreviews.label, prefix: .grid, value: InputFieldPreviews.value) {
                // No action
            }
            Select(InputFieldPreviews.label, prefix: .grid, value: InputFieldPreviews.value, labelStyle: .compact) {
                // No action
            }
            Select(InputFieldPreviews.label, prefix: .grid, value: nil, prompt: "Prompt", labelStyle: .compact) {
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
            Select(value: "Value with a very very very very very long value..") {
                // No action
            } prefix: {
                EmptyView()
            } suffix: {
                EmptyView()
            }

            Select(value: "Value with a very very very very very long value..") {
                // No action
            } prefix: {
                CountryFlag("")
            } suffix: {
                CountryFlag("")
            }

            // FIXME: conditional content EmptyView
            StateWrapper(false) { state in
                Select(value: "Value with a very very very very very long value..") {
                    state.wrappedValue.toggle()
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
            Select("Ideal size", prefix: .grid, value: InputFieldPreviews.value, action: {})
            Select("Ideal size", prefix: .grid, value: InputFieldPreviews.value, suffix: nil, action: {})
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
        .previewDisplayName()
    }

    static var styles: some View {
        VStack(spacing: .medium) {
            Select(prefix: .grid, value: "", prompt: InputFieldPreviews.prompt, action: {})
            Select(prefix: .grid, value: "", prompt: InputFieldPreviews.prompt, message: .help(InputFieldPreviews.helpMessage), action: {})
            Select(prefix: .grid, value: "", prompt: InputFieldPreviews.prompt, message: .error(InputFieldPreviews.errorMessage), action: {})

            Separator()

            Group {
                Select(prefix: .grid, value: InputFieldPreviews.value, prompt: InputFieldPreviews.prompt, action: {})
                Select(prefix: .grid, value: InputFieldPreviews.value, prompt: InputFieldPreviews.prompt, message: .help(InputFieldPreviews.helpMessage), action: {})
                Select(prefix: .grid, value: InputFieldPreviews.value, prompt: InputFieldPreviews.prompt, message: .error(InputFieldPreviews.errorMessage), action: {})
                Select(prefix: .grid, value: InputFieldPreviews.value, prompt: InputFieldPreviews.prompt, labelStyle: .compact, action: {})
                Select("Inline", prefix: .grid, value: InputFieldPreviews.value, prompt: InputFieldPreviews.prompt, labelStyle: .compact, action: {})
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
        Select(label, prefix: prefix, value: value, prompt: prompt, suffix: suffix, message: message, action: {})
    }

    @ViewBuilder static var mix: some View {
        VStack(spacing: .medium) {
            Group {
                Select("No Value", value: "", suffix: .none, action: {})
                Select("No Suffix", value: "Value", suffix: .none, action: {})
                Select("Label", value: "Value", action: {})
                Select("", prefix: .grid, value: "Value", action: {})
                Select("", prefix: .airplane, value: nil, prompt: "Please select", action: {})
                Select("Label (Empty Value)", prefix: .airplane, value: "", action: {})
                Select("Label (No Value)", prefix: .airplane, value: nil, prompt: "Please select", action: {})
                Select("Label", prefix: .phone, value: "Value", action: {})
                Select("Label", prefix: .map, value: "Value", action: {})
            }

            Group {
                Select("Label (Disabled)", prefix: .airplane, value: "Value", action: {})
                    .disabled(true)

                Select(
                    "Label (Disabled)",
                    prefix: .airplane,
                    value: nil,
                    prompt: "Please select",
                    action: {}
                )
                .disabled(true)

                Select("Label (Modified)", prefix: .airplane, value: "Modified Value", state: .modified, action: {})
                Select(
                    "Label (Modified)",
                    prefix: .airplane,
                    value: nil,
                    prompt: "Please select",
                    state: .modified,
                    action: {}
                )
                Select(
                    "Label (Info)",
                    prefix: .informationCircle,
                    value: "Value",
                    message: .help("Help message, also very long and multi-line to test that it works."),
                    action: {}
                )

                Select(
                    FieldLabelPreviews.longLabel,
                    prefix: .grid,
                    value: "Bad Value with a very long text that should overflow",
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
                            prefix: .grid,
                            value: "Bad Value with a very long text that should overflow",
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
