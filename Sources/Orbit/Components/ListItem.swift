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
    let linkColor: UIColor
    let linkAction: TextLink.Action

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: spacing) {
            Icon(iconContent)
                .alignmentGuide(.firstTextBaseline) { size in
                    self.size.value * Text.firstBaselineRatio + size.height / 2
                }
                .alignmentGuide(.listAlignment, computeValue: { dimensions in
                    dimensions.width + spacing
                })

            Text(text, size: size, color: style.textColor, linkColor: linkColor, linkAction: linkAction)
        }
    }

    var iconSize: Icon.Size? {
        switch iconContent {
            case .none:                                 return nil
            case .icon(_, let size, _):                 return size
            case .image(_, let size, _):                return size
            case .illustration(_, let size):            return size
            case .countryFlag(_, let size):             return size
            case .sfSymbol(_, let size):                return size
        }
    }
}

// MARK: - Inits
public extension ListItem {

    /// Creates Orbit ListItem component with custom icon content.
    init(
        _ text: String = "",
        iconContent: Icon.Content,
        size: Text.Size = .normal,
        spacing: CGFloat = .xSmall,
        style: ListItem.Style = .primary,
        linkColor: UIColor = .productDark,
        linkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.text = text
        self.iconContent = iconContent
        self.size = size
        self.spacing = spacing
        self.style = style
        self.linkColor = linkColor
        self.linkAction = linkAction
    }

    /// Creates Orbit ListItem component.
    init(
        _ text: String = "",
        icon: Icon.Symbol = .circleSmall,
        size: Text.Size = .normal,
        spacing: CGFloat = .xSmall,
        style: ListItem.Style = .primary,
        linkColor: UIColor = .productDark,
        linkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.init(
            text,
            iconContent: .icon(icon, size: .small, color: style.textColor.value),
            size: size,
            spacing: spacing,
            style: style,
            linkColor: linkColor,
            linkAction: linkAction
        )
    }
}

// MARK: - Types
public extension ListItem {

    enum Style {
        case primary
        case secondary
        case custom(textColor: UIColor)

        public var textColor: Text.Color {
            switch self {
                case .primary:                  return .inkNormal
                case .secondary:                return .inkLight
                case .custom(let textColor):    return .custom(textColor)
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
            snapshotsLinks
            snapshotsCustom
            orbit

            List {
                ListItem(
                    "ListItem",
                    iconContent: .icon(.airplane, size: .small),
                    size: .small,
                    style: .secondary
                )
                Text("Aligned multiline content")
                Text("Aligned multiline content", size: .large)
            }
            .frame(width: 130)
            .padding()
            .previewDisplayName("Text Baseline alignment")
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        ListItem("ListItem")
    }

    static var snapshots: some View {
        List(spacing: .medium) {
            ListItem("ListItem - normal")
            ListItem("ListItem - normal, secondary", size: .normal, style: .secondary)
            ListItem("ListItem - large", size: .large, style: .primary)
            ListItem("ListItem - large, secondary", size: .large, style: .secondary)
            ListItem("ListItem - small", size: .small, style: .primary)
            ListItem("ListItem - small, secondary", size: .small, style: .secondary)
        }
        .padding()
        .previewDisplayName("Snapshots")
    }
    
    static var snapshotsLinks: some View {
        List {
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#)
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, size: .small, style: .secondary, linkColor: .redNormal)
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, style: .custom(textColor: .greenNormal))
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, iconContent: .icon(.circleSmall, size: .small, color: .inkNormal), style: .custom(textColor: .greenNormal))
        }
        .padding()
        .previewDisplayName("Snapshots - Links")
    }
    
    static var snapshotsCustom: some View {
        List {
            ListItem("ListItem with custom icon", iconContent: .icon(.check, size: .small, color: .greenNormal))
            ListItem("ListItem with custom icon", iconContent: .icon(.check, size: .small))
            ListItem("ListItem with custom icon", icon: .check)
            ListItem("ListItem with custom icon", icon: .check, style: .custom(textColor: .blueDark))
            ListItem("ListItem with no icon", icon: .none)
        }
        .padding()
        .previewDisplayName("Snapshots - Custom")
    }

    static var orbit: some View {
        HStack(alignment: .top, spacing: .medium) {
            List(spacing: .medium) {
                ListItem("ListItem - normal", size: .normal, style: .primary)
                ListItem("ListItem - large", size: .large, style: .primary)
            }

            List(spacing: .medium) {
                ListItem("ListItem - normal, secondary", size: .normal, style: .secondary)
                ListItem("ListItem - large, secondary", size: .large, style: .secondary)
            }
        }
        .padding()
        .previewDisplayName("Orbit")
    }
}
