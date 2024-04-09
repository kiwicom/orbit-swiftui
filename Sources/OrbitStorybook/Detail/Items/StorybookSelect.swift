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
                Select("", value: "Value", prefix: .grid, action: {})
                Select("", value: nil, prompt: "Please select", prefix: .airplane, action: {})
                Select("Label (Empty Value)", value: "", prefix: .airplane, action: {})
                Select("Label (No Value)", value: nil, prompt: "Please select", prefix: .airplane, action: {})
                Select("Label", value: "Value", prefix: .phone, action: {})
                
                Select {
                    // No action
                } label: {
                    Text("Label")
                } value: {
                    Text("Value")
                } prefix: {
                    CountryFlag("us")
                }
            }

            Group {
                Select("Label (Disabled)", value: "Value", prefix: .airplane, action: {})
                    .disabled(true)

                Select(
                    "Label (Disabled)",
                    value: nil,
                    prompt: "Please select", 
                    prefix: .airplane,
                    action: {}
                )
                .disabled(true)

                Select("Label (Modified)", value: "Modified Value", prefix: .airplane, state: .modified, action: {})
                Select(
                    "Label (Modified)",
                    value: nil,
                    prompt: "Please select", 
                    prefix: .airplane,
                    state: .modified,
                    action: {}
                )
                Select(
                    "Label (Info)",
                    value: "Value",
                    prefix: .informationCircle,
                    message: .help("Help message, also very long and multi-line to test that it works."),
                    action: {}
                )

                Select(
                    fieldLongLabel,
                    value: "Bad Value with a very long text that should overflow",
                    prefix: .grid,
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
        Select(label, value: value, prompt: prompt, prefix: .grid, message: message, action: {})
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
