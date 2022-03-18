import SwiftUI
import UIKit

/// Also known as textbox. Offers users a simple input for a form.
///
/// When you have additional information or helpful examples, include placeholder text to help users along.
///
/// - Related components:
///   - ``InputGroup``
///   - ``TextArea``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/inputfield/)
/// - Important: Component expands horizontally to infinity.
public struct InputField: View {

    @Binding private var value: String
    @Binding private var messageHeight: CGFloat
    @State private var isEditing: Bool = false
    @State private var isSecureTextEntry: Bool = true

    let label: String
    let placeholder: String
    let prefix: Icon.Content
    let suffix: Icon.Content
    let state: InputState
    let textContent: UITextContentType?
    let keyboard: UIKeyboardType
    let autocapitalization: UITextAutocapitalizationType
    let isAutocompleteEnabled: Bool
    let isSecure: Bool
    let message: MessageType
    let onEditingChanged: (Bool) -> Void
    let onCommit: () -> Void
    let suffixAction: () -> Void

    public var body: some View {
        VStack(alignment: .leading, spacing: .xxSmall) {
            FormFieldLabel(label)

            InputContent(
                prefix: prefix,
                suffix: suffix,
                state: state,
                message: message,
                isEditing: isEditing,
                suffixAction: suffixAction,
                label: {
                    HStack(spacing: 0) {
                        input
                            .textFieldStyle(TextFieldStyle(leadingPadding: 0))
                            .autocapitalization(autocapitalization)
                            .disableAutocorrection(isAutocompleteEnabled == false)
                            .textContentType(textContent)
                            .keyboardType(keyboard)
                            .font(.orbit(size: Text.Size.normal.value, weight: .regular))
                            .accentColor(.blueNormal)
                            .frame(height: Layout.preferredButtonHeight)
                            .background(textFieldPlaceholder, alignment: .leading)
                            .disabled(state == .disabled)
                        if isSecure {
                            securedSuffix
                        } else {
                            Spacer(minLength: 0)
                            clearButton
                        }
                    }
                }
            }
            
            if message.isEmpty == false {
                ContentHeightReader(height: $messageHeight.animation(.easeOut(duration: 0.2))) {
                    FormFieldMessage(message)
                }
            }
        }
    }

    @ViewBuilder var input: some View {
        if isSecure {
            secureField
        } else {
            textField
        }
    }

    @ViewBuilder var secureField: some View {
        SecureTextField(
            text: $value,
            isSecured: $isSecureTextEntry,
            isEditing: $isEditing,
            style: .init(
                textContentType: textContent,
                autocapitalization: autocapitalization,
                keyboardType: keyboard,
                font: .orbit(size: Text.Size.normal.value, weight: .regular)
            )
        )
        .onTapGesture {
            self.isEditing = true
            onEditingChanged(isEditing)
        }
        .background(textFieldPlaceholder, alignment: .leading)
    }

    @ViewBuilder var textField: some View {
        TextField(
            "",
            text: $value,
            onEditingChanged: { isEditing in
                self.isEditing = isEditing
                onEditingChanged(isEditing)
            },
            onCommit: onCommit
        )
    }

    @ViewBuilder var textFieldPlaceholder: some View {
        if value.isEmpty {
            Text(placeholder, color: .none)
                .foregroundColor(state.placeholderColor)
        }
    }
    
    @ViewBuilder var clearButton: some View {
        if value.isEmpty == false, state != .disabled {
            Icon(sfSymbol: "multiply.circle.fill")
                .foregroundColor(.inkLighter)
                .padding(.small)
                .contentShape(Rectangle())
                .onTapGesture {
                    value = ""
                }
        }
    }

    @ViewBuilder var securedSuffix: some View {
        Icon(isSecureTextEntry ? .visibility : .visibilityOff, size: .default)
            .padding(.horizontal, .xSmall)
            .contentShape(Rectangle())
            .onTapGesture {
                isSecureTextEntry.toggle()
            }
    }
}


// MARK: - Inits
public extension InputField {

