import SwiftUI

/// Also known as dropdown. Offers a simple form control to select from many options.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/select/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct Select<Prefix: View, Suffix: View>: View {

    let verticalTextPadding: CGFloat = .small // = 44 @ normal text size

    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    @Binding private var messageHeight: CGFloat
    
    private let label: String
    private let value: String?
    private let prompt: String
    private let state: InputState
    private let message: Message?
    private let action: () -> Void
    @ViewBuilder private let prefix: Prefix
    @ViewBuilder private let suffix: Suffix

    public var body: some View {
        FieldWrapper(
            label,
            message: message,
            messageHeight: $messageHeight
        ) {
            SwiftUI.Button(
                action: {
                    if isHapticsEnabled {
                        HapticsProvider.sendHapticFeedback(.light(0.5))
                    }
                    
                    action()
                },
                label: {
                    HStack(spacing: 0) {
                        buttonLabel
                            .padding(.leading, leadingPadding)
                            .padding(.trailing, trailingPadding)
                            .padding(.vertical, verticalTextPadding)

                        TextStrut()
                    }
                }
            )
            .buttonStyle(
                InputContentButtonStyle(state: state, message: message) {
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

    @ViewBuilder var buttonLabel: some View {
        Text(inputLabel)
            .textColor(textColor)
            .accessibility(.selectValue)
    }

    var inputLabel: String {
        value ?? prompt
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

    var leadingPadding: CGFloat {
        prefix.isEmpty ? .small : 0
    }

    var trailingPadding: CGFloat {
        suffix.isEmpty ? .small : 0
    }
}

// MARK: - Inits
public extension Select {
 
    /// Creates Orbit Select component.
    init(
        _ label: String = "",
        prefix: Icon.Symbol? = nil,
        value: String?,
        prompt: String = "",
        suffix: Icon.Symbol? = .chevronDown,
        state: InputState = .default,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        action: @escaping () -> Void
    ) where Prefix == Icon, Suffix == Icon {
        self.init(
            label,
            value: value,
            prompt: prompt,
            state: state,
            message: message,
            messageHeight: messageHeight
        ) {
            action()
        } prefix: {
            Icon(prefix)
        } suffix: {
            Icon(suffix)
        }
    }


   /// Creates Orbit Select component with custom prefix or suffix.
   init(
       _ label: String = "",
       value: String?,
       prompt: String = "",
       state: InputState = .default,
       message: Message? = nil,
       messageHeight: Binding<CGFloat> = .constant(0),
       action: @escaping () -> Void,
       @ViewBuilder prefix: () -> Prefix,
       @ViewBuilder suffix: () -> Suffix = { EmptyView() }
   ) {
       self.label = label
       self.value = value
       self.prompt = prompt
       self.state = state
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
            idealSize
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
