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
    static let prompt = "Placeholder"
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
        .previewDisplayName()
    }

    static var password: some View {
        VStack(spacing: .medium) {
            inputField(passwordLabel, value: passwordValue, isSecure: true)
            inputField(passwordLabel, value: "", prefix: .none, prompt: "Input password", isSecure: true)
            inputField(passwordLabel, value: passwordValue, suffix: .none, isSecure: true, passwordStrength: .weak(title: "Weak"), message: .error("Error message"))
            inputField(passwordLabel, value: passwordValue, prefix: .none, suffix: .none, isSecure: true, passwordStrength: .medium(title: "Medium"), message: .help("Help message"))
            inputField(passwordLabel, value: passwordValue, isSecure: true, passwordStrength: .strong(title: "Strong"))
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(spacing: .medium) {
            inputField("Empty", value: "", prefix: .grid, suffix: .grid)
                .iconColor(.blueDark)

            StateWrapper("") { value in
                InputField(value: value) {
                    Text("Disabled, Empty")
                } prefix: {
                    CountryFlag("cz")
                } suffix: {
                    CountryFlag("us")
                }
                .disabled(true)
            }

            InputField(value: .constant("Disabled Value")) {
                Text("Disabled")
            } prefix: {
                Icon("info.circle.fill")
            } suffix: {
                Icon("info.circle.fill")
            }
            .disabled(true)

            inputField("Modified from previous state", value: "Modified value", state: .modified)
            inputField("Focused", value: "Focused / Help", message: .help("Help message"))
            inputField(
                fieldLongLabel,
                value: longValue,
                message: .error(longErrorMessage)
            )
            .textLinkColor(.status(.critical))
            .textAccentColor(.orangeNormal)

            inputField("Compact", style: .compact)

            HStack(spacing: .medium) {
                inputField(value: "No label")

                StateWrapper("Flag prefix") { value in
                    InputField(value: value) {
                        CountryFlag("cz")
                    }
                }
            }
        }
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
        style: InputLabelStyle = .default
    ) -> some View {
        StateWrapper(value) { value in
            InputField(
                label,
                value: value,
                prompt: prompt, 
                prefix: prefix,
                suffix: suffix,
                state: state,
                labelStyle: style,
                isSecure: isSecure,
                passwordStrength: passwordStrength,
                message: message
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
