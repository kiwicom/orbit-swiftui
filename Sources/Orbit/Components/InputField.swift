import SwiftUI
import UIKit

/// Style variant for Orbit InputField component.
public enum InputFieldStyle {

    /// Style with label positioned above the InputField.
    case `default`
    /// Style with compact label positioned inside the InputField.
    case compact
}

/// Also known as textbox. Offers users a simple input for a form.
///
/// When you have additional information or helpful examples, include placeholder text to help users along.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/inputfield/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` modifier.
public struct InputField<Value>: View where Value: LosslessStringConvertible {

    private enum Mode {
        case actionsHandler(onEditingChanged: (Bool) -> Void, onCommit: () -> Void, isSecure: Bool)
        case formatter(formatter: Formatter)
    }

    @Binding private var value: Value
    @Binding private var messageHeight: CGFloat
    @State private var isEditing: Bool = false
    @State private var isSecureTextRedacted: Bool = true

    let label: String
    let labelAccentColor: UIColor?
    let labelLinkColor: TextLink.Color
    let labelLinkAction: TextLink.Action
    let placeholder: String
    let prefix: Icon.Content
    let suffix: Icon.Content
    let state: InputState
    let textContent: UITextContentType?
    let keyboard: UIKeyboardType
    let autocapitalization: UITextAutocapitalizationType
    let isAutocompleteEnabled: Bool
    let passwordStrength: PasswordStrengthIndicator.PasswordStrength
    let message: Message?
    let style: InputFieldStyle
    let suffixAction: (() -> Void)?

    private let mode: Mode

    public var body: some View {
        FieldWrapper(
            fieldLabel,
            labelAccentColor: labelAccentColor,
            labelLinkColor: labelLinkColor,
            labelLinkAction: labelLinkAction,
            message: message,
            messageHeight: $messageHeight
        ) {
            InputContent(
                prefix: prefix,
                suffix: suffix,
                state: state,
                message: message,
                isEditing: isEditing,
                suffixAction: suffixAction
            ) {
                HStack(alignment: .firstTextBaseline, spacing: .small) {
                    compactLabel

                    input
                        .textFieldStyle(TextFieldStyle(leadingPadding: 0))
                        .autocapitalization(autocapitalization)
                        .disableAutocorrection(isAutocompleteEnabled == false)
                        .textContentType(textContent)
                        .keyboardType(keyboard)
                        .orbitFont(size: Text.Size.normal.value, style: .body)
                        .accentColor(.blueNormal)
                        .background(textFieldPlaceholder, alignment: .leading)
                        .disabled(state == .disabled)
                        .accessibility(.inputValue)
                }
            }
        } footer: {
            PasswordStrengthIndicator(passwordStrength: passwordStrength)
                .padding(.top, .xxSmall)
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: .init(label))
        .accessibility(value: .init(value.description))
        .accessibility(hint: .init(messageDescription.isEmpty ? placeholder : messageDescription))
        .accessibility(addTraits: .isButton)
    }

    @ViewBuilder var input: some View {
        switch mode {
            case .actionsHandler(let onEditingChanged, let onCommit, let isSecure):
                if isSecure {
                    HStack(spacing: 0) {
                        secureField(onEditingChanged: onEditingChanged, onCommit: onCommit)
                        secureTextRedactedToggle
                    }
                } else {
                    textField(onEditingChanged: onEditingChanged, onCommit: onCommit)
                }
            case .formatter(let formatter):
                TextField("", value: $value, formatter: formatter)
        }
    }

    @ViewBuilder var textFieldPlaceholder: some View {
        if showPlaceholder {
            Text(placeholder, color: .none)
                .foregroundColor(state.placeholderColor)
        }
    }

    @ViewBuilder var compactLabel: some View {
        if style == .compact {
            Text(label, color: .custom(compactLabelColor), weight: .medium)
        }
    }

