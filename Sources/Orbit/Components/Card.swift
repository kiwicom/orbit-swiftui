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
/// Card uses the same style as ``Tile`` - either Orbit default or an iOS-like style.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/card/)
/// - Important: Expands horizontally up to ``Layout/readableMaxWidth`` by default and then centered. Can be adjusted by `width` property.
public struct Card<Content: View>: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let title: String
    let description: String
    let iconContent: Icon.Content
    let action: CardAction
    let headerSpacing: CGFloat
    let contentLayout: CardContentLayout
    let contentAlignment: HorizontalAlignment
    let borderStyle: TileBorderStyle
    let titleStyle: Heading.Style
    let status: Status?
    let width: ContainerWidth
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
        .frame(maxWidth: maxWidth, alignment: .leading)
        .tileBorder(
            style: borderStyle,
            status: status,
            backgroundColor: backgroundColor,
            shadow: shadow
        )
        .frame(maxWidth: maxOuterWidth)
        .padding(.horizontal, horizontalPadding)
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

                if case .expanding = width {
                    Spacer(minLength: .xxxSmall)
                }

                switch action {
                    case .buttonLink(let label, let action):
                        if label.isEmpty == false {
                            ButtonLink(label, action: action)
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

    var cornerRadius: CGFloat {
        horizontalSizeClass == .regular ? BorderRadius.default : 0
    }
    
    var maxWidth: CGFloat? {
        switch width {
            case .expanding(let upTo, _):   return upTo
            case .intrinsic:                return nil
        }
    }
    
    var maxOuterWidth: CGFloat? {
        switch width {
            case .expanding:                return .infinity
            case .intrinsic:                return nil
        }
    }

    var horizontalPadding: CGFloat {
        guard horizontalSizeClass == .regular else { return 0 }
        
        switch width {
            case .expanding(_, let minimalRegularWidthPadding):     return minimalRegularWidthPadding
            case .intrinsic:                                        return 0
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
    
    var shadow: TileBorderModifier.Shadow {
        status == nil ? .small : .none
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
        borderStyle: TileBorderStyle = .iOS,
        titleStyle: Heading.Style = .title4,
        status: Status? = nil,
        width: ContainerWidth = .expanding(),
        backgroundColor: Color? = .whiteNormal,
        contentLayout: CardContentLayout = .default(),
        contentAlignment: HorizontalAlignment = .leading,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = icon
        self.action = action
        self.headerSpacing = headerSpacing
        self.borderStyle = borderStyle
        self.titleStyle = titleStyle
        self.status = status
        self.width = width
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
        borderStyle: TileBorderStyle = .iOS,
        titleStyle: Heading.Style = .title4,
        status: Status? = nil,
        width: ContainerWidth = .expanding(),
        backgroundColor: Color? = .whiteNormal
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            action: action,
            headerSpacing: headerSpacing,
            borderStyle: borderStyle,
            titleStyle: titleStyle,
            status: status,
            width: width,
            backgroundColor: backgroundColor,
            content: { EmptyView() }
        )
    }
}

// MARK: - Previews
struct CardPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
            borderlessRegular
            borderlessRegularNarrow
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        Group {
            standaloneIos
            standalone
            standaloneIntrinsic
        }
        Group {
            cardWithoutContent
            cardWithFillLayoutContent
            cardWithFillLayoutContentNoHeader
            cardWithOnlyCustomContent
            cardWithCustomPaddingAndSpacing
            cardWithTiles
            cardMultilineCritical
            cardMultilineDefaultCritical
        }
        Group {
            borderless
        }
    }

    static var storybook: some View {
        LazyVStack(spacing: .large) {
            content
        }
        .background(Color.cloudLight)
    }

    static var standalone: some View {
        Card("Card title", description: "Card description", icon: .grid, action: .buttonLink("ButtonLink"), borderStyle: .default) {
            customContentPlaceholder
            customContentPlaceholder
        }
        .padding(.medium)
        .background(Color.cloudLight)
        .previewDisplayName("Standalone")
    }
    
    static var standaloneIntrinsic: some View {
        VStack(spacing: .medium) {
            HStack(spacing: .medium) {
                Card("Card title", description: "Intrinsic width", icon: .grid, borderStyle: .iOS, width: .intrinsic) {
                    Text("Content")
                        .padding(.medium)
                        .background(Color.greenLight)
                }
                Card("Card title", description: "Intrinsic width", icon: .symbol(.grid, color: .greenNormal), borderStyle: .default, width: .intrinsic) {
                    Text("Content")
                        .padding(.medium)
                        .background(Color.greenLight)
                }
            }

            HStack(spacing: .medium) {
                Card("Card with SF Symbol", description: "Intrinsic width", icon: .sfSymbol("info.circle.fill", color: .greenNormal), borderStyle: .iOS, width: .intrinsic) {
                    Text("Content")
                        .padding(.medium)
                        .background(Color.greenLight)
                }
                Card("Card with flag", description: "Intrinsic width", icon: .countryFlag("cz"), borderStyle: .default, width: .intrinsic) {
                    Text("Content")
                        .padding(.medium)
                        .background(Color.greenLight)
                }
            }
        }
        .padding(.medium)
        .background(Color.cloudLight)
        .previewDisplayName("Standalone Intrinsic width")
    }
    
    static var standaloneIos: some View {
        Card("Card title", description: "Card description", icon: .grid, action: .buttonLink("ButtonLink")) {
            customContentPlaceholder
            customContentPlaceholder
        }
        .padding(.vertical, .medium)
        .background(Color.cloudLight)
        .previewDisplayName("Standalone (iOS)")
    }

    static var borderlessRegular: some View {
        borderless
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: Layout.readableMaxWidth + 100)
            .previewDisplayName("Style - Borderless Regular")
    }

    static var borderlessRegularNarrow: some View {
        borderless
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: Layout.readableMaxWidth - 8)
            .previewDisplayName("Style - Borderless Regular narrow")
    }

    static var cardWithoutContent: some View {
        Card("Card with no content", action: .buttonLink("Edit"))
            .padding(.vertical, .medium)
            .background(Color.cloudLight)
    }

    static var cardWithFillLayoutContent: some View {
        Card("Card with fill layout content", action: .buttonLink("Edit"), contentLayout: .fill) {
            customContentPlaceholder
            Separator()
            customContentPlaceholder
        }
        .padding(.vertical, .medium)
        .background(Color.cloudLight)
    }

    static var cardWithFillLayoutContentNoHeader: some View {
        Card(contentLayout: .fill) {
            customContentPlaceholder
            Separator()
            customContentPlaceholder
        }
        .padding(.vertical, .medium)
        .background(Color.cloudLight)
    }

    static var cardWithOnlyCustomContent: some View {
        Card() {
            customContentPlaceholder
            customContentPlaceholder
        }
        .padding(.vertical, .medium)
        .background(Color.cloudLight)
    }

    static var cardWithCustomPaddingAndSpacing: some View {
        Card("Card with custom spacing and padding", action: .buttonLink("ButtonLink"), contentLayout: .custom(padding: .xSmall, spacing: .large)) {
            customContentPlaceholder
            customContentPlaceholder
        }
        .padding(.vertical, .medium)
        .background(Color.cloudLight)
    }

    static var cardWithTiles: some View {
        Card("Card with Tiles", description: "Card description", icon: .grid, action: .buttonLink("ButtonLink")) {
            customContentPlaceholder
                .frame(height: 30).clipped()
            Tile("Tile")
            TileGroup(width: .intrinsic) {
                Tile("Tile in TileGroup 1")
                Tile("Tile in TileGroup 2")
            }
            ListChoice("ListChoice 1")
            ListChoice("ListChoice 2")
            customContentPlaceholder
                .frame(height: 30).clipped()
        }
        .padding(.vertical, .medium)
        .background(Color.cloudLight)
    }

    static var cardMultilineCritical: some View {
        Card(
            "Card with very very very very very very long and multi-line title",
            description: "Very very very very very long and multi-line description",
            action: .buttonLink("ButtonLink with a long description"),
            status: .critical
        ) {
            customContentPlaceholder
        }
        .padding(.vertical, .medium)
        .background(Color.cloudLight)
    }

    static var cardMultilineDefaultCritical: some View {
        Card(
            "Card with very very very very very very long and multi-line title",
            description: "Very very very very very long and multi-line description",
            action: .buttonLink("ButtonLink with a long description"),
            borderStyle: .default,
            status: .critical
        ) {
            customContentPlaceholder
        }
        .padding(.medium)
        .background(Color.cloudLight)
    }
    
    static var borderless: some View {
        Card(
            "Card with no borders",
            headerSpacing: .xSmall,
            borderStyle: .none,
            backgroundColor: .clear,
            contentLayout: .fill
        ) {
            VStack(spacing: 0) {
                ListChoice("ListChoice")
                ListChoice("ListChoice", icon: .countryFlag("us"))
                ListChoice("ListChoice", description: "ListChoice description", icon: .airplane)
            }
            .padding(.top, .xSmall)
        }
        .padding(.vertical, .medium)
        .background(Color.cloudLight)
    }

    static var snapshot: some View {
        standalone
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
        CardPreviews.standalone
    }
}
