import SwiftUI

/// Concatenates two terms that can be represented as `SwiftUI.Text`.
///
/// - Parameters:
///   - left: A content representable as `SwiftUI.Text`.
///   - right: A content representable as `SwiftUI.Text`.
/// - Returns: A view that is the result of concatenation of text representation of the parameters. If neither parameter has a text representation, EmptyView will be returned.
@ViewBuilder public func +(
    left: TextRepresentable,
    right: TextRepresentable
) -> some View & TextRepresentable {
    ConcatenatedText(left) + ConcatenatedText(right)
}

struct TextConcatenationPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            formatting
            snapshot
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        (
        Heading("Hanoi ", style: .title1)
            + Icon(.grid, size: .xLarge)
            + Icon(.grid, size: .small)
                .iconColor(.redNormal)
            + Icon(.grid, size: .small)
                .iconColor(.blueDark)
            + Heading(" San Pedro de Alcantara", style: .title1)
                .textColor(.blueNormal)
                .fontWeight(.black)
                .strikethrough()
            + Text(" ")
            + Icon("info.circle", size: .large)
                .iconColor(.blueDark)
            + Text(" (Delayed)", size: .xLarge)
                .textColor(.inkNormal)
        )
        .previewDisplayName()
    }

    static var formatting: some View {
        (
            Icon(.grid, size: .xLarge)
            + Text(" Text ", size: .xLarge)
                .bold()
                .italic()
            + Icon(.informationCircle, size: .large)
                .baselineOffset(-1)
            + Icon("info.circle.fill", size: .large)
            + Text(
                " <ref>Text</ref> with <strong>formatting</strong>",
                size: .small
            )
            + Icon(.check, size: .small)
                .iconColor(.greenDark)
        )
        .textColor(.blueDark)
        .textAccentColor(.orangeNormal)
        .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            concatenatedText("Title 1", style: .title1)
            concatenatedText("Title 2", style: .title2)
            concatenatedText("Title 3", style: .title3)
            concatenatedText("Title 4", style: .title4)
            concatenatedText("Title 5", style: .title5)
            concatenatedText("Title 6", style: .title6)
        }
        .previewDisplayName()
    }

    static func concatenatedText(_ label: String, style: Heading.Style) -> some View {
        HStack {
            Heading(label, style: style)
                .textColor(.inkDark)
                + Icon(.flightReturn, size: .custom(style.size))
                    .iconColor(.inkNormal)
                + Heading(label, style: style)
                    .textColor(.inkDark)
                + Text(" and Text")
        }
        .textColor(.blueDark)
        .previewDisplayName()
    }
}
