import SwiftUI
import Orbit

struct StorybookInputField {

    static let label = "Field label"
    static let longLabel = "Very \(String(repeating: "very ", count: 8))long multiline label"
    static let fieldLongLabel = """
        <strong>Label</strong> with a \(String(repeating: "very ", count: 20))long \
        <ref>multiline</ref> label and <applink1>TextLink</applink1>
        """
    static let passwordLabel = "Password label"
    static let value = "Value"
    static let passwordValue = "someVeryLongPasswordValue"
    static let longValue = "\(String(repeating: "very ", count: 15))long value"
    static let placeholder = "Placeholder"
    static let helpMessage = "Help message"
    static let errorMessage = "Error message"
    static let longErrorMessage = "Very \(String(repeating: "very ", count: 8))long error message"

    static var basic: some View {
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

    static var password: some View {
        VStack(spacing: .medium) {
            inputField(passwordLabel, value: passwordValue, isSecure: true)
            inputField(passwordLabel, value: "", prefix: .none, placeholder: "Input password", isSecure: true)
            inputField(passwordLabel, value: passwordValue, suffix: .none, isSecure: true, passwordStrength: .weak(title: "Weak"), message: .error("Error message"))
            inputField(passwordLabel, value: passwordValue, prefix: .none, suffix: .none, isSecure: true, passwordStrength: .medium(title: "Medium"), message: .help("Help message"))
            inputField(passwordLabel, value: passwordValue, isSecure: true, passwordStrength: .strong(title: "Strong"))
        }
    }

    static var mix: some View {
        VStack(spacing: .medium) {
            inputField("Empty", value: "", prefix: .symbol(.grid, color: .blueDark), suffix: .symbol(.grid, color: .blueDark))
            inputField("Disabled, Empty", value: "", prefix: .countryFlag("cz"), suffix: .countryFlag("us"), state: .disabled)
            inputField("Disabled", value: "Disabled Value", prefix: .sfSymbol("info.circle.fill"), suffix: .sfSymbol("info.circle.fill"), state: .disabled)
            inputField("Modified from previous state", value: "Modified value", state: .modified)
            inputField("Focused", value: "Focused / Help", message: .help("Help message"))
            inputField(
                fieldLongLabel,
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
}

struct StorybookInputFieldPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookInputField.basic
            StorybookInputField.password
            StorybookInputField.mix
        }
    }
}
