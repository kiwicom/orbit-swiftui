import SwiftUI
import UIKit

/// Also known as textbox. Offers users a simple input for a form.
///
/// When you have additional information or helpful examples, include prompt text to help users along.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/inputfield/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` modifier.
public struct InputField: View, TextFieldBuildable {

    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.inputFieldBeginEditingAction) private var inputFieldBeginEditingAction
    @Environment(\.inputFieldEndEditingAction) private var inputFieldEndEditingAction
    @Environment(\.isEnabled) private var isEnabled

    @State private var isEditing: Bool = false
    @State private var isSecureTextRedacted: Bool = true

    private var label: String
    @Binding private var value: String
    private var prefix: Icon.Content?
    private var suffix: Icon.Content?
    private var prompt: String
    private var state: InputState
    private var style: InputFieldStyle

    private var isSecure: Bool
    private var passwordStrength: PasswordStrengthIndicator.PasswordStrength?
    private var message: Message?
    @Binding private var messageHeight: CGFloat
    private var suffixAction: (() -> Void)?

    // Builder properties (keyboard related)
    var autocapitalizationType: UITextAutocapitalizationType = .none
    var isAutocorrectionDisabled: Bool = false
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var textContentType: UITextContentType?
    var shouldDeleteBackwardAction: (String) -> Bool = { _ in true }

    public var body: some View {
        FieldWrapper(
            fieldLabel,
            message: message,
            messageHeight: $messageHeight
        ) {
            InputContent(
                prefix: prefix,
                suffix: suffix,
                prefixAccessibilityID: .inputFieldPrefix,
                suffixAccessibilityID: .inputFieldSuffix,
                state: state,
                message: message,
                isEditing: isEditing,
                suffixAction: suffixAction
            ) {
                HStack(alignment: .firstTextBaseline, spacing: .small) {
                    compactLabel

                    HStack(spacing: 0) {
                        textField
                        secureTextRedactedButton
                    }
                }
            }
        } footer: {
            if let passwordStrength {
                PasswordStrengthIndicator(passwordStrength: passwordStrength)
                    .padding(.top, .xxSmall)
            }
        }
    }

    @ViewBuilder private var textField: some View {
        TextField(
            value: $value,
            prompt: prompt,
            isSecureTextEntry: isSecure && isSecureTextRedacted,
            font: .orbit(size: Text.Size.normal.value * sizeCategory.ratio, weight: .regular),
            state: state,
            leadingPadding: leadingPadding,
            trailingPadding: trailingPadding
        )
        .returnKeyType(returnKeyType)
        .autocorrectionDisabled(isAutocorrectionDisabled)
        .keyboardType(keyboardType)
        .textContentType(textContentType)
        .autocapitalization(autocapitalizationType)
        .shouldDeleteBackwardAction(shouldDeleteBackwardAction)
        .accessibility(
            label: .init(
                [label, prefix?.accessibilityLabel, suffix?.accessibilityLabel].compactMap { $0 }.joined(separator: ", ")
            )
        )
        .inputFieldBeginEditingAction {
            isEditing = true
            inputFieldBeginEditingAction()
        }
        .inputFieldEndEditingAction {
            isEditing = false
            inputFieldEndEditingAction()
        }
    }

    @ViewBuilder private var compactLabel: some View {
        if style == .compact {
            Text(label)
                .textColor(compactLabelColor)
                .fontWeight(.medium)
                .padding(.leading, isPrefixEmpty ? .small : 0)
        }
    }

    @ViewBuilder private var secureTextRedactedButton: some View {
        if isSecure, value.description.isEmpty == false, isEnabled {
            BarButton(isSecureTextRedacted ? .visibility : .visibilityOff, size: .normal) {
                isSecureTextRedacted.toggle()
            }
            .padding(.leading, .xSmall)
            .padding(.trailing, isSuffixEmpty ? .xxSmall : 0)
            .accessibility(.inputFieldPasswordToggle)
        }
    }

    private var fieldLabel: String {
        switch style {
            case .default:          return label
            case .compact:          return ""
        }
    }

    private var messageDescription: String {
        message?.description ?? ""
    }

    private var compactLabelColor: Color {
        value.description.isEmpty ? .inkDark : .inkLight
    }

    private var leadingPadding: CGFloat {
        isPrefixEmpty && style == .default
            ? .small
            : 0
    }

    private var isPrefixEmpty: Bool {
        prefix?.isEmpty ?? true
    }

    private var trailingPadding: CGFloat {
        isSuffixEmpty ? .small : 0
    }

    private var isSuffixEmpty: Bool {
        suffix?.isEmpty ?? true
    }
}

