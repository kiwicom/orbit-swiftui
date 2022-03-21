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
    let linkAction: TextLink.Action

    public var body: some View {
        Label(
            text,
            iconContent: iconContent,
            style: .text(size, weight: style.weight, color: style.textColor, linkAction: linkAction),
            spacing: spacing
        )
    }
}

// MARK: - Inits
public extension ListItem {

    /// Creates Orbit ListItem component with custom icon content.
    init(
        _ text: String = "",
        iconContent: Icon.Content,
        size: Text.Size = .normal,
        spacing: CGFloat = .xxSmall,
        style: ListItem.Style = .primary,
        linkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.text = text
        self.iconContent = iconContent
        self.size = size
        self.spacing = spacing
        self.style = style
        self.linkAction = linkAction
    }

    /// Creates Orbit ListItem component.
    init(
        _ text: String = "",
        icon: Icon.Symbol = .circleSmall,
        size: Text.Size = .normal,
        spacing: CGFloat = .xxSmall,
        style: ListItem.Style = .primary,
        linkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.init(
            text,
            iconContent: .icon(icon, color: style.textColor.value),
            size: size,
            spacing: spacing,
            style: style,
            linkAction: linkAction
        )
    }
}

// MARK: - Types
public extension ListItem {

    enum Style {
        case primary
        case secondary
        case custom(color: UIColor = .inkNormal, linkColor: UIColor = TextLink.defaultColor, weight: Font.Weight = .regular)

        public var textColor: Text.Color {
            switch self {
                case .primary:                      return .inkNormal
                case .secondary:                    return .inkLight
                case .custom(let color, _, _):      return .custom(color)
            }
        }
        
        public var linkColor: UIColor {
            switch self {
                case .primary:                      return TextLink.defaultColor
                case .secondary:                    return TextLink.defaultColor
                case .custom(_, let linkColor, _):  return linkColor
            }
        }
        
        public var weight: Font.Weight {
            switch self {
                case .primary:                      return .regular
                case .secondary:                    return .regular
                case .custom(_, _, let weight):     return weight
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
                    icon: .airplane,
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
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, size: .small, style: .secondary)
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, style: .custom(color: .greenNormal))
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, iconContent: .icon(.circleSmall, color: .inkNormal), style: .custom(color: .greenNormal))
        }
        .padding()
        .previewDisplayName("Snapshots - Links")
    }
    
    static var snapshotsCustom: some View {
        List {
            ListItem("ListItem with custom icon", iconContent: .icon(.check, color: .greenNormal))
            ListItem("ListItem with custom icon", iconContent: .icon(.check))
            ListItem("ListItem with custom icon", icon: .check)
            ListItem("ListItem with custom icon", icon: .check, style: .custom(color: .blueDark))
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
