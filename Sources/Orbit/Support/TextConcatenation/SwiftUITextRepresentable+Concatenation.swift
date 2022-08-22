import SwiftUI

/// Conctatenates two terms that can represented as `SwiftUI.Text`
/// - Parameters:
///   - left: An entity, usually a view, which content can be represented as `SwiftUI.Text`
///   - right: An entity, usually a view, which content can be represented as `SwiftUI.Text`
/// - Returns: A view that is the result of concatenation of text representation of the parameters.
///   if both paramters do not have a text representation, the returning view will produce `EmptyView`, preserving the standard Orbit behaviour
@ViewBuilder public func +(
    left: SwiftUITextRepresentable,
    right: SwiftUITextRepresentable
) -> some View & SwiftUITextRepresentable {
    left.wrapped + right.wrapped
}

struct SwiftUITextRepresentableConcatenationPreviews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper {
            VStack(alignment: .leading, spacing: .xSmall) {
                (Heading("Hanoi ", style: .title1)
                     + Icon(.flightReturn, size: .xLarge)
                     + Heading(" San Pedro de Alcantara", style: .title1))
                .lineLimit(2)

                (Icon(.flightReturn, size: .heading(.display)) + Heading("Display Title", style: .display)).lineLimit(0)
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
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
}
