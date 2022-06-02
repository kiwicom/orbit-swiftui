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
    let passwordStrength: PasswordStrengthIndicator.PasswordStrength
    let message: MessageType
    let onEditingChanged: (Bool) -> Void
    let onCommit: () -> Void
    let suffixAction: (() -> Void)?

    public var body: some View {
        FormFieldWrapper(label, message: message, messageHeight: $messageHeight) {
            InputContent(
                prefix: prefix,
                suffix: suffix,
                state: state,
                message: message,
                isEditing: isEditing,
                suffixAction: suffixAction
            ) {
                HStack(spacing: 0) {
                    input
                        .textFieldStyle(TextFieldStyle(leadingPadding: 0))
                        .autocapitalization(autocapitalization)
                        .disableAutocorrection(isAutocompleteEnabled == false)
                        .textContentType(textContent)
                        .keyboardType(keyboard)
                        .font(.orbit(size: Text.Size.normal.value, weight: .regular))
                        .accentColor(.blueNormal)
                        .background(textFieldPlaceholder, alignment: .leading)
                        .disabled(state == .disabled)
                    if isSecure {
                        securedSuffix
                    } else {
                        clearButton
                    }
                }
            }
        } messageContent: {
            PasswordStrengthIndicator(passwordStrength: passwordStrength)
                .padding(.top, .xxSmall)
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
                keyboardType: keyboard,
                font: .orbit(size: Text.Size.normal.value, weight: .regular),
                state: state
            ),
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
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
        if value.isEmpty == false, state != .disabled {
            Icon(isSecureTextEntry ? .visibility : .visibilityOff)
                .foregroundColor(.inkLight)
                .padding(.vertical, .xSmall)
                .padding(.horizontal, .small)
                .contentShape(Rectangle())
                .onTapGesture {
                    isSecureTextEntry.toggle()
                }
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
    ///     - suffixAction: Optional separate action on suffix icon tap.
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
        passwordStrength: PasswordStrengthIndicator.PasswordStrength = .empty,
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {},
        suffixAction: (() -> Void)? = nil
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
        self.passwordStrength = passwordStrength
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

    static let label = "Field label"
    static let value = "Value"
    static let placeholder = "Placeholder"
    static let helpMessage = "Help message"
    static let errorMessage = "Error message"

    static var previews: some View {
        PreviewWrapper {
            standalone
            storybook
            storybookPassword
            storybookMix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        StateWrapper(initialState: value) { state in
            InputField(label, value: state, prefix: .grid, suffix: .grid, placeholder: placeholder, state: .default)
        }
        .padding(.medium)
    }

    static var storybook: some View {
        VStack(spacing: .medium) {
            inputField(value: "", message: .none)
            inputField(value: "", message: .help(helpMessage))
            inputField(value: "", message: .error(errorMessage))
            Separator()
            inputField(value: value, message: .none)
            inputField(value: value, message: .help(helpMessage))
            inputField(value: value, message: .error(errorMessage))
        }
        .padding(.medium)
    }

    static func inputField(value: String, message: MessageType) -> some View {
        StateWrapper(initialState: value) { state in
            InputField(label, value: state, prefix: .grid, suffix: .grid, placeholder: placeholder, message: message)
        }
    }

    static var storybookPassword: some View {
        VStack(spacing: .medium) {
            InputField("Password", value: .constant("password"), isSecure: true)
            InputField("Password", value: .constant(""), placeholder: "Input password", isSecure: true)
            InputField(
                "Password",
                value: .constant("password"),
                isSecure: true,
                passwordStrength: .strong(title: "Strong")
            )
            InputField(
                "Password",
                value: .constant("password"),
                isSecure: true,
                passwordStrength: .medium(title: "Medium"),
                message: .help("Help message")
            )
            InputField(
                "Password",
                value: .constant("password"),
                isSecure: true,
                passwordStrength: .weak(title: "Weak"),
                message: .error("Error message")
            )
        }
        .padding(.medium)
    }

    static var storybookMix: some View {
        VStack(spacing: .medium) {
            InputField("Empty", value: .constant(""), prefix: .symbol(.grid, color: .blueDark), suffix: .symbol(.grid, color: .blueDark), placeholder: placeholder)
            InputField("Disabled, Empty", value: .constant(""), prefix: .countryFlag("cz"), suffix: .countryFlag("us"), placeholder: placeholder, state: .disabled)
            InputField("Disabled", value: .constant("Disabled Value"), prefix: .sfSymbol("info.circle.fill"), suffix: .sfSymbol("info.circle.fill"), placeholder: placeholder, state: .disabled)
            InputField("Default", value: .constant("InputField Value"))
            InputField("Modified", value: .constant("Modified value"), state: .modified)
            InputField("Focused", value: .constant("Focus / Help"), message: .help("Help message"))
            InputField(
                "InputField with a long multiline label to test that it works",
                value: .constant("Error value with a very long length to test that it works"),
                message: .error("Error message, also very long and multi-line to test that it works.")
            ).padding(.bottom, .small)

            HStack(spacing: .medium) {
                InputField(value: .constant("No label"))
                InputField(value: .constant("Flag prefix"), prefix: .countryFlag("us"))
            }
        }
        .padding(.medium)
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

        StateWrapper(initialState: "") { state in

            VStack(alignment: .leading, spacing: .medium) {
                Heading("Heading", style: .title2)

                InputField(
                    value: state,
                    suffix: .none,
                    textContent: .password,
                    isSecure: true,
                    passwordStrength: validate(password: state.wrappedValue)
                )
            }
            .padding()
            .previewDisplayName("Run Live Preview with Secured Input Field")

        }
    }

    static func validate(password: String) -> PasswordStrengthIndicator.PasswordStrength {
        switch password.count {
            case 0:         return .empty
            case 1...3:     return .weak(title: "Weak")
            case 4...6:     return .medium(title: "Medium")
            default:        return .strong(title: "Strong")
        }
    }
}

struct InputFieldDynamicTypePreviews: PreviewProvider {

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
        StateWrapper(initialState: InputFieldPreviews.value) { state in
            InputField(InputFieldPreviews.label, value: state, prefix: .grid, suffix: .grid, placeholder: InputFieldPreviews.placeholder, state: .default)
        }
        InputField("Secured", value: .constant(""), placeholder: "Input password", isSecure: true)
    }
}
