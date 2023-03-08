import SwiftUI

/// Also known as dropdown. Offers a simple form control to select from many options.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/select/)
/// - Important: Component expands horizontally unless prevented by the `fixedSize` modifier.
public struct Select: View {

    @Environment(\.isEnabled) var isEnabled: Bool

    @Binding var messageHeight: CGFloat
    
    let label: String
    let labelAccentColor: UIColor?
    let labelLinkColor: TextLink.Color
    let labelLinkAction: TextLink.Action
    let prefix: Icon.Content
    let value: String?
    let placeholder: String
    let suffix: Icon.Content
    let state: InputState
    let message: Message?
    let action: () -> Void

    public var body: some View {
        FieldWrapper(
            label,
            labelAccentColor: labelAccentColor,
            labelLinkColor: labelLinkColor,
            labelLinkAction: labelLinkAction,
            message: message,
            messageHeight: $messageHeight
        ) {
            SwiftUI.Button(
                action: {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                    action()
                },
                label: {
                    buttonLabel
                }
            )
            .buttonStyle(
                InputStyle(
                    prefix: prefix,
                    suffix: suffix,
                    prefixAccessibilityID: .selectPrefix,
                    suffixAccessibilityID: .selectSuffix,
                    state: state,
                    message: message
                )
            )
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: .init(label))
        .accessibility(value: .init(value ?? ""))
        .accessibility(hint: .init(messageDescription.isEmpty ? placeholder : messageDescription))
        .accessibility(addTraits: .isButton)
    }

    @ViewBuilder var buttonLabel: some View {
        if inputLabel.isEmpty {
            Color.clear
                .frame(height: Text.Size.normal.lineHeight)
        } else {
            Text(inputLabel, color: .none)
                .foregroundColor(textColor)
                .accessibility(.selectValue)
        }
    }

    var inputLabel: String {
        value ?? placeholder
    }

    var textColor: Color {
        if isEnabled {
            return value == nil
                ? state.placeholderColor
                : state.textColor
        } else {
            return .cloudDarkActive
        }
    }

    var messageDescription: String {
        message?.description ?? ""
    }
}

// MARK: - Inits
public extension Select {
 
    /// Creates Orbit Select component.
    init(
        _ label: String = "",
        labelAccentColor: UIColor? = nil,
        labelLinkColor: TextLink.Color = .primary,
        labelLinkAction: @escaping TextLink.Action = { _, _ in },
        prefix: Icon.Content = .none,
        value: String?,
        placeholder: String = "",
        suffix: Icon.Content = .chevronDown,
        state: InputState = .default,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        action: @escaping () -> Void
    ) {
        self.label = label
        self.labelAccentColor = labelAccentColor
        self.labelLinkColor = labelLinkColor
        self.labelLinkAction = labelLinkAction
        self.prefix = prefix
        self.value = value
        self.placeholder = placeholder
        self.suffix = suffix
        self.state = state
        self.message = message
        self._messageHeight = messageHeight
        self.action = action
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
            intrinsic
            sizing
            styles
            mix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Select(InputFieldPreviews.label, prefix: .grid, value: InputFieldPreviews.value, action: {})
            .padding(.medium)
            .previewDisplayName()
    }

    static var intrinsic: some View {
        Select("Intrinsic", prefix: .grid, value: InputFieldPreviews.value, action: {})
            .fixedSize()
            .padding(.medium)
            .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .small) {
            Group {
                select("", value: "")
                select("", value: "Value", prefix: .none, suffix: .none)
                select("", value: nil, prefix: .none, suffix: .none)
                select("", value: nil, placeholder: "", prefix: .none, suffix: .none)
            }
            .frame(width: 200)
            .measured()
        }
        .previewDisplayName()
    }

    static var styles: some View {
        VStack(spacing: .medium) {
            select(value: "")
            select(value: "", message: .help(InputFieldPreviews.helpMessage))
            select(value: "", message: .error(InputFieldPreviews.errorMessage))
            Separator()
            select(value: InputFieldPreviews.value)
            select(value: InputFieldPreviews.value, message: .help(InputFieldPreviews.helpMessage))
            select(value: InputFieldPreviews.value, message: .error(InputFieldPreviews.errorMessage))
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func select(
        _ label: String = InputFieldPreviews.label,
        value: String?,
        placeholder: String = InputFieldPreviews.placeholder,
        prefix: Icon.Content = .grid,
        suffix: Icon.Content = .chevronDown,
        message: Message? = nil
    ) -> some View {
        Select(label, prefix: prefix, value: value, placeholder: placeholder, suffix: suffix, message: message, action: {})
    }

    @ViewBuilder static var mix: some View {
        VStack(spacing: .medium) {
            Group {
                Select("No Value", value: "", suffix: .none, action: {})
                Select("No Suffix", value: "Value", suffix: .none, action: {})
                Select("Label", value: "Value", action: {})
                Select("", prefix: .grid, value: "Value", action: {})
                Select("", prefix: .airplane, value: nil, placeholder: "Please select", action: {})
                Select("Label (Empty Value)", prefix: .airplane, value: "", action: {})
                Select("Label (No Value)", prefix: .airplane, value: nil, placeholder: "Please select", action: {})
                Select("Label", prefix: .phone, value: "Value", action: {})
                Select("Label", prefix: .countryFlag("us"), value: "Value", action: {})
            }

            Group {
                Select("Label (Disabled)", prefix: .airplane, value: "Value", action: {})
                    .disabled(true)

                Select(
                    "Label (Disabled)",
                    prefix: .airplane,
                    value: nil,
                    placeholder: "Please select",
                    action: {}
                )
                .disabled(true)

                Select("Label (Modified)", prefix: .airplane, value: "Modified Value", state: .modified, action: {})
                Select(
                    "Label (Modified)",
                    prefix: .airplane,
                    value: nil,
                    placeholder: "Please select",
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
                    labelAccentColor: .orangeNormal,
                    labelLinkColor: .status(.critical),
                    prefix: .image(.orbit(.google)),
                    value: "Bad Value with a very long text that should overflow",
                    message: .error("Error message, but also very long and multi-line to test that it works."),
                    action: {}
                )
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
                            prefix: .image(.orbit(.google)),
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
