import SwiftUI
import UIKit

/// Orbit input component that that displays a single-line text input control. 
/// A counterpart of the native `SwiftUI.TextField`.
///
/// The ``InputField`` consists of a label, message and a binding to a string value:
///
/// ```swift
/// InputField("Label", value: $email, prompt: "E-mail")
///     .keyboardType(.emailAddress)
///     .returnKeyType(.done)
///     .focused($isEmailFocused)
///     .inputFieldReturnAction {
///         // Submit action
///     }
/// ```
/// 
/// For secure version, the `passwordStrength` hint can be provided:
///     
/// ```swift    
/// InputField(
///     "Password", 
///     value: $password, 
///     isSecure: true,
///     passwordStrength: passwordStrength,
///     message: .help("Must be at least 8 characters long")
/// )
/// ```
///
/// In order to instantly switch focus between text fields on submit, 
/// return `false` from the ``inputFieldShouldReturnAction(_:)-82nse`` after switching the focus.
/// 
/// ```swift
/// InputField("Label", value: $email, prompt: "E-mail")
///     .focused($focus, equals: .email)
///     .inputFieldShouldReturnAction {
///         focus = .name
///         return false
///     }
/// ``` 
///
/// The component uses a custom ``TextField`` component (implemented using `UITextField`).
///
/// ### Layout
///
/// The component expands horizontally.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/inputfield/)
public struct InputField<Label: View, Prompt: View, Prefix: View, Suffix: View>: View, TextFieldBuildable {

    @Environment(\.iconColor) private var iconColor
    @Environment(\.inputFieldBeginEditingAction) private var inputFieldBeginEditingAction
    @Environment(\.inputFieldEndEditingAction) private var inputFieldEndEditingAction
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.textColor) private var textColor

    @State private var isFocused: Bool = false
    @State private var isSecureTextRedacted: Bool = true

    @Binding private var value: String

    private let state: InputState
    private let labelStyle: InputLabelStyle
    @ViewBuilder private let label: Label
    @ViewBuilder private let prompt: Prompt
    @ViewBuilder private var prefix: Prefix
    @ViewBuilder private var suffix: Suffix

    private let isSecure: Bool
    private let passwordStrength: PasswordStrengthIndicator.PasswordStrength?
    private let message: Message?

    // Builder properties (keyboard related)
    var autocapitalizationType: UITextAutocapitalizationType = .none
    var isAutocorrectionDisabled: Bool? = false
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var textContentType: UITextContentType?
    var shouldDeleteBackwardAction: (String) -> Bool = { _ in true }

    public var body: some View {
        FieldWrapper(message: message) {
            InputContent(state: state, message: message, isFocused: isFocused) {
                textField
            } label: {
                compactLabel
            } prefix: {
                prefix
                    .iconColor(prefixIconColor)
                    .accessibility(.inputFieldPrefix)
                    .accessibility(hidden: true)
            } suffix: {
                if suffix.isEmpty == false || showSecureTextRedactedButton {
                    HStack(spacing: .small) {
                        secureTextRedactedButton
                            .accessibility(.inputFieldPasswordToggle)
                        suffix
                            .accessibility(.inputFieldSuffix)
                    }
                }
            }
        } label: {
            defaultLabel
        } footer: {
            if let passwordStrength {
                PasswordStrengthIndicator(passwordStrength: passwordStrength)
                    .padding(.top, .xxSmall)
            }
        }
        .accessibility(.inputField)
    }

    @ViewBuilder private var textField: some View {
        TextField(
            value: $value,
            isSecureTextEntry: isSecure && isSecureTextRedacted,
            state: state,
            leadingPadding: .small,
            trailingPadding: .small,
            keyboardSpacing: keyboardSpacing
        )
        .returnKeyType(returnKeyType)
        .autocorrectionDisabled(isAutocorrectionDisabled)
        .keyboardType(keyboardType)
        .textContentType(textContentType)
        .autocapitalization(autocapitalizationType)
        .shouldDeleteBackwardAction(shouldDeleteBackwardAction)
        .inputFieldBeginEditingAction {
            isFocused = true
            inputFieldBeginEditingAction()
        }
        .inputFieldEndEditingAction {
            isFocused = false
            inputFieldEndEditingAction()
        }
        // Reverts the additional keyboard spacing used for native keyboard avoidance
        .padding(.bottom, -keyboardSpacing)
        .overlay(
            resolvedPrompt, 
            alignment: .leadingFirstTextBaseline
        )
        .accessibility(children: nil) {
            label
        } value: {
            Text(value)
        } hint: {
            prompt
        }
    }
    
    @ViewBuilder private var secureTextRedactedButton: some View {
        if showSecureTextRedactedButton {
            IconButton(isSecureTextRedacted ? .visibility : .visibilityOff) {
                isSecureTextRedacted.toggle()
            }
        }
    }
    
    private var keyboardSpacing: CGFloat {
        .medium
    }

    @ViewBuilder private var defaultLabel: some View {
        switch labelStyle {
            case .default:          label
            case .compact:          EmptyView()
        }
    }

    @ViewBuilder private var compactLabel: some View {
        switch labelStyle {
            case .default:          EmptyView()
            case .compact:          label
        }
    }
    
    @ViewBuilder private var resolvedPrompt: some View {
        if value.isEmpty {
            prompt
                .textColor(isEnabled ? state.placeholderColor : .cloudDarkActive)
                .lineLimit(1)
                .padding(.horizontal, .small)
                .allowsHitTesting(false)
                .accessibility(hidden: true)
        }
    }
    
    private var prefixIconColor: Color? {
        isEnabled
            ? iconColor ?? textColor ?? (labelStyle == .default ? .inkDark : .inkNormal)
            : .cloudDarkActive
    }

    private var showSecureTextRedactedButton: Bool {
        isSecure && value.description.isEmpty == false && isEnabled
    }
    
    /// Creates Orbit ``InputField`` component with custom content.
    ///
    /// - Parameters:
    ///   - message: Optional message below the text field.
    public init(
        value: Binding<String>,
        state: InputState = .default,
        labelStyle: InputLabelStyle = .default,
        isSecure: Bool = false,
        passwordStrength: PasswordStrengthIndicator.PasswordStrength? = nil,
        message: Message? = nil,
        @ViewBuilder label: () -> Label,
        @ViewBuilder prompt: () -> Prompt = { EmptyView() },
        @ViewBuilder prefix: () -> Prefix = { EmptyView() },
        @ViewBuilder suffix: () -> Suffix = { EmptyView() }
    ) {
        self._value = value
        self.state = state
        self.labelStyle = labelStyle
        self.isSecure = isSecure
        self.passwordStrength = passwordStrength
        self.message = message
        self.label = label()
        self.prompt = prompt()
        self.prefix = prefix()
        self.suffix = suffix()
    }
}

