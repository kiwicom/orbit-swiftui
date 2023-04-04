import SwiftUI

struct ConcatenatedText: View {

    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.textAccentColor) var textAccentColor

    let content: (ContentSizeCategory, Color?) -> SwiftUI.Text?

    var body: some View {
        if let content = content(sizeCategory, textAccentColor) {
            content
        }
    }
}

extension ConcatenatedText: TextRepresentable {

    func swiftUIText(sizeCategory: ContentSizeCategory, textAccentColor: Color?) -> SwiftUI.Text? {
        content(sizeCategory, textAccentColor)
    }
}

extension ConcatenatedText {

    init(_ TextRepresentable: TextRepresentable) {
        if let concatenatedText = TextRepresentable as? ConcatenatedText {
            self = concatenatedText
        } else {
            self.init(content: TextRepresentable.swiftUIText(sizeCategory:textAccentColor:))
        }
    }
}


func +(left: ConcatenatedText, right: ConcatenatedText) -> ConcatenatedText {
    .init { sizeCategory, textAccentColor in
        transform(left: left.content(sizeCategory, textAccentColor), right: right.content(sizeCategory, textAccentColor))
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
