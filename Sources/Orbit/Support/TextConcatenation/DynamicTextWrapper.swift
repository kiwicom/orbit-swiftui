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
    func swiftUITextContent(configuration: ContentSizeCategory) -> SwiftUI.Text? {
        content(configuration)
    }
}

extension DynamicTextWrapper {
    init(_ swiftUITextRepresentable: SwiftUITextRepresentable) {
        if let swiftUITextRepresentable = swiftUITextRepresentable as? DynamicTextWrapper {
            self = swiftUITextRepresentable
        } else {
            self.init(content: swiftUITextRepresentable.swiftUITextContent(configuration:))
        }
    }
}


func +(left: DynamicTextWrapper, right: DynamicTextWrapper) -> DynamicTextWrapper {
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