// MARK: - Convenience Inits
public extension InputField where Label == Text, Prompt == Text, Prefix == Icon, Suffix == Icon {
    
    /// Creates Orbit ``InputField`` component.
    ///
    /// - Parameters:
    ///   - message: Optional message below the text field.
    @_disfavoredOverload
    init(
        _ label: some StringProtocol = String(""),
        value: Binding<String>,
        prompt: some StringProtocol = String(""),
        prefix: Icon.Symbol? = nil,
        suffix: Icon.Symbol? = nil,
        state: InputState = .default,
        labelStyle: InputLabelStyle = .default,
        isSecure: Bool = false,
        passwordStrength: PasswordStrengthIndicator.PasswordStrength? = nil,
        message: Message? = nil
    ) {
        self.init(
            value: value,
            state: state,
            labelStyle: labelStyle,
            isSecure: isSecure,
            passwordStrength: passwordStrength,
            message: message
        ) {
            Text(label)
        } prompt: {
            Text(prompt)
        } prefix: {
            Icon(prefix)
        } suffix: {
            Icon(suffix)
        }
    }
    
    /// Creates Orbit ``InputField`` component with localizable texts.
    ///
    /// - Parameters:
    ///   - message: Optional message below the text field.
    @_semantics("swiftui.init_with_localization")
    init(
        _ label: LocalizedStringKey = "",
        value: Binding<String>,
        prompt: LocalizedStringKey = "",
        prefix: Icon.Symbol? = nil,
        suffix: Icon.Symbol? = nil,
        state: InputState = .default,
        labelStyle: InputLabelStyle = .default,
        isSecure: Bool = false,
        passwordStrength: PasswordStrengthIndicator.PasswordStrength? = nil,
        message: Message? = nil,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        labelComment: StaticString? = nil
    ) {
        self.init(
            value: value,
            state: state,
            labelStyle: labelStyle,
            isSecure: isSecure,
            passwordStrength: passwordStrength,
            message: message
        ) {
            Text(label, tableName: tableName, bundle: bundle)
        } prompt: {
            Text(prompt, tableName: tableName, bundle: bundle)
        } prefix: {
            Icon(prefix)
        } suffix: {
            Icon(suffix)
        }
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let inputField                   = Self(rawValue: "orbit.inputfield")
    static let inputFieldPrefix             = Self(rawValue: "orbit.inputfield.prefix")
    static let inputFieldSuffix             = Self(rawValue: "orbit.inputfield.suffix")
    static let inputFieldPasswordToggle     = Self(rawValue: "orbit.inputfield.password.toggle")
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
                InputField(label, value: state, prompt: prompt, prefix: .grid, suffix: .grid, state: .default)
            }
            StateWrapper("") { state in
                InputField(label, value: state, prompt: prompt, prefix: .grid, suffix: .grid, state: .default)
            }
            StateWrapper(value) { state in
                InputField("Secure", value: state, prompt: prompt, prefix: .grid, state: .default, isSecure: true)
            }
            StateWrapper(value) { state in
                InputField("Compact", value: state, prompt: prompt, prefix: .grid, state: .default, labelStyle: .compact)
            }
            StateWrapper("") { state in
                InputField("Compact", value: state, prompt: prompt, prefix: .grid, state: .default, labelStyle: .compact)
            }
            StateWrapper("") { state in
                InputField("Compact", value: state, prompt: prompt, state: .default, labelStyle: .compact)
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
                InputField(label, value: state, prompt: prompt, prefix: .grid, suffix: .grid, state: .default)
            }
            StateWrapper("") { state in
                InputField("Inline", value: state, prompt: prompt, prefix: .grid, suffix: .grid, state: .default, labelStyle: .compact)
            }
            StateWrapper(value) { state in
                InputField("Inline", value: state, prompt: prompt, prefix: .grid, state: .default, labelStyle: .compact)
            }
        }
        .frame(width: 100)
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
                inputField(value: longValue, prefix: .none, suffix: .none, message: .none, labelStyle: .compact)
                inputField(value: "", prefix: .none, suffix: .none, message: .none, labelStyle: .compact)
                inputField(value: "", message: .error(errorMessage), labelStyle: .compact)
                inputField(value: value, message: .error(errorMessage), labelStyle: .compact)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .small) {
            Group {
                inputField("", value: "", message: .none)
                inputField("", value: "", prefix: nil, suffix: nil)
                inputField("", value: "Value", prefix: nil, suffix: nil)
                inputField("", value: "", suffix: nil, prompt: "")
                inputField("", value: "", prefix: nil, suffix: nil, prompt: "")
                inputField("", value: "Password", prefix: nil, suffix: nil, isSecure: true)
                inputField("", value: "Password", prefix: nil, suffix: nil, isSecure: true)
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
            inputField("Empty", value: "", prefix: .grid, suffix: .grid)
                .iconColor(.blueDark)
            StateWrapper(value) { value in
                InputField(value: value) {
                    Text("Disabled, Empty")
                } prefix: {
                    CountryFlag("us")
                } suffix: {
                    CountryFlag("cz")
                }
                .disabled(true)
            }
            inputField("Disabled", value: "Disabled Value", prefix: .informationCircle, suffix: .informationCircle)
                .disabled(true)
            inputField("Modified from previous state", value: "Modified value", state: .modified)
            inputField("Focused", value: "Focused / Help", message: .help("Help message"))
            inputField(
                label,
                value: longValue,
                message: .error(longErrorMessage)
            )
            .textLinkColor(.status(.critical))
            .textAccentColor(.orangeNormal)
            
            inputField("Compact", labelStyle: .compact)

            HStack(spacing: .medium) {
                inputField(value: "No label")

                StateWrapper(value) { value in
                    InputField(value: value) {
                        Text("Flag prefix")
                    } prefix: {
                        CountryFlag("us")
                    } suffix: {
                        EmptyView()
                    }
                }
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func inputField(
        _ label: String = label,
        value: String = value,
        prefix: Icon.Symbol? = .grid,
        suffix: Icon.Symbol? = .grid,
        prompt: String = prompt,
        state: InputState = .default,
        isSecure: Bool = false,
        passwordStrength: PasswordStrengthIndicator.PasswordStrength? = nil,
        message: Message? = nil,
        labelStyle: InputLabelStyle = .default
    ) -> some View {
        StateWrapper(value) { value in
            InputField(
                label,
                value: value,
                prompt: prompt,
                prefix: prefix,
                suffix: suffix,
                state: state,
                labelStyle: labelStyle,
                isSecure: isSecure,
                passwordStrength: passwordStrength,
                message: message
            )
        }
    }
}

struct InputFieldLivePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            InputFieldWrapper()
            securedWrapper
        }
    }
    
    struct InputFieldWrapper: View {

        @State var message: Message? = nil
        @State var textValue = "12"
        @State var intValue = 0

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: .medium) {
                    InputField(value: $textValue, message: message) {
                        Text("InputField")
                    } prompt: {
                        Text("Placeholder")
                    } suffix: {
                        Icon(.email)
                            .onTapGesture {
                                intValue = 1
                            }
                    }
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
