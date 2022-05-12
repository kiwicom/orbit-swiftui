import SwiftUI

/// Also known as dropdown. Offers a simple form control to select from many options.
///
/// - Related components:
///   - ``Radio``
///   - ``Checkbox``
///   - ``InputField``
///   - ``ListChoice``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/select/)
/// - Important: Component expands horizontally to infinity.
public struct Select: View {

    @Binding private var messageHeight: CGFloat
    
    let label: String
    let prefix: Icon.Content
    let value: String?
    let placeholder: String
    let suffix: Icon.Content
    let state: InputState
    let message: MessageType
    let action: () -> Void

    public var body: some View {
        FormFieldWrapper(label, message: message, messageHeight: $messageHeight) {
            SwiftUI.Button(
                action: {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                    action()
                },
                label: {
                    Text(value ?? placeholder, color: .none)
                        .foregroundColor(textColor)
                }
            )
            .buttonStyle(
                InputStyle(
                    prefix: prefix,
                    suffix: suffix,
                    state: state,
                    value: value,
                    message: message
                )
            )
        }
    }

    var textColor: Color {
        value == nil
            ? state.placeholderColor
            : state.textColor
    }
}

// MARK: - Inits
public extension Select {
 
    /// Creates Orbit Select component.
    init(
        _ label: String,
        prefix: Icon.Content = .none,
        value: String?,
        placeholder: String = "",
        suffix: Icon.Content = .icon(.chevronDown),
        state: InputState = .default,
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        action: @escaping () -> Void = {}
    ) {
        self.label = label
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
            storybook
            storybookMix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Select(InputFieldPreviews.label, prefix: .icon(.grid), value: InputFieldPreviews.value)
            .padding(.medium)
    }

    static var storybook: some View {
        VStack(spacing: .medium) {
            select(value: "", message: .none)
            select(value: "", message: .help(InputFieldPreviews.helpMessage))
            select(value: "", message: .error(InputFieldPreviews.errorMessage))
            Separator()
            select(value: InputFieldPreviews.value, message: .none)
            select(value: InputFieldPreviews.value, message: .help(InputFieldPreviews.helpMessage))
            select(value: InputFieldPreviews.value, message: .error(InputFieldPreviews.errorMessage))
        }
        .padding(.medium)
    }

    static func select(value: String, message: MessageType) -> some View {
        Select(InputFieldPreviews.label, prefix: .icon(.grid), value: value, placeholder: InputFieldPreviews.placeholder, message: message)
    }

    @ViewBuilder static var storybookMix: some View {
        VStack(spacing: .medium) {
            Group {
                Select("Label", value: "Value")
                Select("", prefix: .icon(.grid), value: "Value")
                Select("", prefix: .icon(.airplane), value: nil, placeholder: "Please select")
                Select("Label (Empty Value)", prefix: .icon(.airplane), value: "")
                Select("Label (No Value)", prefix: .icon(.airplane), value: nil, placeholder: "Please select")
                Select("Label", prefix: .icon(.phone), value: "Value")
                Select("Label", prefix: .countryFlag("us"), value: "Value")
            }

            Group {
                Select("Label (Disabled)", prefix: .icon(.airplane), value: "Value", state: .disabled)
                Select(
                    "Label (Disabled)",
                    prefix: .icon(.airplane),
                    value: nil,
                    placeholder: "Please select",
                    state: .disabled
                )
                Select("Label (Modified)", prefix: .icon(.airplane), value: "Modified Value", state: .modified)
                Select(
                    "Label (Modified)",
                    prefix: .icon(.airplane),
                    value: nil,
                    placeholder: "Please select",
                    state: .modified
                )
                Select(
                    "Label (Info)",
                    prefix: .icon(.informationCircle),
                    value: "Value",
                    message: .help("Help message, also very long and multi-line to test that it works.")
                )

                Select(
                    "Label (Error) with a long multiline label to test that it works",
                    prefix: .image(.orbit(.google)),
                    value: "Bad Value with a very long text that should overflow",
                    message: .error("Error message, but also very long and multi-line to test that it works.")
                )
            }
        }
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
                        )
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
