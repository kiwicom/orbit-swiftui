import SwiftUI

/// One item of a list.
///
/// - Related components
///   - ``List``
///
/// - [Orbit](https://orbit.kiwi/components/structure/list/)
public struct ListItem: View {

    let text: String
    let iconContent: Icon.Content
    let size: Text.Size
    let spacing: CGFloat
    let style: ListItem.Style

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: spacing) {
            iconContent.view(defaultColor: style.color)
                .alignmentGuide(.firstTextBaseline) { size in
                    self.size.value * Text.firstBaselineRatio + size.height / 2
                }
                .alignmentGuide(.listAlignment, computeValue: { dimensions in
                    dimensions.width + .xSmall
                })

            Text(text, size: size, color: style.textColor)
        }
    }

    var iconSize: Icon.Size? {
        switch iconContent {
            case .none:                                 return nil
            case .icon(_, size: let size, color: _):    return size
            case .image(_, size: let size, mode: _):    return size
        }
    }
}

// MARK: - Inits
public extension ListItem {

    /// Creates Orbit ListItem component.
    init(
        _ text: String = "",
        iconContent: Icon.Content = .icon(.circleSmall, size: .small),
        size: Text.Size = .normal,
        spacing: CGFloat = .xSmall,
        style: ListItem.Style = .primary
    ) {
        self.text = text
        self.iconContent = iconContent
        self.size = size
        self.spacing = spacing
        self.style = style
    }

    /// Creates Orbit ListItem component.
    init(
        _ text: String = "",
        icon: Icon.Symbol,
        size: Text.Size = .normal,
        spacing: CGFloat = .xSmall,
        style: ListItem.Style = .primary
    ) {
        self.init(
            text,
            iconContent: .icon(icon, size: .small),
            size: size,
            spacing: spacing,
            style: style
        )
    }
}

// MARK: - Types
public extension ListItem {

    enum Style {
        case primary
        case secondary

        public var color: Color {
            switch self {
                case .primary:      return .inkNormal
                case .secondary:    return .inkLight
            }
        }

        public var textColor: Text.Color {
            switch self {
                case .primary:      return .inkNormal
                case .secondary:    return .inkLight
            }
        }
    }
}

// MARK: - Previews
struct ListItemPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshots
            orbit

            List {
                ListItem(
                    "This is just a line",
                    iconContent: .icon(.airplane, size: .small),
                    size: .small,
                    style: .secondary
                )
                Text("Hey \nmultiline")
                Text("Hey \nmultiline 2", size: .large)
            }
            .previewDisplayName("Text Baseline alignment")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        ListItem(
            "This is just a line",
            iconContent: .icon(.airplaneDown, size: .small, color: .blue),
            size: .normal,
            style: .primary
        )
    }

    static var snapshots: some View {
        List(spacing: .medium) {
            ListItem("This is just a normal line")

            ListItem("This is just a normal line", size: .normal, style: .secondary)

            ListItem("This is just a large line", size: .large, style: .primary)

            ListItem("This is just a large line", size: .large, style: .secondary)

            ListItem("This is just a small line", size: .small, style: .primary)

            ListItem("This is just a small line", size: .small, style: .primary)

            ListItem("This is just a line", iconContent: .icon(.airplaneDown, size: .small, color: .blue))

            ListItem("This is just a line without an icon", icon: .none)
        }
        .previewDisplayName("Snapshots")
    }

    static var orbit: some View {
        HStack(alignment: .top, spacing: .medium) {
            List(spacing: .medium) {
                ListItem("This is simple list item", size: .normal, style: .primary)
                ListItem("This is simple list item", size: .large, style: .primary)
            }

            List(spacing: .medium) {
                ListItem("This is simple list item", size: .normal, style: .secondary)
                ListItem("This is simple list item", size: .large, style: .secondary)
            }
        }
        .previewDisplayName("Orbit")
    }
}
