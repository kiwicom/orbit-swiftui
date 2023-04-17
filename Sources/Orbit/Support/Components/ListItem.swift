import SwiftUI

/// One item in Orbit List component.
///
/// - Related components
///   - ``List``
///
/// - [Orbit](https://orbit.kiwi/components/structure/list/)
public struct ListItem: View {

    public static let defaultSpacing: CGFloat = .xSmall

    @Environment(\.sizeCategory) private var sizeCategory

    private let text: String
    private let icon: Icon.Content?
    private let iconSize: Icon.Size?
    private let size: Text.Size
    private let spacing: CGFloat
    private let style: ListItem.Style
    private let isDefault: Bool

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: spacing) {
            Icon(icon, size: iconSize ?? size.iconSize)
                .foregroundColor(style.textColor)
                .padding(.leading, iconPadding)

            Text(text, size: size)
                .foregroundColor(style.textColor)
                .fontWeight(style.weight)
        }
        .padding(.leading, Self.defaultSpacing - spacing)
    }

    var iconPadding: CGFloat {
        guard isDefault else { return 0 }

        return sizeCategory.ratio * size.iconSize.value / 4
    }
}

// MARK: - Inits
public extension ListItem {

    /// Creates Orbit ListItem component using the provided icon.
    init(
        _ text: String = "",
        icon: Icon.Content?,
        size: Text.Size = .normal,
        iconSize: Icon.Size? = nil,
        spacing: CGFloat = .xSmall,
        style: ListItem.Style = .primary
    ) {
        self.text = text
        self.icon = icon
        self.size = size
        self.iconSize = iconSize
        self.spacing = spacing
        self.style = style
        self.isDefault = false
    }

    /// Creates Orbit ListItem component with default appearance, using the `circleSmall` icon.
    init(
        _ text: String = "",
        size: Text.Size = .normal,
        spacing: CGFloat = .xxSmall,
        style: ListItem.Style = .primary
    ) {
        self.text = text
        self.icon = .symbol(.circleSmall)
        self.size = size
        self.iconSize = .custom(size.value)
        self.spacing = spacing
        self.style = style
        self.isDefault = true
    }
}

// MARK: - Types
public extension ListItem {

    enum Style {
        case primary
        case secondary
        case custom(color: Color = .inkDark, weight: Font.Weight = .regular)

        public var textColor: Color {
            switch self {
                case .primary:                  return .inkDark
                case .secondary:                return .inkNormal
                case .custom(let color, _):     return color
            }
        }
        
        public var weight: Font.Weight {
            switch self {
                case .primary:                  return .regular
                case .secondary:                return .regular
                case .custom(_, let weight):    return weight
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
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, style: .custom(color: .greenNormal))
                .textLinkColor(.custom(.orangeDark))
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, icon: .symbol(.circleSmall, color: .blueNormal), style: .custom(color: .greenNormal))
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var mix: some View {
        List {
            ListItem("ListItem", size: .xLarge)
            ListItem("ListItem with custom icon", icon: .symbol(.check, color: .greenNormal), size: .xLarge)
            ListItem("ListItem")
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
