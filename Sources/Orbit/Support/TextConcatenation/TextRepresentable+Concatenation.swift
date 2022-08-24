import SwiftUI

/// Conctatenates two terms that can be represented as `SwiftUI.Text`
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
            snpashot
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        (Heading("Hanoi ", style: .title1)
             + Icon(.flightReturn, size: .xLarge)
             + Heading(" San Pedro de Alcantara", style: .title1))
        .lineLimit(2)
    }
    static var snpashot: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            Heading("Display Title", style: .display) + Icon(.flightReturn, size: .heading(.display))
            Heading("Display Subtitle", style: .displaySubtitle) + Icon(.flightReturn, size: .heading(.displaySubtitle))
            Separator()
                .padding(.vertical, .small)
            Heading("Title 1 ", style: .title1)  + Icon(.flightReturn, size: .heading(.title1))
            Heading("Title 2 ", style: .title2) + Icon(.flightReturn, size: .heading(.title2))
            Heading("Title 3 ", style: .title3) + Icon(.flightReturn, size: .heading(.title3))
            Heading("Title 4 ", style: .title4) + Icon(.flightReturn, size: .heading(.title4))
            Heading("Title 5 ", style: .title5) + Icon(.flightReturn, size: .heading(.title5))
            Heading("Title 6 ", style: .title6) + Icon(.flightReturn, size: .heading(.title6))
        }
    }
}

struct TextConcatenationPreviewsDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standaloneSmall
            standaloneLarge
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var standaloneSmall: some View {
        TextConcatenationPreviews.standalone
            .environment(\.sizeCategory, .extraSmall)
            .previewDisplayName("Dynamic type — extraSmall")
    }

    @ViewBuilder static var standaloneLarge: some View {
        TextConcatenationPreviews.standalone
            .environment(\.sizeCategory, .accessibilityExtraLarge)
            .previewDisplayName("Dynamic type — extra large")
            .previewLayout(.sizeThatFits)
    }
}
