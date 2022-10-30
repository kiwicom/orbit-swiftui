import SwiftUI
import Orbit

struct StorybookIcons {

    static var icons: [Icon.Symbol] { Icon.Symbol.allCases.filter { $0 != .none} }

    @ViewBuilder static func storybook(filter: String = "") -> some View {
        LazyVStack(alignment: .leading, spacing: .xSmall) {
            stackContent(filter: filter)
        }
    }

    @ViewBuilder static func stackContent(filter: String) -> some View {
        ForEach(0 ... icons(filter: filter).count / 3, id: \.self) { rowIndex in
            HStack(alignment: .top, spacing: .xSmall) {
                icon(index: rowIndex * 3, filter: filter)
                icon(index: rowIndex * 3 + 1, filter: filter)
                icon(index: rowIndex * 3 + 2, filter: filter)
            }
        }
    }

    @ViewBuilder static func icon(index: Int, filter: String) -> some View {
        if let icon = iconSymbol(index: index, filter: filter) {
            VStack(spacing: .xxSmall) {
                Icon(icon)
                Text(String(describing: icon).titleCased, size: .custom(10), color: .inkNormal, isSelectable: true)
                Text(String(icon.value.unicodeCodePoint), size: .custom(10), isSelectable: true)
                    .padding(.horizontal, .xxSmall)
                    .padding(.vertical, 1)
                    .overlay(
                        Rectangle()
                            .strokeBorder(style: StrokeStyle(lineWidth: .hairline, lineCap: .round, dash: [.xxxSmall]))
                            .foregroundColor(Color.inkLight)
                    )
            }
            .padding(.horizontal, .xxSmall)
            .padding(.vertical, .xSmall)
            .frame(maxWidth: .infinity)
            .background(Color.whiteDarker)
            .tileBorder(.plain)
        } else {
            Color.whiteLighter
                .frame(height: 1)
                .padding(.horizontal, .xxSmall)
                .padding(.vertical, .xSmall)
                .frame(maxWidth: .infinity)
        }
    }

    static func icons(filter: String) -> [Icon.Symbol] {
        icons.filter { filter.isEmpty || "\($0)".localizedCaseInsensitiveContains(filter) }
    }

    static func iconSymbol(index: Int, filter: String) -> Icon.Symbol? {
        let filteredIcons = icons(filter: filter)
        guard filteredIcons.indices.contains(index) else {
            return nil
        }
        return filteredIcons[index]
    }
}

private extension String {

    var unicodeCodePoint: String {
        unicodeScalars.first.map { String($0.value, radix: 16, uppercase: true) } ?? ""
    }
}

struct StorybookIconsPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            ScrollView {
                StorybookIcons.storybook()
            }
        }
    }
}
