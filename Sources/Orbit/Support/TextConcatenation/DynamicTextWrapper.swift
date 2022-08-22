import SwiftUI

struct DynamicTextWrapper: View {
    @Environment(\.sizeCategory) var sizeCategory

    let content: (ContentSizeCategory) -> SwiftUI.Text?

    var body: some View {
        if let content = content(sizeCategory) {
            content
        }
    }
}

extension DynamicTextWrapper: SwiftUITextRepresentable {
    func asText(configuration: ContentSizeCategory) -> SwiftUI.Text? {
        content(configuration)
    }

    var wrapped: DynamicTextWrapper {
        self
    }
}

func +(
    left: DynamicTextWrapper,
    right: DynamicTextWrapper
) -> DynamicTextWrapper {
    .init { configration in
        transform(left: left.content(configration), right: right.content(configration))
    }
}

private func transform(left: SwiftUI.Text?, right: SwiftUI.Text?) -> SwiftUI.Text? {
    left.flatMap { left in right.flatMap { right in left + right } }
}
