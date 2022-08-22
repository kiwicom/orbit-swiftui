import SwiftUI

/// Conctatenates two terms that can represented as `SwiftUI.Text`
/// - Parameters:
///   - left: An entity, usually a view, which content can be represented as `SwiftUI.Text`
///   - right: An entity, usually a view, which content can be represented as `SwiftUI.Text`
/// - Returns: A view that is the result of concatenation of text representation of the parameters.
///   if both paramters do not have a text representation, returns`EmptyView`, preserving the standard Orbit behaviour
@ViewBuilder func +(
    left: SwiftUITextRepresentable,
    right: SwiftUITextRepresentable
) -> some View & SwiftUITextRepresentable {

    // Consecutive if statements will be parced by the compiler as a Tuple<V>,
    // that is straightforward to extend

    if let leftText = left.asText, let rightText = right.asText {
        leftText + rightText
    }

    if let leftText = left.asText, right.asText == nil {
        leftText
    }

    if left.asText == nil, let rightText = right.asText {
        rightText
    }
}

extension TupleView: SwiftUITextRepresentable where T == (SwiftUI.Text?, SwiftUI.Text?, SwiftUI.Text?) {
    public var asText: SwiftUI.Text? {
        value.0 ?? value.1 ?? value.2
    }
}

struct SwiftUITextRepresentableConcatenationPreviews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper {
            VStack(alignment: .leading, spacing: .xSmall) {
                Heading("Prague ", style: .title1)
                    .asText
                Heading("Display Title", style: .display) + Icon(.flightReturn, size: .heading(.display))
                Heading("Display Subtitle", style: .displaySubtitle) + Icon(.flightReturn, size: .heading(.displaySubtitle))
                Separator()
                    .padding(.vertical, .small)
                Heading("Title 1", style: .title1)  + Icon(.flightReturn, size: .heading(.title2))
                Heading("Title 2", style: .title2) + Icon(.flightReturn, size: .heading(.title2))
                Heading("Title 3", style: .title3) + Icon(.flightReturn, size: .heading(.title3))
                Heading("Title 4", style: .title4) + Icon(.flightReturn, size: .heading(.title4))
                Heading("Title 5", style: .title5) + Icon(.flightReturn, size: .heading(.title5))
//                Heading("Title 6", style: .title6) + Icon(.flightReturn, size: .heading(.title6))
            }
        }
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
}