public extension InputField {

    /// Creates Orbit InputField component.
    ///
    /// The keyboard related modifiers can be used directly on this component to modify the keyboard behaviour:
    /// - `autocapitalization()`
    /// - `autocorrectionDisabled()`
    /// - `keyboardType()`
    /// - `textContentType()`
    ///
    /// - Parameters:
    ///   - message: Optional message below the InputField.
    ///   - messageHeight: Binding to the current height of the optional message.
    ///   - suffixAction: Optional action when suffix icon is tapped.
    init(
        _ label: String = "",
        value: Binding<String>,
        prefix: Icon.Content? = nil,
        suffix: Icon.Content? = nil,
        prompt: String = "",
        state: InputState = .default,
        style: InputFieldStyle = .default,
        isSecure: Bool = false,
        passwordStrength: PasswordStrengthIndicator.PasswordStrength? = nil,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        suffixAction: (() -> Void)? = nil
    ) {
        self.label = label
        self._value = value
        self.prefix = prefix
        self.suffix = suffix
        self.prompt = prompt
        self.state = state
        self.style = style
        self.isSecure = isSecure
        self.passwordStrength = passwordStrength
        self.message = message
        self._messageHeight = messageHeight
        self.suffixAction = suffixAction
    }
}

// MARK: - Types

/// Style variant for Orbit InputField component.
public enum InputFieldStyle {

    /// Style with label positioned above the InputField.
    case `default`
    /// Style with compact label positioned inside the InputField.
    case compact
}

// MARK: - Identifiers
public extension AccessibilityID {

    static let inputFieldPrefix             = Self(rawValue: "orbit.inputfield.prefix")
    static let inputFieldSuffix             = Self(rawValue: "orbit.inputfield.suffix")
    static let inputFieldPasswordToggle     = Self(rawValue: "orbit.inputfield.password.toggle")
}

// MARK: - Private
private extension InputField {

