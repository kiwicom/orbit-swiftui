import SwiftUI

public enum CardAction {
    case none
    case buttonLink(_ label: String, action: () -> Void = {}, accessibilityIdentifier: String = "")
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
/// - Related components:
///   - ``Accordion``
///   - ``Tile``, ``TileGroup``
///   - ``Collapse``
///   - ``Table``
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
    let content: () -> Content

    public var body: some View {
        VStack(alignment: .leading, spacing: headerSpacing) {
            header

            if isContentEmpty == false {
                VStack(alignment: contentAlignment, spacing: contentSpacing) {
                    content()
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
    }

    @ViewBuilder var header: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: 0) {

                Icon(iconContent, size: .heading(titleStyle))
                    .padding(.trailing, .xSmall)
                
                VStack(alignment: .leading, spacing: .xxSmall) {
                    Heading(title, style: titleStyle)
                    Text(description, color: .inkLight)
                }

                if case .expanding = width {
                    Spacer(minLength: .xxxSmall)
                }

                switch action {
                    case .buttonLink(let label, let action, let accessibilityIdentifier):
                        if label.isEmpty == false {
                            ButtonLink(label, action: action)
                                .accessibility(identifier: accessibilityIdentifier)
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
        content() is EmptyView
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
        iconContent: Icon.Content,
        action: CardAction = .none,
        headerSpacing: CGFloat = .medium,
        borderStyle: TileBorderStyle = .iOS,
        titleStyle: Heading.Style = .title4,
        status: Status? = nil,
        width: ContainerWidth = .expanding(),
        backgroundColor: Color? = .white,
        contentLayout: CardContentLayout = .default(),
        contentAlignment: HorizontalAlignment = .leading,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = iconContent
        self.action = action
        self.headerSpacing = headerSpacing
        self.borderStyle = borderStyle
        self.titleStyle = titleStyle
        self.status = status
        self.width = width
        self.backgroundColor = backgroundColor
        self.contentLayout = contentLayout
        self.contentAlignment = contentAlignment
        self.content = { content() }
    }

    /// Creates Orbit Card wrapper component with empty content.
    init(
        _ title: String = "",
        description: String = "",
        iconContent: Icon.Content,
        action: CardAction = .none,
        headerSpacing: CGFloat = .medium,
        borderStyle: TileBorderStyle = .iOS,
        titleStyle: Heading.Style = .title4,
        status: Status? = nil,
        width: ContainerWidth = .expanding(),
        backgroundColor: Color? = .white
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            iconContent: iconContent,
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
    
    /// Creates Orbit Card wrapper component over a custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        action: CardAction = .none,
        headerSpacing: CGFloat = .medium,
        borderStyle: TileBorderStyle = .iOS,
        titleStyle: Heading.Style = .title4,
        status: Status? = nil,
        width: ContainerWidth = .expanding(),
        backgroundColor: Color? = .white,
        contentLayout: CardContentLayout = .default(),
        contentAlignment: HorizontalAlignment = .leading,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = .icon(icon)
        self.action = action
        self.headerSpacing = headerSpacing
        self.borderStyle = borderStyle
        self.titleStyle = titleStyle
        self.status = status
        self.width = width
        self.backgroundColor = backgroundColor
        self.contentLayout = contentLayout
        self.contentAlignment = contentAlignment
        self.content = { content() }
    }

    /// Creates Orbit Card wrapper component with empty content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        action: CardAction = .none,
        headerSpacing: CGFloat = .medium,
        borderStyle: TileBorderStyle = .iOS,
        titleStyle: Heading.Style = .title4,
        status: Status? = nil,
        width: ContainerWidth = .expanding(),
        backgroundColor: Color? = .white
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
            backgroundColor: backgroundColor
        ) { EmptyView() }
    }
}

// MARK: - Previews
struct CardPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            standaloneIntrinsic
            standaloneIos
            
            snapshots
            snapshotsDefault
            snapshotsBorderless
            snapshotsBorderlessRegular
            snapshotsBorderlessRegularNarrow

            content
                .frame(width: Layout.readableMaxWidth + 100)
                .environment(\.horizontalSizeClass, .regular)
                .previewDisplayName("Regular wide")

            content
                .frame(width: Layout.readableMaxWidth - 5)
                .environment(\.horizontalSizeClass, .regular)
                .previewDisplayName("Regular narrow")
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Card("Card title", description: "Card description", icon: .baggageSet, action: .buttonLink("ButtonLink"), borderStyle: .default) {
            customContentPlaceholder
            customContentPlaceholder
        }
        .padding()
        .background(Color.cloudLight)
        .previewDisplayName("Standalone")
    }
    
