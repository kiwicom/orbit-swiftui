import SwiftUI

public enum CardAction {
    case none
    case buttonLink(_ label: String, action: () -> Void = {})
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
        .frame(maxWidth: idealSize.horizontal ? nil : .infinity, alignment: .leading)
        .background(backgroundColor)
        .tileBorder(
            showBorder ? .iOS : .none,
            status: status
        )
        .ignoreScreenLayoutHorizontalPadding()
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder var header: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Icon(content: iconContent, size: .heading(titleStyle))
                    .padding(.trailing, .xSmall)
                    .accessibility(.cardIcon)
                
                VStack(alignment: .leading, spacing: .xxSmall) {
                    Heading(title, style: titleStyle)
                        .accessibility(.cardTitle)
                    Text(description, color: .inkLight)
                        .accessibility(.cardDescription)
                }

                if idealSize.horizontal == false {
                    Spacer(minLength: 0)
                }

                switch action {
                    case .buttonLink(let label, let action):
                        if label.isEmpty == false {
                            ButtonLink(label, action: action)
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

    static var storybook: some View {
        LazyVStack(spacing: .large) {
            standalone
            content
        }
    }

    static var standalone: some View {
        Card("Card title", description: "Card description", icon: .grid, action: .buttonLink("ButtonLink")) {
            contentPlaceholder
            contentPlaceholder
        }
        .previewDisplayName("Standalone")
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
        .previewDisplayName("Standalone Intrinsic width")
    }

    static var cardWithoutContent: some View {
        Card("Card with no content", action: .buttonLink("Edit"))
    }

    static var cardWithFillLayoutContent: some View {
        Card("Card with fill layout content", action: .buttonLink("Edit"), contentLayout: .fill) {
            contentPlaceholder
            Separator()
            contentPlaceholder
        }
    }

    static var cardWithFillLayoutContentNoHeader: some View {
        Card(contentLayout: .fill) {
            contentPlaceholder
            Separator()
            contentPlaceholder
        }
    }

    static var cardWithOnlyCustomContent: some View {
        Card {
            contentPlaceholder
            contentPlaceholder
        }
    }

    static var cardWithTiles: some View {
        Card("Card with mixed content", description: "Card description", icon: .grid, action: .buttonLink("ButtonLink")) {
            contentPlaceholder
                .frame(height: 30).clipped()
            Tile("Tile")

            TileGroup {
                Tile("Tile in TileGroup 1")
                Tile("Tile in TileGroup 2")
            }

            TileGroup {
                Tile("Tile in TileGroup 1 (fixed)")
                Tile("Tile in TileGroup 2 (fixed)")
            }
            .fixedSize(horizontal: true, vertical: false)

            ListChoice("ListChoice 1")
                .padding(.trailing, -.medium)
            ListChoice("ListChoice 2")
                .padding(.trailing, -.medium)
            contentPlaceholder
                .frame(height: 30).clipped()
        }
    }

    static var cardMultilineCritical: some View {
        Card(
            "Card with very very very very very very long and multi-line title",
            description: "Very very very very very long and multi-line description",
            action: .buttonLink("ButtonLink with a long description"),
            status: .critical
        ) {
            contentPlaceholder
        }
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
                ListChoice("ListChoice")
                ListChoice("ListChoice", icon: .countryFlag("us"))
                ListChoice("ListChoice", description: "ListChoice description", icon: .airplane, showSeparator: false)
            }
            .padding(.top, .xSmall)
        }
    }

    static var snapshot: some View {
        standalone
            .screenLayout()
            .background(Color.screen)
    }
}

struct CardDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")

            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        CardPreviews.snapshot
    }
}
