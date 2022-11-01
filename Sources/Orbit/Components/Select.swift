import SwiftUI

/// Also known as dropdown. Offers a simple form control to select from many options.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/select/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct Select: View {

    @Binding private var messageHeight: CGFloat
    
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
                    Text(value ?? placeholder, color: .none)
                        .foregroundColor(textColor)
                        .accessibility(.inputValue)
                }
            )
            .buttonStyle(
                InputStyle(
                    prefix: prefix,
                    suffix: suffix,
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
        .disabled(state == .disabled)
    }

    var textColor: Color {
        value == nil
            ? state.placeholderColor
            : state.textColor
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
        action: @escaping () -> Void = {}
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

// MARK: - Previews
struct SelectPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            intrinsic
            storybook
            storybookMix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Select(InputFieldPreviews.label, prefix: .grid, value: InputFieldPreviews.value)
    }

    static var intrinsic: some View {
        Select("Intrinsic", prefix: .grid, value: InputFieldPreviews.value)
            .idealSize()
    }

    static var storybook: some View {
        VStack(spacing: .medium) {
            select(value: "")
            select(value: "", message: .help(InputFieldPreviews.helpMessage))
            select(value: "", message: .error(InputFieldPreviews.errorMessage))
            Separator()
            select(value: InputFieldPreviews.value)
            select(value: InputFieldPreviews.value, message: .help(InputFieldPreviews.helpMessage))
            select(value: InputFieldPreviews.value, message: .error(InputFieldPreviews.errorMessage))
        }
    }

    static func select(value: String, message: Message? = nil) -> some View {
        Select(InputFieldPreviews.label, prefix: .grid, value: value, placeholder: InputFieldPreviews.placeholder, message: message)
    }

    @ViewBuilder static var storybookMix: some View {
        VStack(spacing: .medium) {
            Group {
                Select("Label", value: "Value")
                Select("", prefix: .grid, value: "Value")
                Select("", prefix: .airplane, value: nil, placeholder: "Please select")
                Select("Label (Empty Value)", prefix: .airplane, value: "")
                Select("Label (No Value)", prefix: .airplane, value: nil, placeholder: "Please select")
                Select("Label", prefix: .phone, value: "Value")
                Select("Label", prefix: .countryFlag("us"), value: "Value")
            }

            Group {
                Select("Label (Disabled)", prefix: .airplane, value: "Value", state: .disabled)
                Select(
                    "Label (Disabled)",
                    prefix: .airplane,
                    value: nil,
                    placeholder: "Please select",
                    state: .disabled
                )
                Select("Label (Modified)", prefix: .airplane, value: "Modified Value", state: .modified)
                Select(
                    "Label (Modified)",
                    prefix: .airplane,
                    value: nil,
                    placeholder: "Please select",
                    state: .modified
                )
                Select(
                    "Label (Info)",
                    prefix: .informationCircle,
                    value: "Value",
                    message: .help("Help message, also very long and multi-line to test that it works.")
                )

                Select(
                    FieldLabelPreviews.longLabel,
                    labelAccentColor: .orangeNormal,
                    labelLinkColor: .status(.critical),
                    prefix: .image(.orbit(.google)),
                    value: "Bad Value with a very long text that should overflow",
                    message: .error("Error message, but also very long and multi-line to test that it works.")
                )
            }
        }
    }

    static var snapshot: some View {
        storybook
            .padding(.medium)
    }
}

struct SelectLivePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            live
        }
    }

    static var live: some View {
        StateWrapper(initialState: false) { state in
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
            .previewDisplayName("Live Preview")
        }
    }
}

struct SelectDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")
            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        SelectPreviews.standalone
    }
}
