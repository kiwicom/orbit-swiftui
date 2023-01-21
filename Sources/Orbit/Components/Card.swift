import SwiftUI

public enum CardAction {
    case none
    case buttonLink(_ label: String, style: ButtonLink.Style = .primary, action: () -> Void)
}

/// Specifies the padding and spacing behavior of Card content.
public enum CardContentLayout {
    /// Content fills all available space with no padding or spacing.
    case fill
    /// Content with `.medium` padding and overridable spacing.
    case `default`(spacing: CGFloat = .medium)
    /// Content with custom padding and spacing.
    case custom(padding: CGFloat, spacing: CGFloat)
}

/// Separates content into sections.
///
/// Card is a wrapping component around a custom content.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/card/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct Card<Content: View>: View {

    @Environment(\.idealSize) var idealSize

    let title: String
    let description: String
    let iconContent: Icon.Content
    let action: CardAction
    let headerSpacing: CGFloat
    let contentLayout: CardContentLayout
    let contentAlignment: HorizontalAlignment
    let showBorder: Bool
    let titleStyle: Heading.Style
    let status: Status?
    let backgroundColor: Color?
    @ViewBuilder let content: Content

    public var body: some View {
        VStack(alignment: .leading, spacing: headerSpacing) {
            header

            if isContentEmpty == false {
                VStack(alignment: contentAlignment, spacing: contentSpacing) {
                    content
                }
                .padding(.top, isHeaderEmpty ? contentPadding : 0)
                .padding([.horizontal, .bottom], contentPadding)
            }
        }
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .leading)
        .background(backgroundColor)
        .tileBorder(
            showBorder ? .iOS : .none,
            status: status
        )
        .ignoreScreenLayoutHorizontalPadding(limitToSizeClass: .compact)
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder var header: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .top, spacing: 0) {
                Icon(content: iconContent, size: titleStyle.iconSize)
                    .padding(.trailing, .xSmall)
                    .accessibility(.cardIcon)
                
                VStack(alignment: .leading, spacing: .xxSmall) {
                    Heading(title, style: titleStyle)
                        .accessibility(.cardTitle)
                    Text(description, color: .inkNormal)
                        .accessibility(.cardDescription)
                }

                if idealSize.horizontal == nil {
                    Spacer(minLength: 0)
                }

                switch action {
                    case .buttonLink(let label, let style, let action):
                        if label.isEmpty == false {
                            ButtonLink(label, style: style, action: action)
                                .padding(.leading, .xxxSmall)
                                .accessibility(.cardActionButtonLink)
                        }
                    case .none:
                        EmptyView()
                }
            }
            .padding([.horizontal, .top], .medium)
            .padding(.bottom, isContentEmpty ? .medium : 0)
        }
    }

    var isHeaderEmpty: Bool {
        if case .none = action, iconContent.isEmpty, title.isEmpty, description.isEmpty {
            return true
        } else {
            return false
        }
    }

    var isContentEmpty: Bool {
        content is EmptyView
    }
    
    var contentPadding: CGFloat {
        switch contentLayout {
            case .fill:                         return 0
            case .default:                      return .medium
            case .custom(let padding, _):       return padding
        }
    }
    
    var contentSpacing: CGFloat {
        switch contentLayout {
            case .fill:                         return 0
            case .default(let spacing):         return spacing
            case .custom(_, let spacing):       return spacing
        }
    }
}

// MARK: - Inits
public extension Card {
    
    /// Creates Orbit Card wrapper component over a custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        action: CardAction = .none,
        headerSpacing: CGFloat = .medium,
        showBorder: Bool = true,
        titleStyle: Heading.Style = .title4,
        status: Status? = nil,
        backgroundColor: Color? = .whiteDarker,
        contentLayout: CardContentLayout = .default(),
        contentAlignment: HorizontalAlignment = .leading,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = icon
        self.action = action
        self.headerSpacing = headerSpacing
        self.showBorder = showBorder
        self.titleStyle = titleStyle
        self.status = status
        self.backgroundColor = backgroundColor
        self.contentLayout = contentLayout
        self.contentAlignment = contentAlignment
        self.content = content()
    }

    /// Creates Orbit Card wrapper component with empty content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        action: CardAction = .none,
        headerSpacing: CGFloat = .medium,
        showBorder: Bool = true,
        titleStyle: Heading.Style = .title4,
        status: Status? = nil,
        backgroundColor: Color? = .whiteDarker
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            action: action,
            headerSpacing: headerSpacing,
            showBorder: showBorder,
            titleStyle: titleStyle,
            status: status,
            backgroundColor: backgroundColor,
            content: { EmptyView() }
        )
    }
}