    static var standaloneIntrinsic: some View {
        Card("Card title", description: "Card description", icon: .baggageSet, borderStyle: .default, width: .intrinsic) {
            Text("Card Content")
        }
        .padding()
        .background(Color.cloudLight)
        .previewDisplayName("Standalone Intrinsic width")
    }
    
    static var standaloneIos: some View {
        Card("Card title", description: "Card description", icon: .baggageSet, action: .buttonLink("ButtonLink")) {
            customContentPlaceholder
            customContentPlaceholder
        }
        .padding(.vertical)
        .background(Color.cloudLight)
        .previewDisplayName("Standalone (iOS)")
    }

    static var orbit: some View {
        VStack(spacing: .large) {
            Heading("iOS compact Card", style: .title2)
            cardContent
            Heading("Regular sized Card", style: .title2)
            cardContent
                .environment(\.horizontalSizeClass, .regular)
        }
        .padding(.vertical, .small)
        .previewDisplayName("Figma")
    }

    static var snapshots: some View {
        content
    }
    
    static var snapshotsDefault: some View {
        contentDefault
    }
    
    static var snapshotsBorderless: some View {
        listChoiceGroupsBorderless
            .background(Color.cloudLight)
            .previewDisplayName("Style - Borderless")
    }

    static var snapshotsBorderlessRegular: some View {
        listChoiceGroupsBorderless
            .background(Color.cloudLight)
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: Layout.readableMaxWidth + 100)
            .previewDisplayName("Style - Borderless Regular")
    }

    static var snapshotsBorderlessRegularNarrow: some View {
        listChoiceGroupsBorderless
            .background(Color.cloudLight)
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: Layout.readableMaxWidth - 8)
            .previewDisplayName("Style - Borderless Regular narrow")
    }

    static var content: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Card("Card title", description: "Card description", icon: .baggageSet, action: .buttonLink("ButtonLink")) {
                customContentPlaceholder
                Tile("Tile")
                TileGroup(width: .intrinsic) {
                    Tile("Tile in TileGroup", border: .separator)
                    Tile("Tile in TileGroup", border: .none)
                }
                ListChoice("ListChoice")
                customContentPlaceholder
            }
            
            Card("Card without content", action: .buttonLink("Edit"))

            Card() {
                customContentPlaceholder
                customContentPlaceholder
            }

            Card("Card with custom spacing and padding", action: .buttonLink("ButtonLink"), contentLayout: .custom(padding: 0, spacing: .xxSmall)) {
                customContentPlaceholder
                customContentPlaceholder
            }

            Card(contentLayout: .custom(padding: 0, spacing: .xxSmall)) {
                customContentPlaceholder
                customContentPlaceholder
            }

            cardContent
        }
        .padding(.vertical)
        .background(Color.cloudLight)
    }
    
    static var contentDefault: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Card("Card title", description: "Card description", icon: .baggageSet, action: .buttonLink("ButtonLink"), borderStyle: .default) {
                customContentPlaceholder
                customContentPlaceholder
            }
            
            Card("Card without content", action: .buttonLink("Edit"), borderStyle: .default)
            
            Card(borderStyle: .default) {
                customContentPlaceholder
                customContentPlaceholder
            }
            
            Card("Card with custom spacing and padding", action: .buttonLink("ButtonLink"), headerSpacing: .xxLarge, borderStyle: .default, contentLayout: .custom(padding: .xxSmall, spacing: .small)) {
                customContentPlaceholder
                customContentPlaceholder
            }
            
            Card(borderStyle: .default, contentLayout: .custom(padding: 0, spacing: .xxSmall)) {
                customContentPlaceholder
                customContentPlaceholder
            }
            
            Card(
                "Very very very long and multi-line title",
                description: "Very very very very very long and multi-line description",
                icon: .grid,
                action: .buttonLink("Update"),
                borderStyle: .default,
                status: .critical
            ) {
                customContentPlaceholder
            }
        }
        .padding()
        .background(Color.cloudLight)
    }

    static var cardContent: some View {
        Card(
            "Very very very long and multi-line title",
            description: "Very very very very very long and multi-line description",
            action: .buttonLink("Update"),
            status: .critical
        ) {
            customContentPlaceholder
        }
    }
    
    static var listChoiceGroupsBorderless: some View {
        Card(
            "Card with ListChoices",
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
    }
}