    /// Creates Orbit InputField component.
    ///
    /// - Parameters:
    ///     - message: Message below InputField.
    ///     - messageHeight: Binding to the current height of message.
    init(
        _ label: String = "",
        value: Binding<String>,
        prefix: Icon.Content = .none,
        suffix: Icon.Content = .none,
        placeholder: String = "",
        state: InputState = .default,
        textContent: UITextContentType? = nil,
        keyboard: UIKeyboardType = .default,
        autocapitalization: UITextAutocapitalizationType = .none,
        isAutocompleteEnabled: Bool = false,
        isSecure: Bool = false,
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {},
        suffixAction: @escaping () -> Void = {}
    ) {
        self.label = label
        self._value = value
        self.prefix = prefix
        self.suffix = suffix
        self.placeholder = placeholder
        self.state = state
        self.message = message
        self._messageHeight = messageHeight
        self.textContent = textContent
        self.keyboard = keyboard
        self.autocapitalization = autocapitalization
        self.isAutocompleteEnabled = isAutocompleteEnabled
        self.isSecure = isSecure
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        self.suffixAction = suffixAction
    }
}

// MARK: - Types
public extension InputField {
    
    struct TextFieldStyle : SwiftUI.TextFieldStyle {
        
        let leadingPadding: CGFloat
        
        public init(leadingPadding: CGFloat = .xSmall) {
            self.leadingPadding = leadingPadding
        }
        
        public func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding(.leading, leadingPadding)
                .padding(.vertical, .xSmall)
        }
    }
}

// MARK: - Previews
struct InputFieldPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshots
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var standalone: some View {
        PreviewWrapperWithState(initialState: "Value") { state in
            InputField("Label", value: state, prefix: .icon(.grid), suffix: .icon(.grid), placeholder: "Placeholder", state: .default)
        }
    }

    @ViewBuilder static var orbit: some View {
        InputField("Empty", value: .constant(""), placeholder: "Placeholder")
        InputField("Disabled, Empty", value: .constant(""), placeholder: "Placeholder", state: .disabled)
        InputField("Disabled", value: .constant("Disabled Value"), placeholder: "Placeholder", state: .disabled)
        InputField("Default", value: .constant("InputField Value"))
        InputField("Secured", value: .constant("password"), isSecure: true)
        InputField("Modified", value: .constant("Modified value"), state: .modified)
        InputField("Focused", value: .constant("Focus / Help"), message: .help("Help message"))
        InputField(
            "InputField with a long multiline label to test that it works",
            value: .constant("Error value with a very long length to test that it works"),
            message: .error("Error message, also very long and multi-line to test that it works.")
        )
        InputField(value: .constant("InputField with no label"))
        standalone
        InputField(value: .constant("InputField with CountryFlag prefix"), prefix: .countryFlag("us"))
    }

    static var snapshots: some View {
        VStack(spacing: Spacing.medium) {
            orbit
        }
        .padding()
        .previewDisplayName("Orbit")
    }
}

struct InputFieldLivePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper()
        securedWrapper
    }
    
    struct PreviewWrapper: View {

        @State var message: MessageType = .none
        @State var value = ""

        init() {
            Font.registerOrbitFonts()
        }

        var body: some View {
            VStack(alignment: .leading, spacing: .medium) {
                Heading("Heading", style: .title2)

                Text("Some text, but also very long and multi-line to test that it works.")

                InputField(
                    "InputField",
                    value: $value,
                    placeholder: "Placeholder",
                    message: message
                )

                Text("Some text, but also very long and multi-line to test that it works.")

                Spacer()

                Button("Change") {
                    switch message {
                        case .none:
                            message = .normal("Secondary label")
                        case .normal:
                            message = .help(
                                "Help message, but also very long and multi-line to test that it works."
                            )
                        case .help:
                            message = .warning("Warning text")
                        case .warning:
                            message = .error(
                                "Error message, also very long and multi-line to test that it works."
                            )
                        case .error:
                            message = .none
                    }
                }
            }
            .animation(.easeOut(duration: 0.25), value: message)
            .padding()
            .previewDisplayName("Run Live Preview with Input Field")
        }
    }

    static var securedWrapper: some View {

        PreviewWrapperWithState(initialState: "") { state in

            VStack(alignment: .leading, spacing: .medium) {
                Heading("Heading", style: .title2)

                InputField(
                    value: state,
                    suffix: .none,
                    textContent: .password,
                    isSecure: true
                )
            }
            .padding()
            .previewDisplayName("Run Live Preview with Secured Input Field")

        }
    }

}
