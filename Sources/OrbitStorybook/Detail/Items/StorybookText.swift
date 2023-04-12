import SwiftUI
import Orbit

struct StorybookText {

    static let multilineText = "Text with multiline content \n with no formatting or text links"
    static let multilineFormattedText = "Text with <ref>formatting</ref>,<br> <u>multiline</u> content <br> and <a href=\"...\">text link</a>"

    @ViewBuilder static var basic: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Group {
                Text("Plain text with no formatting")
                Text("Selectable text (on long tap)", isSelectable: true)
                Text("Text <u>formatted</u> <strong>and</strong> <ref>accented</ref>")
                    .textAccentColor(.orangeNormal)
                Text("Text with strikethrough and kerning")
                    .strikethrough()
                    .kerning(6)
            }
            .border(Color.cloudDark, width: .hairline)

            Group {
                Text(multilineText)
                    .foregroundColor(.greenDark)
                    .background(Color.greenLight)
                Text(multilineText)
                    .foregroundColor(nil)
                    .foregroundColor(.blueDark)
                    .background(Color.blueLight)
                Text(multilineFormattedText)
                    .foregroundColor(.greenDark)
                    .textAccentColor(.orangeDark)
                    .background(Color.greenLight)
                Text(multilineFormattedText)
                    .foregroundColor(nil)
                    .textAccentColor(.orangeDark)
                    .foregroundColor(.blueDark)
                    .background(Color.blueLight)
            }
            .multilineTextAlignment(.trailing)
        }
        .previewDisplayName()
    }
}

struct StorybookTextPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookText.basic
        }
    }
}
