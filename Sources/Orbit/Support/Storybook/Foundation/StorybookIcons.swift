import SwiftUI

struct StorybookIcons {

    static var icons: [Icon.Symbol] { Icon.Symbol.allCases }

    @ViewBuilder static var storybook: some View {
        LazyVStack(alignment: .leading, spacing: .xSmall) {
            stackContent
        }
        .padding(.xSmall)
    }

    @ViewBuilder static var stackContent: some View {
        ForEach(0 ..< Self.icons.count / 3, id: \.self) { rowIndex in
            HStack(alignment: .top, spacing: .xSmall) {
                icon(Self.icons[rowIndex * 3])
                icon(Self.icons[rowIndex * 3 + 1])
                icon(Self.icons[rowIndex * 3 + 2])
            }
        }
    }

    @ViewBuilder static func icon(_ icon: Icon.Symbol) -> some View {
        VStack(spacing: .xxSmall) {
            Icon(icon)
            Text(String(describing: icon).titleCased, size: .custom(10), color: .inkLight, isSelectable: true)
            Text(String(icon.value.unicodeCodePoint), size: .custom(10), isSelectable: true)
                .padding(.horizontal, .xxSmall)
                .padding(.vertical, 1)
                .overlay(
                    Rectangle()
                        .strokeBorder(style: StrokeStyle(lineWidth: .hairline, lineCap: .round, dash: [.xxxSmall]))
                        .foregroundColor(Color.inkLighter)
                )
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

private extension String {

    var unicodeCodePoint: String {
        unicodeScalars.first.map { String($0.value, radix: 16, uppercase: true) } ?? ""
    }
}

struct StorybookIconsPreviews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper {
            StorybookIcons.storybook
        }
    }
}
