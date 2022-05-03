import SwiftUI

struct StorybookIllustrations {

    static var illustrations: [Illustration.Image] {
        Array(Illustration.Image.allCases.dropFirst())
    }

    @ViewBuilder static var storybook: some View {
        content
            .padding(.medium)
    }

    @ViewBuilder static var content: some View {
        if #available(iOS 14, *) {
            LazyVStack(alignment: .leading, spacing: .xSmall) {
                stackContent
            }
        } else {
            VStack(alignment: .leading, spacing: .xSmall) {
                stackContent
            }
        }
    }

    @ViewBuilder static var stackContent: some View {
        ForEach(0 ..< Self.illustrations.count / 2, id: \.self) { rowIndex in
            HStack(alignment: .top, spacing: .xSmall) {
                illustration(Self.illustrations[rowIndex * 2])
                illustration(Self.illustrations[rowIndex * 2 + 1])
            }
        }
    }

    @ViewBuilder static func illustration(_ illustration: Illustration.Image) -> some View {
        VStack(spacing: .xxSmall) {
            Illustration(illustration, layout: .resizeable)
                .frame(height: 150)
            Text(String(describing: illustration).titleCased, size: .small, color: .inkLight, isSelectable: true)
        }
        .padding(.horizontal, .xxSmall)
        .padding(.vertical, .xSmall)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: BorderRadius.default)
                .stroke(Color.cloudDarker, lineWidth: .hairline)
        )
    }
}

struct StorybookIllustrationsPreviews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper {
            StorybookIllustrations.storybook
        }
    }
}
