import SwiftUI
import Orbit

struct StorybookSelect {

    static let label = "Field label"
    static let longLabel = "Very \(String(repeating: "very ", count: 8))long multiline label"
    static let fieldLongLabel = """
        <strong>Label</strong> with a \(String(repeating: "very ", count: 20))long \
        <ref>multiline</ref> label and <applink1>TextLink</applink1>
        """
    static let prompt = "Placeholder"
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
        .previewDisplayName()
    }

    @ViewBuilder static var mix: some View {
        VStack(spacing: .medium) {
            Group {
                Select("Label", value: "Value", action: {})
                Select("", prefix: .grid, value: "Value", action: {})
                Select("", prefix: .airplane, value: nil, prompt: "Please select", action: {})
                Select("Label (Empty Value)", prefix: .airplane, value: "", action: {})
                Select("Label (No Value)", prefix: .airplane, value: nil, prompt: "Please select", action: {})
                Select("Label", prefix: .phone, value: "Value", action: {})
                Select("Label", value: "Value") {
                    // No action
                } prefix: {
                    CountryFlag("us")
                }
            }

            Group {
                Select("Label (Disabled)", prefix: .airplane, value: "Value", action: {})
                    .disabled(true)

                Select(
                    "Label (Disabled)",
                    prefix: .airplane,
                    value: nil,
                    prompt: "Please select",
                    action: {}
                )
                .disabled(true)

                Select("Label (Modified)", prefix: .airplane, value: "Modified Value", state: .modified, action: {})
                Select(
                    "Label (Modified)",
                    prefix: .airplane,
                    value: nil,
                    prompt: "Please select",
                    state: .modified,
                    action: {}
                )
                Select(
                    "Label (Info)",
                    prefix: .informationCircle,
                    value: "Value",
                    message: .help("Help message, also very long and multi-line to test that it works."),
                    action: {}
                )

                Select(
                    fieldLongLabel,
                    prefix: .grid,
                    value: "Bad Value with a very long text that should overflow",
                    message: .error("Error message, but also very long and multi-line to test that it works."),
                    action: {}
                )
                .textLinkColor(.status(.critical))
                .textAccentColor(.orangeNormal)
            }
        }
        .previewDisplayName()
    }

    static func select(value: String, message: Message? = nil) -> some View {
        Select(label, prefix: .grid, value: value, prompt: prompt, message: message, action: {})
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
