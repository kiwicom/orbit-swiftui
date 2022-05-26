import SwiftUI
import UIKit

class InputInnerState: ObservableObject {
    @Published var isEditing: Bool
    @Published var isSecureTextEntry: Bool

    init(isEditing: Bool, isSecureTextEntry: Bool = false) {
        self.isEditing = isEditing
        self.isSecureTextEntry = isSecureTextEntry
    }
}

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
public struct InputField<Input>: View where Input: View {

    @ObservedObject var innerState: InputInnerState
    @Binding private var value: String
    @Binding private var messageHeight: CGFloat

    let label: String
    let placeholder: String
    let prefix: Icon.Content
    let suffix: Icon.Content
    let state: InputState
    let textContent: UITextContentType?
    let keyboard: UIKeyboardType
    let autocapitalization: UITextAutocapitalizationType
    let isAutocompleteEnabled: Bool
    let passwordStrength: PasswordStrengthIndicator.PasswordStrength
    let message: MessageType
    let suffixAction: (() -> Void)?
    let isSecure: Bool

    let inputBuilder: () -> Input

    public var body: some View {
        FormFieldWrapper(label, message: message, messageHeight: $messageHeight) {
            VStack(alignment: .leading, spacing: .xxSmall) {
                InputContent(
                    prefix: prefix,
                    suffix: suffix,
                    state: state,
                    message: message,
                    isEditing: innerState.isEditing,
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

                PasswordStrengthIndicator(passwordStrength: passwordStrength)
                    .padding(.top, .xxSmall)
            }
        }
    }

    @ViewBuilder var input: some View {
        inputBuilder()
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
            Icon(innerState.isSecureTextEntry ? .visibility : .visibilityOff, size: .normal, color: .inkLight)
                .padding(.vertical, .xSmall)
                .padding(.horizontal, .small)
                .contentShape(Rectangle())
                .onTapGesture {
                    innerState.isSecureTextEntry.toggle()
                }
        }
    }
}


// MARK: - Inits
public extension InputField where Input == TextField<SwiftUI.Text> {

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
        passwordStrength: PasswordStrengthIndicator.PasswordStrength = .empty,
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {},
        suffixAction: (() -> Void)? = nil
    ) {
        let innerState = InputInnerState(isEditing: false)

        self.init(
            innerState: innerState,
            value: value,
            messageHeight: messageHeight,
            label: label,
            placeholder: placeholder,
            prefix: prefix,
            suffix: suffix,
            state: state,
            textContent: textContent,
            keyboard: keyboard,
            autocapitalization: autocapitalization,
            isAutocompleteEnabled: isAutocompleteEnabled,
            passwordStrength: passwordStrength,
            message: message,
            suffixAction: suffixAction,
            isSecure: false,
            inputBuilder: {
                TextField(
                    "",
                    text: value,
                    onEditingChanged: { value in
                        innerState.isEditing = value
                        onEditingChanged(value)
                    },
                    onCommit: onCommit
                )
            }
        )
    }

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
        passwordStrength: PasswordStrengthIndicator.PasswordStrength = .empty,
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        formatter: Formatter,
        suffixAction: (() -> Void)? = nil
    ) {
        let innerState = InputInnerState(isEditing: false)

        self.init(
            innerState: innerState,
            value: value,
            messageHeight: messageHeight,
            label: label,
            placeholder: placeholder,
            prefix: prefix,
            suffix: suffix,
            state: state,
            textContent: textContent,
            keyboard: keyboard,
            autocapitalization: autocapitalization,
            isAutocompleteEnabled: isAutocompleteEnabled,
            passwordStrength: passwordStrength,
            message: message,
            suffixAction: suffixAction,
            isSecure: false,
            inputBuilder: {
                TextField("", value: value, formatter: formatter)
            }
        )
    }

    @available(iOS 15, *)
    init<Format: FormatStyle & ParseableFormatStyle>(
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
        passwordStrength: PasswordStrengthIndicator.PasswordStrength = .empty,
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        formatStyle: Format,
        suffixAction: (() -> Void)? = nil
    ) where Format.FormatInput == String, Format.FormatOutput == String {

        let innerState = InputInnerState(isEditing: false)

        self.init(
            innerState: innerState,
            value: value,
            messageHeight: messageHeight,
            label: label,
            placeholder: placeholder,
            prefix: prefix,
            suffix: suffix,
            state: state,
            textContent: textContent,
            keyboard: keyboard,
            autocapitalization: autocapitalization,
            isAutocompleteEnabled: isAutocompleteEnabled,
            passwordStrength: passwordStrength,
            message: message,
            suffixAction: suffixAction,
            isSecure: false,
            inputBuilder: {
                TextField("", value: value, format: formatStyle)
            }
        )
    }
}

public extension InputField where Input == SecureTextField {

