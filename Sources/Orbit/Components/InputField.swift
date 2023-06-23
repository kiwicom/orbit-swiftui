import SwiftUI
import UIKit

/// Also known as textbox. Offers users a simple input for a form.
///
/// When you have additional information or helpful examples, include prompt text to help users along.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/inputfield/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` modifier.
public struct InputField<Prefix: View, Suffix: View>: View, TextFieldBuildable {

    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.inputFieldBeginEditingAction) private var inputFieldBeginEditingAction
    @Environment(\.inputFieldEndEditingAction) private var inputFieldEndEditingAction
    @Environment(\.isEnabled) private var isEnabled

    @State private var isEditing: Bool = false
    @State private var isSecureTextRedacted: Bool = true

    private let label: String
    @Binding private var value: String
    private let prompt: String
    private let state: InputState
    private let labelStyle: InputLabelStyle
    @ViewBuilder private var prefix: Prefix
    @ViewBuilder private var suffix: Suffix

    private let isSecure: Bool
    private let passwordStrength: PasswordStrengthIndicator.PasswordStrength?
    private let message: Message?
    @Binding private var messageHeight: CGFloat

    // Builder properties (keyboard related)
    var autocapitalizationType: UITextAutocapitalizationType = .none
    var isAutocorrectionDisabled: Bool? = false
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
                state: state,
                message: message,
                isEditing: isEditing,
                isPlaceholder: value.isEmpty
            ) {
                HStack(alignment: .firstTextBaseline, spacing: .small) {
                    compactLabel
                    textField
                }
            } prefix: {
                prefix
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
        } footer: {
            if let passwordStrength {
                PasswordStrengthIndicator(passwordStrength: passwordStrength)
                    .padding(.top, .xxSmall)
            }
        }
    }

    @ViewBuilder private var compactLabel: some View {
        FieldLabel(compactFieldLabel)
            .textColor(value.isEmpty ? .inkDark : .inkLight)
            .padding(.leading, prefix.isEmpty ? .small : 0)
    }

    @ViewBuilder private var textField: some View {
        TextField(
            value: $value,
            prompt: prompt,
            isSecureTextEntry: isSecure && isSecureTextRedacted,
            font: .orbit(size: Text.Size.normal.value * sizeCategory.ratio, weight: .regular),
            state: state,
            leadingPadding: textFieldLeadingPadding,
            trailingPadding: textFieldTrailingPadding
        )
        .returnKeyType(returnKeyType)
        .autocorrectionDisabled(isAutocorrectionDisabled)
        .keyboardType(keyboardType)
        .textContentType(textContentType)
        .autocapitalization(autocapitalizationType)
        .shouldDeleteBackwardAction(shouldDeleteBackwardAction)
        .accessibility(label: .init(label))
        .inputFieldBeginEditingAction {
            isEditing = true
            inputFieldBeginEditingAction()
        }
        .inputFieldEndEditingAction {
            isEditing = false
            inputFieldEndEditingAction()
        }
    }

    @ViewBuilder private var secureTextRedactedButton: some View {
        if showSecureTextRedactedButton {
            IconButton(isSecureTextRedacted ? .visibility : .visibilityOff) {
                isSecureTextRedacted.toggle()
            }
        }
    }

    private var fieldLabel: String {
        switch labelStyle {
            case .default:          return label
            case .compact:          return ""
        }
    }

    private var compactFieldLabel: String {
        switch labelStyle {
            case .default:          return ""
            case .compact:          return label
        }
    }

    private var textFieldLeadingPadding: CGFloat {
        prefix.isEmpty && labelStyle == .default
            ? .small
            : 0
    }

    private var textFieldTrailingPadding: CGFloat {
        suffix.isEmpty ? .small : 0
    }

    private var showSecureTextRedactedButton: Bool {
        isSecure && value.description.isEmpty == false && isEnabled
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
        prefix: Icon.Symbol? = nil,
        suffix: Icon.Symbol? = nil,
        prompt: String = "",
        state: InputState = .default,
        labelStyle: InputLabelStyle = .default,
        isSecure: Bool = false,
        passwordStrength: PasswordStrengthIndicator.PasswordStrength? = nil,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0)
    ) where Prefix == Icon, Suffix == Icon {
        self.init(
            label,
            value: value,
            prompt: prompt,
            state: state,
            labelStyle: labelStyle,
            isSecure: isSecure,
            passwordStrength: passwordStrength,
            message: message,
            messageHeight: messageHeight
        ) {
            Icon(prefix)
        } suffix: {
            Icon(suffix)
        }
    }

    /// Creates Orbit InputField component with custom prefix or suffix.
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
        prompt: String = "",
        state: InputState = .default,
        labelStyle: InputLabelStyle = .default,
        isSecure: Bool = false,
        passwordStrength: PasswordStrengthIndicator.PasswordStrength? = nil,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder prefix: () -> Prefix,
        @ViewBuilder suffix: () -> Suffix = { EmptyView() }
    ) {
        self.label = label
        self._value = value
        self.prompt = prompt
        self.state = state
        self.labelStyle = labelStyle
        self.isSecure = isSecure
        self.passwordStrength = passwordStrength
        self.message = message
        self._messageHeight = messageHeight
        self.prefix = prefix()
        self.suffix = suffix()
    }
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
            StateWrapper(value) { state in
                InputField("Compact", value: state, prefix: .grid, prompt: prompt, state: .default, labelStyle: .compact)
            }
            StateWrapper("") { state in
                InputField("Compact", value: state, prefix: .grid, prompt: prompt, state: .default, labelStyle: .compact)
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
                InputField(label, value: state, prefix: .grid, suffix: .grid, prompt: prompt, state: .default)
            }
            StateWrapper("") { state in
                InputField("Inline", value: state, prefix: .grid, suffix: .grid, prompt: prompt, state: .default, labelStyle: .compact)
            }
            StateWrapper(value) { state in
                InputField("Inline", value: state, prefix: .grid, prompt: prompt, state: .default, labelStyle: .compact)
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
                InputField("Disabled, Empty", value: value) {
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
                FieldLabelPreviews.longLabel,
                value: longValue,
                message: .error(longErrorMessage)
            )
            .textLinkColor(.status(.critical))
            .textAccentColor(.orangeNormal)
            
            inputField("Compact", labelStyle: .compact)

            HStack(spacing: .medium) {
                inputField(value: "No label")

                StateWrapper(value) { value in
                    InputField("Flag prefix", value: value) {
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
                prefix: prefix,
                suffix: suffix,
                prompt: prompt,
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
                    InputField("InputField", value: $textValue, prompt: "Placeholder", message: message) {
                        EmptyView()
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
