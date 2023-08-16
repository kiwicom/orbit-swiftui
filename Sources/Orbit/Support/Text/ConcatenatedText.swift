import SwiftUI

struct ConcatenatedText: View {

    @Environment(\.iconColor) var iconColor
    @Environment(\.iconSize) var iconSize
    @Environment(\.lineSpacing) var lineSpacing
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.textAccentColor) var textAccentColor
    @Environment(\.textColor) var textColor
    @Environment(\.textFontWeight) var textFontWeight
    @Environment(\.textLineHeight) var textLineHeight
    @Environment(\.textSize) var textSize

    let content: (TextRepresentableEnvironment) -> SwiftUI.Text?

    var body: some View {
        if let content = content(textRepresentableEnvironment) {
            content
                .lineSpacing(
                    textRepresentableEnvironment.lineSpacingAdjusted(lineSpacing, lineHeight: textLineHeight, size: textSize)
                )
                .padding(
                    .vertical,
                    textRepresentableEnvironment.lineHeightPadding(lineHeight: textLineHeight, size: textSize)
                )
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    var textRepresentableEnvironment: TextRepresentableEnvironment {
        .init(
            iconColor: iconColor,
            iconSize: iconSize,
            textAccentColor: textAccentColor,
            textColor: textColor,
            textFontWeight: textFontWeight,
            textLineHeight: textLineHeight,
            textSize: textSize,
            sizeCategory: sizeCategory
        )
    }
}

extension ConcatenatedText: TextRepresentable {

    func swiftUIText(textRepresentableEnvironment: TextRepresentableEnvironment) -> SwiftUI.Text? {
        content(textRepresentableEnvironment)
    }
}

extension ConcatenatedText {

    init(_ TextRepresentable: TextRepresentable) {
        if let concatenatedText = TextRepresentable as? ConcatenatedText {
            self = concatenatedText
        } else {
            self.init(content: TextRepresentable.swiftUIText)
        }
    }
}


func +(left: ConcatenatedText, right: ConcatenatedText) -> ConcatenatedText {
    .init { textRepresentableEnvironment in
        transform(
            left: left.content(textRepresentableEnvironment),
            right: right.content(textRepresentableEnvironment)
        )
    }
}

private func transform(left: SwiftUI.Text?, right: SwiftUI.Text?) -> SwiftUI.Text? {
    if let left = left, let right = right {
        return left + right
    }

    if let left = left, right == nil {
        return left
    }

    if left == nil, let right = right {
        return right
    }

    return nil
}