    func set<V>(_ keypath: WritableKeyPath<Self, V>, to value: V) -> Self {
        var copy = self
        copy[keyPath: keypath] = value
        return copy
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
    static let prompt = "Placeholder"
    static let helpMessage = "Help message"
    static let errorMessage = "Error message"
    static let longErrorMessage = "Very \(String(repeating: "very ", count: 8))long error message"

    static var previews: some View {
        PreviewWrapper {
            standalone
            fixedSize
            styles
            sizing
            password
            mix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: .medium) {
            StateWrapper(value) { state in
                InputField(label, value: state, prompt: prompt, state: .default)
            }
            StateWrapper("") { state in
                InputField(label, value: state, prompt: prompt, state: .default)
            }
            StateWrapper(value) { state in
                InputField(label, value: state, prefix: .grid, suffix: .grid, prompt: prompt, state: .default)
            }
            StateWrapper("") { state in
                InputField(label, value: state, prefix: .grid, suffix: .grid, prompt: prompt, state: .default)
            }
            StateWrapper(value) { state in
                InputField("Secure", value: state, prefix: .grid, prompt: prompt, state: .default, isSecure: true)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var fixedSize: some View {
        VStack(spacing: .medium) {
            StateWrapper("Long value") { state in
                InputField(label, value: state, prompt: prompt, state: .default)
            }
            StateWrapper("") { state in
                InputField(label, value: state, prompt: prompt, state: .default)
            }
            StateWrapper(value) { state in
                InputField(label, value: state, prefix: .grid, suffix: .grid, prompt: prompt, state: .default)
            }
            StateWrapper("") { state in
                InputField(label, value: state, prefix: .grid, suffix: .grid, prompt: prompt, state: .default)
            }
            StateWrapper(value) { state in
                InputField("Secure", value: state, prefix: .grid, prompt: prompt, state: .default, isSecure: true)
            }
        }
        .frame(width: 80)
        .padding(.medium)
        .previewDisplayName()
    }

    static var styles: some View {
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
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .small) {
            Group {
                inputField("", value: "", message: .none)
                inputField("", value: "", prefix: .none, suffix: .none)
                inputField("", value: "Value", prefix: .none, suffix: .none)
                inputField("", value: "", prefix: .grid, suffix: .none, prompt: "")
                inputField("", value: "", prefix: .none, suffix: .none, prompt: "")
                inputField("", value: "Password", prefix: .none, suffix: .none, isSecure: true)
                inputField("", value: "Password", prefix: .none, suffix: .none, isSecure: true)
                    .disabled(true)
            }
            .frame(width: 200)
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var password: some View {
        VStack(spacing: .medium) {
            inputField("Disabled", value: passwordValue, isSecure: true)
                .disabled(true)
            inputField(passwordLabel, value: passwordValue, isSecure: true)
            inputField(passwordLabel, value: "", prefix: .none, prompt: "Input password", isSecure: true)
            inputField(passwordLabel, value: passwordValue, suffix: .none, isSecure: true, passwordStrength: .weak(title: "Weak"), message: .error("Error message"))
            inputField(passwordLabel, value: passwordValue, prefix: .none, suffix: .none, isSecure: true, passwordStrength: .medium(title: "Medium"), message: .help("Help message"))
            inputField(passwordLabel, value: passwordValue, isSecure: true, passwordStrength: .strong(title: "Strong"))
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(spacing: .medium) {
            inputField("Empty", value: "", prefix: .symbol(.grid, color: .blueDark), suffix: .symbol(.grid, color: .blueDark))
            inputField("Disabled, Empty", value: "", prefix: .countryFlag("cz"), suffix: .countryFlag("us"))
                .disabled(true)
            inputField("Disabled", value: "Disabled Value", prefix: .sfSymbol("info.circle.fill"), suffix: .sfSymbol("info.circle.fill"))
                .disabled(true)
            inputField("Modified from previous state", value: "Modified value", state: .modified)
            inputField("Focused", value: "Focused / Help", message: .help("Help message"))
            inputField(
                FieldLabelPreviews.longLabel,
                value: longValue,
                message: .error(longErrorMessage)
            )
            .textLinkColor(.status(.critical))
            .textAccentColor(.orangeNormal)
            
            inputField("Compact", style: .compact)

            HStack(spacing: .medium) {
                inputField(value: "No label")
                inputField(value: "Flag prefix", prefix: .countryFlag("us"))
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func inputField(
        _ label: String = label,
        value: String = value,
        prefix: Icon.Content? = .grid,
        suffix: Icon.Content? = .grid,
        prompt: String = prompt,
        state: InputState = .default,
        isSecure: Bool = false,
        passwordStrength: PasswordStrengthIndicator.PasswordStrength? = nil,
        message: Message? = nil,
        style: InputFieldStyle = .default
    ) -> some View {
        StateWrapper(value) { value in
            InputField(
                label,
                value: value,
                prefix: prefix,
                suffix: suffix,
                prompt: prompt,
                state: state,
                style: style,
                isSecure: isSecure,
                passwordStrength: passwordStrength,
                message: message
            )
        }
    }
}

struct InputFieldLivePreviews: PreviewProvider {

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
                    InputField(
                        "InputField",
                        value: $textValue,
                        suffix: .email,
                        prompt: "Placeholder",
                        message: message,
                        suffixAction: {
                            intValue = 1
                        }
                    )
                    .disabled(true)

                    if #available(iOS 16.0, *) {
                        VStack(alignment: .leading, spacing: .medium) {
                            Text("InputField with uppercasing the input")

                            InputField(
                                value: $textValue,
                                prompt: "Uppercased"
                            )
                            .onChange(of: textValue) { value in
                                textValue = value.uppercased()
                            }
                        }
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
    }

    static var securedWrapper: some View {
        StateWrapper("textfield-should-respect-long-password-and-screen-bounds-1234567890") { state in
            VStack(alignment: .leading, spacing: .medium) {
                Heading("Secured TextField with long init value", style: .title2)

                InputField(
                    value: state,
                    isSecure: true,
                    passwordStrength: validate(password: state.wrappedValue)
                )
                .textContentType(.password)
            }
        }
        .padding()
        .previewDisplayName()
    }

    static func validate(password: String) -> PasswordStrengthIndicator.PasswordStrength? {
        switch password.count {
            case 0:         return nil
            case 1...3:     return .weak(title: "Weak")
            case 4...6:     return .medium(title: "Medium")
            default:        return .strong(title: "Strong")
        }
    }
}
