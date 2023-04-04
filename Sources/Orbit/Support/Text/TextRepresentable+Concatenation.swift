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
            + Heading(" San Pedro de Alcantara", style: .title1)
            + Text(" ")
            + Icon(sfSymbol: "info.circle", size: .large)
            + Icon(image: .orbit(.navigateClose))
                .baselineOffset(-1)
            + Text(" (Delayed)", size: .xLarge)
                .foregroundColor(.inkNormal)
        )
        .previewDisplayName()
    }

    static var formatting: some View {
        (
            Icon(.grid, size: .xLarge, color: nil)
            + Text(" Text ", size: .xLarge)
                .foregroundColor(nil)
                .bold()
                .italic()
            + Icon(.informationCircle, size: .large, color: nil)
                .baselineOffset(-1)
            + Icon(sfSymbol: "info.circle.fill", size: .large, color: nil)
            + Text(
                " <ref>Text</ref> with <strong>formatting</strong>",
                size: .small
            )
            .foregroundColor(nil)
            .textAccentColor(.orangeNormal)

            + Icon(.check, size: .small, color: .greenDark)
        )
        .foregroundColor(.blueDark)
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
                + Icon(.flightReturn, size: .custom(style.size), color: .inkNormal)
                + Heading(label, style: style)
                + Text(" and Text")
                    .foregroundColor(nil)
        }
        .foregroundColor(.blueDark)
        .previewDisplayName()
    }
}