    @ViewBuilder var secureTextRedactedToggle: some View {
        if value.description.isEmpty == false, state != .disabled {
            Icon(isSecureTextRedacted ? .visibility : .visibilityOff, color: .inkNormal)
                .padding(.vertical, .xSmall)
                .padding(.horizontal, .small)
                .contentShape(Rectangle())
                .onTapGesture {
                    isSecureTextRedacted.toggle()
                }
                .accessibility(addTraits: .isButton)
                .accessibility(.inputFieldPasswordToggle)
                .opacity(state == .disabled ? 0 : 1)
        }
    }

    @ViewBuilder func secureField(
        onEditingChanged: @escaping (Bool) -> Void,
        onCommit: @escaping () -> Void
    ) -> some View {
        SecureTextField(
            text: Binding(
                get: { self.value.description },
                set: { self.value = Value.init($0) ?? self.value }
            ),
            isSecured: $isSecureTextRedacted,
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

    @ViewBuilder func textField(
        onEditingChanged: @escaping (Bool) -> Void,
        onCommit: @escaping () -> Void
    ) -> some View {
        TextField(
            "",
            text: Binding(
                get: { self.value.description },
                set: { self.value = Value.init($0) ?? self.value }
            ),
            onEditingChanged: { isEditing in
                self.isEditing = isEditing
                onEditingChanged(isEditing)
            },
            onCommit: onCommit
        )
        .padding(.trailing, suffix == .none ? .small : 0)
    }

    var isSecure: Bool {
        switch mode {
            case .actionsHandler(_, _, let isSecure):
                return isSecure
            case .formatter(_):
                return false
        }
    }

    var fieldLabel: String {
        switch style {
            case .default:          return label
            case .compact:          return ""
        }
    }

    var messageDescription: String {
        message?.description ?? ""
    }

    var compactLabelColor: UIColor {
        showPlaceholder ? .inkDark : .inkLight
    }

    var showPlaceholder: Bool {
        value.description.isEmpty
    }
}

public extension InputField {

    /// Creates Orbit InputField component.
    ///
    /// - Parameters:
    ///     - message: Message below InputField.
    ///     - messageHeight: Binding to the current height of message.
    ///     - suffixAction: Optional separate action on suffix icon tap.
    init(
        _ label: String = "",
        labelAccentColor: UIColor? = nil,
        labelLinkColor: TextLink.Color = .primary,
        labelLinkAction: @escaping TextLink.Action = { _, _ in },
        value: Binding<Value>,
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
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        style: InputFieldStyle = .default,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {},
        suffixAction: (() -> Void)? = nil
    ) where Value == String {
        self.init(
            label,
            labelAccentColor: labelAccentColor,
            labelLinkColor: labelLinkColor,
            labelLinkAction: labelLinkAction,
            value: value,
            prefix: prefix,
            suffix: suffix,
            placeholder: placeholder,
            state: state,
            textContent: textContent,
            keyboard: keyboard,
            autocapitalization: autocapitalization,
            isAutocompleteEnabled: isAutocompleteEnabled,
            passwordStrength: passwordStrength,
            message: message,
            messageHeight: messageHeight,
            style: style,
            mode: .actionsHandler(onEditingChanged: onEditingChanged, onCommit: onCommit, isSecure: isSecure),
            suffixAction: suffixAction
        )
    }

    /// Creates Orbit InputField component using a provided Formatter
    /// that will format an input without changing underlying value when it's committed
    ///
    /// - Parameters:
    ///     - message: Message below InputField.
    ///     - messageHeight: Binding to the current height of message.
    ///     - formatter: A formatter to use when converting between the
    ///     string the user edits and the underlying value.
    ///     If `formatter` can't perform the conversion, the text field doesn't
    ///     modify `binding.value`.
    ///     - suffixAction: Optional separate action on suffix icon tap.
    init(
        _ label: String = "",
        labelAccentColor: UIColor? = nil,
        labelLinkColor: TextLink.Color = .primary,
        labelLinkAction: @escaping TextLink.Action = { _, _ in },
        value: Binding<Value>,
        prefix: Icon.Content = .none,
        suffix: Icon.Content = .none,
        placeholder: String = "",
        state: InputState = .default,
        textContent: UITextContentType? = nil,
        keyboard: UIKeyboardType = .default,
        autocapitalization: UITextAutocapitalizationType = .none,
        isAutocompleteEnabled: Bool = false,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        style: InputFieldStyle = .default,
        formatter: Formatter,
        suffixAction: (() -> Void)? = nil
    ) {
        self.init(
            label,
            labelAccentColor: labelAccentColor,
            labelLinkColor: labelLinkColor,
            labelLinkAction: labelLinkAction,
            value: value,
            prefix: prefix,
            suffix: suffix,
            placeholder: placeholder,
            state: state,
            textContent: textContent,
            keyboard: keyboard,
            autocapitalization: autocapitalization,
            isAutocompleteEnabled: isAutocompleteEnabled,
            passwordStrength: .empty,
            message: message,
            messageHeight: messageHeight,
            style: style,
            mode: .formatter(formatter: formatter),
            suffixAction: suffixAction
        )
    }
}

extension InputField {

    private init(
        _ label: String = "",
        labelAccentColor: UIColor? = nil,
        labelLinkColor: TextLink.Color = .primary,
        labelLinkAction: @escaping TextLink.Action = { _, _ in },
        value: Binding<Value>,
        prefix: Icon.Content = .none,
        suffix: Icon.Content = .none,
        placeholder: String = "",
        state: InputState = .default,
        textContent: UITextContentType? = nil,
        keyboard: UIKeyboardType = .default,
        autocapitalization: UITextAutocapitalizationType = .none,
        isAutocompleteEnabled: Bool = false,
        passwordStrength: PasswordStrengthIndicator.PasswordStrength = .empty,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        style: InputFieldStyle = .default,
        mode: Mode,
        suffixAction: (() -> Void)? = nil
    ) {
        self.label = label
        self.labelAccentColor = labelAccentColor
        self.labelLinkColor = labelLinkColor
        self.labelLinkAction = labelLinkAction
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
        self.passwordStrength = passwordStrength
        self.style = style
        self.mode = mode
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
    static let longLabel = "Very \(String(repeating: "very ", count: 8))long multiline label"
    static let passwordLabel = "Password label"
    static let value = "Value"
    static let passwordValue = "someVeryLongPasswordValue"
    static let longValue = "\(String(repeating: "very ", count: 15))long value"
    static let placeholder = "Placeholder"
    static let helpMessage = "Help message"
    static let errorMessage = "Error message"
    static let longErrorMessage = "Very \(String(repeating: "very ", count: 8))long error message"

    static var previews: some View {
        PreviewWrapper {
            standalone
            storybook
            storybookPassword
            storybookMix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        StateWrapper(initialState: value) { state in
            InputField(label, value: state, prefix: .grid, suffix: .grid, placeholder: placeholder, state: .default)
        }
    }

    static var storybook: some View {
        VStack(spacing: .medium) {
            Group {
                inputField(value: "", message: .none)
                inputField(value: "", prefix: .none, message: .help(helpMessage))
                inputField(value: "", suffix: .none, message: .error(errorMessage))
                Separator()
                inputField(value: longValue, prefix: .none, suffix: .none, message: .none)
                inputField(value: value, message: .help(helpMessage))
                inputField(value: value, message: .error(errorMessage))
                Separator()
            }

            Group {
                inputField(value: longValue, prefix: .none, suffix: .none, message: .none, style: .compact)
                inputField(value: "", prefix: .none, suffix: .none, message: .none, style: .compact)
                inputField(value: "", message: .error(errorMessage), style: .compact)
                inputField(value: value, message: .error(errorMessage), style: .compact)
            }
        }
    }

    static var storybookPassword: some View {
        VStack(spacing: .medium) {
            inputField(passwordLabel, value: passwordValue, isSecure: true)
            inputField(passwordLabel, value: "", prefix: .none, placeholder: "Input password", isSecure: true)
            inputField(passwordLabel, value: passwordValue, suffix: .none, isSecure: true, passwordStrength: .weak(title: "Weak"), message: .error("Error message"))
            inputField(passwordLabel, value: passwordValue, prefix: .none, suffix: .none, isSecure: true, passwordStrength: .medium(title: "Medium"), message: .help("Help message"))
            inputField(passwordLabel, value: passwordValue, isSecure: true, passwordStrength: .strong(title: "Strong"))
        }
    }

    static var storybookMix: some View {
        VStack(spacing: .medium) {
            inputField("Empty", value: "", prefix: .symbol(.grid, color: .blueDark), suffix: .symbol(.grid, color: .blueDark))
            inputField("Disabled, Empty", value: "", prefix: .countryFlag("cz"), suffix: .countryFlag("us"), state: .disabled)
            inputField("Disabled", value: "Disabled Value", prefix: .sfSymbol("info.circle.fill"), suffix: .sfSymbol("info.circle.fill"), state: .disabled)
            inputField("Modified from previous state", value: "Modified value", state: .modified)
            inputField("Focused", value: "Focused / Help", message: .help("Help message"))
            inputField(
                FieldLabelPreviews.longLabel,
                labelAccentColor: .orangeNormal,
                labelLinkColor: .status(.critical),
                value: longValue,
                message: .error(longErrorMessage)
            )
            inputField("Compact", style: .compact)

            HStack(spacing: .medium) {
                inputField(value: "No label")
                inputField(value: "Flag prefix", prefix: .countryFlag("us"))
            }
        }
    }

    static func inputField(
        _ label: String = label,
        labelAccentColor: UIColor? = nil,
        labelLinkColor: TextLink.Color = .primary,
        labelLinkAction: @escaping TextLink.Action = { _, _ in },
        value: String = value,
        prefix: Icon.Content = .grid,
        suffix: Icon.Content = .grid,
        placeholder: String = placeholder,
        state: InputState = .default,
        isSecure: Bool = false,
        passwordStrength: PasswordStrengthIndicator.PasswordStrength = .empty,
        message: Message? = nil,
        style: InputFieldStyle = .default
    ) -> some View {
        StateWrapper(initialState: value) { value in
            InputField(
                label,
                labelAccentColor: labelAccentColor,
                labelLinkColor: labelLinkColor,
                labelLinkAction: labelLinkAction,
                value: value,
                prefix: prefix,
                suffix: suffix,
                placeholder: placeholder,
                state: state,
                isSecure: isSecure,
                passwordStrength: passwordStrength,
                message: message,
                style: style
            )
        }
    }
    
    static var snapshot: some View {
        storybook
            .padding(.medium)
    }

    static var snapshotPassword: some View {
        storybookPassword
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

    static var previews: some View {
        PreviewWrapper()
        securedWrapper
    }
    
    struct PreviewWrapper: View {

        @State var message: Message? = nil
        @State var textValue = "12"
        @State var intValue = 0

        init() {
            Font.registerOrbitFonts()
        }

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: .medium) {
                    Heading("Heading", style: .title2)

                    Text("Some text, but also very long and multi-line to test that it works.")

                    InputField(
                        "InputField",
                        value: $textValue,
                        suffix: .email,
                        placeholder: "Placeholder",
                        state: .disabled,
                        message: message,
                        suffixAction: {
                            intValue = 1
                        }
                    )

                    Text("Some text, but also very long and multi-line to test that it works.")

                    VStack(alignment: .leading, spacing: .medium) {
                        Text("InputField uppercasing the input, but not changing projected value:")

                        InputField(
                            value: $textValue,
                            placeholder: "Uppercased",
                            formatter: UppercaseAlphabetFormatter()
                        )

                        Text("Number: \(intValue)")

                        InputField(
                            value: $intValue,
                            placeholder: "Decimal formatter",
                            formatter: formatter
                        )
                    }

                    Spacer(minLength: 0)

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
                .padding(.medium)
            }
            .previewDisplayName("Run Live Preview with Input Field")
        }

        let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    }

    static var securedWrapper: some View {
        StateWrapper(initialState: "textfield-should-respect-long-password-and-screen-bounds-1234567890") { state in
            VStack(alignment: .leading, spacing: .medium) {
                Heading("Secured TextField with long init value", style: .title2)

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