// MARK: - Identifiers
public extension AccessibilityID {

    static let cardTitle                = Self(rawValue: "orbit.card.title")
    static let cardIcon                 = Self(rawValue: "orbit.card.icon")
    static let cardDescription          = Self(rawValue: "orbit.card.description")
    static let cardActionButtonLink     = Self(rawValue: "orbit.card.action.buttonLink")
}

// MARK: - Previews
struct CardPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
                .screenLayout()

            content
                .screenLayout()

            standaloneIntrinsic
                .padding(.medium)
        }
        .background(Color.screen)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        cardWithoutContent
        cardWithFillLayoutContent
        cardWithFillLayoutContentNoHeader
        cardWithOnlyCustomContent
        cardWithTiles
        cardMultilineCritical
        clear
    }

    static var standalone: some View {
        Card("Card title", description: "Card description", icon: .grid, action: .buttonLink("ButtonLink", action: {})) {
            contentPlaceholder
            contentPlaceholder
        }
        .previewDisplayName()
    }
    
    static var standaloneIntrinsic: some View {
        HStack(spacing: .medium) {
            Card("Card", description: "Intrinsic", icon: .grid) {
                intrinsicContentPlaceholder
            }
            .idealSize(horizontal: true, vertical: false)

            Card("Card with SF Symbol", description: "Intrinsic", icon: .sfSymbol("info.circle.fill", color: .greenNormal)) {
                intrinsicContentPlaceholder
            }
            .idealSize(horizontal: true, vertical: false)

            Spacer()
        }
        .previewDisplayName()
    }

    static var cardWithoutContent: some View {
        Card("Card with no content", action: .buttonLink("Edit", style: .critical, action: {}))
            .previewDisplayName()
    }

    static var cardWithFillLayoutContent: some View {
        Card("Card with fill layout content", action: .buttonLink("Edit", style: .status(.info), action: {}), contentLayout: .fill) {
            contentPlaceholder
            Separator()
            contentPlaceholder
        }
        .previewDisplayName()
    }

    static var cardWithFillLayoutContentNoHeader: some View {
        Card(contentLayout: .fill) {
            contentPlaceholder
            Separator()
            contentPlaceholder
        }
        .previewDisplayName()
    }

    static var cardWithOnlyCustomContent: some View {
        Card {
            contentPlaceholder
            contentPlaceholder
        }
        .previewDisplayName()
    }

    static var cardWithTiles: some View {
        Card("Card with mixed content", description: "Card description", icon: .grid, action: .buttonLink("ButtonLink", action: {})) {
            contentPlaceholder
                .frame(height: 30).clipped()
            Tile("Tile", action: {})

            TileGroup {
                Tile("Tile in TileGroup 1", action: {})
                Tile("Tile in TileGroup 2", action: {})
            }

            TileGroup {
                Tile("Tile in TileGroup 1 (fixed)", action: {})
                Tile("Tile in TileGroup 2 (fixed)", action: {})
            }
            .fixedSize(horizontal: true, vertical: false)

            ListChoice("ListChoice 1", action: {})
                .padding(.trailing, -.medium)
            ListChoice("ListChoice 2", action: {})
                .padding(.trailing, -.medium)
            contentPlaceholder
                .frame(height: 30).clipped()
        }
        .previewDisplayName()
    }

    static var cardMultilineCritical: some View {
        Card(
            "Card with very very very very very very long and multi-line title",
            description: "Very very very very very long and multi-line description",
            action: .buttonLink("ButtonLink with a long description", action: {}),
            status: .critical
        ) {
            contentPlaceholder
        }
        .previewDisplayName()
    }
    
    static var clear: some View {
        Card(
            "Card without borders and background",
            headerSpacing: .xSmall,
            showBorder: false,
            backgroundColor: .clear,
            contentLayout: .fill
        ) {
            VStack(spacing: 0) {
                ListChoice("ListChoice", action: {})
                ListChoice("ListChoice", icon: .countryFlag("us"), action: {})
                ListChoice("ListChoice", description: "ListChoice description", icon: .airplane, showSeparator: false, action: {})
            }
            .padding(.top, .xSmall)
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        standalone
            .screenLayout()
            .background(Color.screen)
    }
}
