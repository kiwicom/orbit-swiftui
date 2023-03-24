import SwiftUI

/// One item of a list.
///
/// - Related components
///   - ``List``
///
/// - [Orbit](https://orbit.kiwi/components/structure/list/)
public struct ListItem: View {

    public static let defaultSpacing: CGFloat = .xSmall

    @Environment(\.sizeCategory) var sizeCategory

    let text: String
    let iconContent: Icon.Content
    let iconSize: Icon.Size?
    let size: Text.Size
    let spacing: CGFloat
    let style: ListItem.Style

    public var body: some View {
        HStack(alignment: alignment, spacing: spacing) {
            icon
                .frame(width: dynamicIconSize, height: dynamicIconSize)

            Text(text, size: size, color: nil, weight: style.weight, linkColor: style.linkColor)
        }
        .padding(.leading, Self.defaultSpacing - spacing)
        .foregroundColor(style.textColor.value)
    }

    @ViewBuilder var icon: some View {
        if iconContent.isEmpty {
            Color.clear
        } else {
            Icon(content: iconContent, size: iconSize ?? size.iconSize)
        }
    }

    var dynamicIconSize: CGFloat {
        size.iconSize.value * sizeCategory.ratio
    }

    var alignment: VerticalAlignment {
        iconContent.isEmpty ? .top : .firstTextBaseline
    }
}

// MARK: - Inits
public extension ListItem {

    /// Creates Orbit ListItem component using the provided icon.
    init(
        _ text: String = "",
        icon: Icon.Content,
        size: Text.Size = .normal,
        iconSize: Icon.Size? = nil,
        spacing: CGFloat = .xSmall,
        style: ListItem.Style = .primary
    ) {
        self.text = text
        self.iconContent = icon
        self.size = size
        self.iconSize = iconSize
        self.spacing = spacing
        self.style = style
    }

    /// Creates Orbit ListItem component with default appearance, using the `circleSmall` icon.
    init(
        _ text: String = "",
        size: Text.Size = .normal,
        spacing: CGFloat = .xxxSmall,
        style: ListItem.Style = .primary
    ) {
        self.init(
            text,
            icon: .circleSmall,
            size: size,
            iconSize: .custom(size.value),
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
        case custom(color: UIColor = .inkDark, linkColor: TextLink.Color = .primary, weight: Font.Weight = .regular)

        public var textColor: Text.Color {
            switch self {
                case .primary:                      return .inkDark
                case .secondary:                    return .inkNormal
                case .custom(let color, _, _):      return .custom(color)
            }
        }
        
        public var linkColor: TextLink.Color {
            switch self {
                case .primary:                      return .primary
                case .secondary:                    return .primary
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
            sizes
            links
            mix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        ListItem("ListItem")
            .previewDisplayName()
    }

    static var sizes: some View {
        List(spacing: .medium) {
            ListItem("ListItem - small", size: .small, style: .primary)
            ListItem("ListItem - small, secondary", size: .small, style: .secondary)
            ListItem("ListItem - normal")
            ListItem("ListItem - normal, secondary", size: .normal, style: .secondary)
            ListItem("ListItem - large", size: .large, style: .primary)
            ListItem("ListItem - large, secondary", size: .large, style: .secondary)
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var links: some View {
        List {
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, size: .small, style: .secondary)
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#)
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, style: .custom(color: .greenNormal, linkColor: .custom(.orangeDark)))
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, icon: .symbol(.circleSmall, color: .blueNormal), style: .custom(color: .greenNormal))
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var mix: some View {
        List {
            ListItem("ListItem with custom icon", icon: .symbol(.check, color: .greenNormal))
            ListItem("ListItem with custom icon", icon: .check, spacing: .xxxSmall)
            ListItem("ListItem with SF Symbol", icon: .sfSymbol("info.circle.fill"))
            ListItem("ListItem with SF Symbol", icon: .sfSymbol("info.circle.fill", color: .blueDark))
            ListItem("ListItem with flag", icon: .countryFlag("cz"))
            ListItem("ListItem with custom icon", icon: .check, style: .custom(color: .blueDark))
            ListItem("ListItem with no icon", icon: .none)
        }
        .padding(.medium)
        .previewDisplayName()
    }
}
