import SwiftUI

/// Conctatenates two terms that can be represented as `SwiftUI.Text`
///
/// - Parameters:
///   - left: A content representable as `SwiftUI.Text`
///   - right: A content representable as `SwiftUI.Text`
/// - Returns: A view that is the result of concatenation of text representation of the parameters.
///   if both paramters do not have a text representation, the returning view will produce `EmptyView`, preserving the standard Orbit behavior
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
        Heading("Hanoi ", style: .title1)
            + Icon(.flightReturn, size: .xLarge)
            + Heading(" San Pedro de Alcantara", style: .title1)
            + Icon(countryCode: "us")
            + Icon(sfSymbol: "info.circle", size: .large)
            + Icon(image: .orbit(.navigateClose), baselineOffset: -1)
            + Text(" (Delayed)", size: .xLarge, color: .inkLight)
    }

    static var formatting: some View {
        (
            Icon(.grid, size: .text(.xLarge), color: nil)
            + Text(" Text", size: .xLarge, color: nil)
            + Icon(.informationCircle, size: .large, color: nil, baselineOffset: -1)
            + Icon(sfSymbol: "info.circle.fill", size: .large, color: nil)
            + Text(
                "<ref>Text</ref> with <strong>formatting</strong>",
                size: .small,
                color: nil,
                accentColor: .orangeNormal
            )
            + Icon(.check, size: .small, color: .greenDark)
        )
        .foregroundColor(.blueDark)
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            concatenatedText("Display Title", style: .display)
            concatenatedText("Display Subtitle", style: .displaySubtitle)
            Separator()
                .padding(.vertical, .small)
            concatenatedText("Title 1", style: .title1)
            concatenatedText("Title 2", style: .title2)
            concatenatedText("Title 3", style: .title3)
            concatenatedText("Title 4", style: .title4)
            concatenatedText("Title 5", style: .title5)
            concatenatedText("Title 6", style: .title6)
        }
    }

    static func concatenatedText(_ label: String, style: Heading.Style) -> some View {
        HStack {
            Heading(label, style: style)
                + Icon(.flightReturn, size: .custom(style.size), color: .inkLight)
                + Heading(label, style: style)
                + Text(" and Text", color: nil)
        }
        .foregroundColor(.blueDark)
    }
}

struct TextConcatenationPreviewsDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standaloneLarge
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var standaloneLarge: some View {
        TextConcatenationPreviews.standalone
            .environment(\.sizeCategory, .accessibilityExtraLarge)
            .previewDisplayName("Dynamic type — extra large")
            .previewLayout(.sizeThatFits)
    }
}
