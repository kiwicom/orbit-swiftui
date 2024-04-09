import SwiftUI

/// Orbit component that displays one item in Orbit ``List``.
///
/// A ``ListItem`` consists of a label and icon.
///
/// ```swift
/// List {
///     ListItem("Planes", icon: .airplane)
///     ListItem("Trains")
/// }
/// ```
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/structure/list/)
public struct ListItem<Label: View, Icon: View>: View {

    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.textColor) private var textColor

    private let type: ListItemType
    @ViewBuilder private let label: Label
    @ViewBuilder private let icon: Icon

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
            if icon.isEmpty {
                Orbit.Icon(.placeholder)
                    .opacity(0)
            } else {
                icon
            }

            label
        }
        .textColor(textColor ?? type.textColor)
    }
    
    /// Creates Orbit ``ListItem`` component with custom content.
    public init(
        type: ListItemType = .primary,
        @ViewBuilder label: () -> Label,
        @ViewBuilder icon: () -> Icon
    ) {
        self.type = type
        self.label = label()
        self.icon = icon()
    }
}

// MARK: - Convenience Inits
public extension ListItem where Label == Text, Icon == Orbit.Icon {

    /// Creates Orbit ``ListItem`` component.
    @_disfavoredOverload
    init(
        _ label: some StringProtocol = "",
        icon: Icon.Symbol? = .circleSmall,
        type: ListItemType = .primary
    ) {
        self.init(type: type) {
            Text(label)
        } icon: {
            Icon(icon)
        }
    }
    
    /// Creates Orbit ``ListItem`` component with localizable label.
    @_semantics("swiftui.init_with_localization")
    init(
        _ label: LocalizedStringKey,
        icon: Icon.Symbol? = .circleSmall,
        type: ListItemType = .primary,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil
    ) {
        self.init(type: type) {
            Text(label, tableName: tableName, bundle: bundle)
        } icon: {
            Icon(icon)
        }
    }
}

// MARK: - Types

/// Orbit ``ListItem`` type.
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
            
            ListItem {
                Text("ListItem with SF Symbol")
            } icon: {
                Icon("info.circle.fill")
            }
            
            ListItem {
                Text("ListItem with SF Symbol")
            } icon: {
                Icon("info.circle.fill")
                    .iconColor(.blueDark)
            }
            
            ListItem {
                Text("ListItem with flag")
            } icon: {
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
