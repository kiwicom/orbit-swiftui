import SwiftUI
import Orbit

struct StorybookSelect {

    static let label = "Field label"
    static let longLabel = "Very \(String(repeating: "very ", count: 8))long multiline label"
    static let fieldLongLabel = """
        <strong>Label</strong> with a \(String(repeating: "very ", count: 20))long \
        <ref>multiline</ref> label and <applink1>TextLink</applink1>
        """
    static let placeholder = "Placeholder"
    static let value = "Value"
    static let helpMessage = "Help message"
    static let errorMessage = "Error message"

    static var basic: some View {
        VStack(spacing: .medium) {
            select(value: "")
            select(value: "", message: .help(helpMessage))
            select(value: "", message: .error(errorMessage))
            Separator()
            select(value: value)
            select(value: value, message: .help(helpMessage))
            select(value: value, message: .error(errorMessage))
        }
    }

    @ViewBuilder static var mix: some View {
        VStack(spacing: .medium) {
            Group {
                Select("Label", value: "Value")
                Select("", prefix: .grid, value: "Value")
                Select("", prefix: .airplane, value: nil, placeholder: "Please select")
                Select("Label (Empty Value)", prefix: .airplane, value: "")
                Select("Label (No Value)", prefix: .airplane, value: nil, placeholder: "Please select")
                Select("Label", prefix: .phone, value: "Value")
                Select("Label", prefix: .countryFlag("us"), value: "Value")
            }

            Group {
                Select("Label (Disabled)", prefix: .airplane, value: "Value", state: .disabled)
                Select(
                    "Label (Disabled)",
                    prefix: .airplane,
                    value: nil,
                    placeholder: "Please select",
                    state: .disabled
                )
                Select("Label (Modified)", prefix: .airplane, value: "Modified Value", state: .modified)
                Select(
                    "Label (Modified)",
                    prefix: .airplane,
                    value: nil,
                    placeholder: "Please select",
                    state: .modified
                )
                Select(
                    "Label (Info)",
                    prefix: .informationCircle,
                    value: "Value",
                    message: .help("Help message, also very long and multi-line to test that it works.")
                )

                Select(
                    fieldLongLabel,
                    labelAccentColor: .orangeNormal,
                    labelLinkColor: .status(.critical),
                    prefix: .image(.orbit(.google)),
                    value: "Bad Value with a very long text that should overflow",
                    message: .error("Error message, but also very long and multi-line to test that it works.")
                )
            }
        }
    }

    static func select(value: String, message: Message? = nil) -> some View {
        Select(label, prefix: .grid, value: value, placeholder: placeholder, message: message)
    }
}

struct StorybookSelectPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookSelect.basic
            StorybookSelect.mix
        }
    }
}
