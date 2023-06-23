import SwiftUI

/// One item in Orbit List component.
///
/// - Related components
///   - ``List``
///
/// - [Orbit](https://orbit.kiwi/components/structure/list/)
public struct ListItem<Icon: View>: View {

    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.textColor) private var textColor

    private let text: String
    private let type: ListItemType
    @ViewBuilder private let icon: Icon

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
            if icon.isEmpty {
                Orbit.Icon(.placeholder)
                    .opacity(0)
            } else {
                icon
            }

            Text(text)
        }
        .textColor(textColor ?? type.textColor)
    }
}

// MARK: - Inits
public extension ListItem {

    /// Creates Orbit ListItem component.
    init(
        _ text: String = "",
        icon: Icon.Symbol? = .circleSmall,
        type: ListItemType = .primary
    ) where Icon == Orbit.Icon {
        self.init(
            text,
            type: type
        ) {
            Icon(icon)
        }
    }

    /// Creates Orbit ListItem component.
    init(
        _ text: String = "",
        type: ListItemType = .primary,
        @ViewBuilder icon: () -> Icon
    ) {
        self.text = text
        self.type = type
        self.icon = icon()
    }
}

// MARK: - Types

public enum ListItemType {

    case primary
    case secondary

    public var textColor: Color {
        switch self {
            case .primary:                  return .inkDark
            case .secondary:                return .inkNormal
        }
    }

    public var weight: Font.Weight {
        switch self {
            case .primary:                  return .regular
            case .secondary:                return .regular
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
            ListItem("ListItem - small", type: .primary)
                .textSize(.small)
            ListItem("ListItem - small, secondary", type: .secondary)
                .textSize(.small)
            ListItem("ListItem - normal")
            ListItem("ListItem - normal, secondary", type: .secondary)
            ListItem("ListItem - large", type: .primary)
                .textSize(.large)
            ListItem("ListItem - large, secondary", type: .secondary)
                .textSize(.large)
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var links: some View {
        List {
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, type: .secondary)
                .textSize(.small)
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#)
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#)
                .textColor(.greenNormal)
                .textLinkColor(.custom(.orangeDark))
            ListItem(#"ListItem containing <a href="link">TextLink</a> or <a href="link">Two</a>"#, icon: .circleSmall)
                .iconColor(.blueNormal)
                .textColor(.greenNormal)
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var mix: some View {
        List {
            ListItem("ListItem")
                .textSize(.xLarge)
            ListItem("ListItem with custom icon", icon: .check)
                .textSize(.xLarge)
                .textColor(.greenNormal)
            ListItem("ListItem")
            ListItem("ListItem with custom icon", icon: .check)
                .textColor(.greenNormal)
            ListItem("ListItem with SF Symbol") {
                Icon("info.circle.fill")
            }
            ListItem("ListItem with SF Symbol") {
                Icon("info.circle.fill")
                    .iconColor(.blueDark)
            }
            ListItem("ListItem with flag") {
                CountryFlag("cz")
            }
            ListItem("ListItem with custom icon")
                .textColor(.blueDark)
            ListItem("ListItem with no icon", icon: .none)
        }
        .padding(.medium)
        .previewDisplayName()
    }
}