    /// Creates Orbit InputField component.
    ///
    /// - Parameters:
    ///     - message: Message below InputField.
    ///     - messageHeight: Binding to the current height of message.
    ///     - suffixAction: Optional separate action on suffix icon tap.
    init(
        _ label: String = "",
        securedValue value: Binding<String>,
        prefix: Icon.Content = .none,
        suffix: Icon.Content = .none,
        placeholder: String = "",
        state: InputState = .default,
        textContent: UITextContentType? = nil,
        keyboard: UIKeyboardType = .default,
        autocapitalization: UITextAutocapitalizationType = .none,
        isAutocompleteEnabled: Bool = false,
        passwordStrength: PasswordStrengthIndicator.PasswordStrength = .empty,
        message: MessageType = .none,
        messageHeight: Binding<CGFloat> = .constant(0),
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {},
        suffixAction: (() -> Void)? = nil
    ) {
        let innerState = InputInnerState(isEditing: false, isSecureTextEntry: true)

        self.init(
            innerState: innerState,
            value: value,
            messageHeight: messageHeight,
            label: label,
            placeholder: placeholder,
            prefix: prefix,
            suffix: suffix,
            state: state,
            textContent: textContent,
            keyboard: keyboard,
            autocapitalization: autocapitalization,
            isAutocompleteEnabled: isAutocompleteEnabled,
            passwordStrength: passwordStrength,
            message: message,
            suffixAction: suffixAction,
            isSecure: true,
            inputBuilder: {
                SecureTextField(
                    text: value,
                    innerState: innerState,
                    style: .init(
                        textContentType: textContent,
                        keyboardType: keyboard,
                        font: .orbit(size: Text.Size.normal.value, weight: .regular),
                        state: state
                    ),
                    onEditingChanged: { isEditing in
                        innerState.isEditing = isEditing
                        onEditingChanged(isEditing)
                    },
                    onCommit: onCommit
                )
            }
        )
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
            storybookMix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        StateWrapper(initialState: value) { state in
            InputField(label, value: state, prefix: .icon(.grid), suffix: .icon(.grid), placeholder: placeholder, state: .default)
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
            InputField(label, value: state, prefix: .icon(.grid), suffix: .icon(.grid), placeholder: placeholder, message: message)
        }
    }

    static var storybookMix: some View {
        VStack(spacing: .medium) {
            InputField("Empty", value: .constant(""), placeholder: placeholder)
            InputField("Disabled, Empty", value: .constant(""), placeholder: placeholder, state: .disabled)
            InputField("Disabled", value: .constant("Disabled Value"), placeholder: placeholder, state: .disabled)
            InputField("Default", value: .constant("InputField Value"))
            InputField("Modified", value: .constant("Modified value"), state: .modified)
            InputField("Focused", value: .constant("Focus / Help"), message: .help("Help message"))
            InputField(
                "InputField with a long multiline label to test that it works",
                value: .constant("Error value with a very long length to test that it works"),
                message: .error("Error message, also very long and multi-line to test that it works.")
            ).padding(.bottom, .small)

            VStack(spacing: .medium) {
                InputField("Secured", securedValue: .constant("password"))
                InputField("Secured", securedValue: .constant(""), placeholder: "Input password")
                InputField("Secured", securedValue: .constant("password"), passwordStrength: .medium(title: "Medium"))
            }

            HStack(spacing: .medium) {
                InputField(value: .constant("No label"))
                InputField(value: .constant("Flag prefix"), prefix: .countryFlag("us"))
            }
        }
        .padding(.medium)
    }
}

struct InputFieldLivePreviews: PreviewProvider {

    class UppercaseAlphabetFormatter: Formatter {

        override func string(for obj: Any?) -> String? {
            guard let string = obj as? String else { return nil }

            return string.uppercased()
        }

        override func getObjectValue(
            _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
            for string: String,
            errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
        ) -> Bool {
            obj?.pointee = string.lowercased() as AnyObject
            return true
        }
    }

    struct UppercaseAlphabetFormatStyle: FormatStyle, ParseableFormatStyle {

        var parseStrategy = LowercasedParseStrategy()

        func format(_ value: String) -> String {
            value.uppercased()
        }
    }
    struct LowercasedParseStrategy: ParseStrategy {
        func parse(_ value: String) throws -> String {
            value.lowercased()
        }
    }

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

                VStack(alignment: .leading) {
                    Text("InputField uppercasing the input")

                    InputField(
                        value: $value,
                        placeholder: "Use Formatter subclass",
                        formatter: UppercaseAlphabetFormatter()
                    )

                    if #available(iOS 15, *) {
                        InputField(
                            value: $value,
                            placeholder: "Use FormatStyle conformances",
                            formatStyle: UppercaseAlphabetFormatStyle()
                        )
                    }
                }

                Spacer()
                Spacer()
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
                    securedValue: state,
                    suffix: .none,
                    textContent: .password,
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
            InputField(InputFieldPreviews.label, value: state, prefix: .icon(.grid), suffix: .icon(.grid), placeholder: InputFieldPreviews.placeholder, state: .default)
        }
        InputField("Secured", securedValue: .constant(""), placeholder: "Input password")
    }
}
