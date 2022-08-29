import SwiftUI

struct ConcatenatedText: View {
    @Environment(\.sizeCategory) var sizeCategory

    let content: (ContentSizeCategory) -> SwiftUI.Text?

    var body: some View {
        if let content = content(sizeCategory) {
            content
        }
    }
}

extension ConcatenatedText: TextRepresentable {
    func swiftUITextContent(configuration: ContentSizeCategory) -> SwiftUI.Text? {
        content(configuration)
    }
}

extension ConcatenatedText {
    init(_ TextRepresentable: TextRepresentable) {
        if let concatenatedText = TextRepresentable as? ConcatenatedText {
            self = concatenatedText
        } else {
            self.init(content: TextRepresentable.swiftUITextContent(configuration:))
        }
    }
}


func +(left: ConcatenatedText, right: ConcatenatedText) -> ConcatenatedText {
    .init { configration in
        transform(left: left.content(configration), right: right.content(configration))
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
