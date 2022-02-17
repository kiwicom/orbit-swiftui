import SwiftUI

public enum CardAction {
    case none
    case buttonLink(_ label: String, action: () -> Void = {}, accessibilityIdentifier: String = "")
}

public enum CardStyle {

    case `default`
    /// A card style that visually matches the iOS plain table section appearance.
    case iOS
    
    public var tileBorderStyle: TileBorderModifier.Style {
        switch self {
            case .default:      return .default
            case .iOS:          return .iOS
        }
    }
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
    let spacing: CGFloat
    let padding: CGFloat
    let alignment: HorizontalAlignment
    let style: CardStyle
    let titleStyle: Header.TitleStyle
    let status: Status?
    let width: ContainerWidth
    let backgroundColor: Color?
    let content: () -> Content

    public var body: some View {
        VStack(alignment: .leading, spacing: .medium) {
            header

            if isContentEmpty == false {
                VStack(alignment: alignment, spacing: spacing) {
                    content()
                }
                .padding(.top, isHeaderEmpty ? padding : 0)
                .padding([.horizontal, .bottom], padding)
            }
        }
        .frame(maxWidth: maxWidth, alignment: .leading)
        .tileBorder(
            style: style.tileBorderStyle,
            status: status,
            backgroundColor: backgroundColor,
            shadow: shadow
        )
        .frame(maxWidth: maxOuterWidth)
        .padding(.horizontal, horizontalPadding)
    }

    @ViewBuilder var header: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: .small) {

                Header(title, description: description, iconContent: iconContent, titleStyle: titleStyle)

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
            .padding(.bottom, isContentEmpty ? .small : 0)
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
}

// MARK: - Inits
public extension Card {
    
    /// Creates Orbit Card wrapper component over a custom content.
    init(
        _ title: String = "",
        description: String = "",
        iconContent: Icon.Content,
        alignment: HorizontalAlignment = .leading,
        action: CardAction = .none,
        spacing: CGFloat = .medium,
        padding: CGFloat = .medium,
        style: CardStyle = .iOS,
        titleStyle: Header.TitleStyle = .title3,
        status: Status? = nil,
        width: ContainerWidth = .expanding(),
        backgroundColor: Color? = .white,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = iconContent
        self.alignment = alignment
        self.action = action
        self.spacing = spacing
        self.padding = padding
        self.style = style
        self.titleStyle = titleStyle
        self.status = status
        self.width = width
        self.backgroundColor = backgroundColor
        self.content = { content() }
    }

    /// Creates Orbit Card wrapper component with empty content.
    init(
        _ title: String = "",
        description: String = "",
        iconContent: Icon.Content,
        alignment: HorizontalAlignment = .leading,
        action: CardAction = .none,
        spacing: CGFloat = .medium,
        padding: CGFloat = .medium,
        style: CardStyle = .iOS,
        titleStyle: Header.TitleStyle = .title3,
        status: Status? = nil,
        width: ContainerWidth = .expanding(),
        backgroundColor: Color? = .white
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            iconContent: iconContent,
            alignment: alignment,
            action: action,
            spacing: spacing,
            padding: padding,
            style: style,
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
        alignment: HorizontalAlignment = .leading,
        action: CardAction = .none,
        spacing: CGFloat = .medium,
        padding: CGFloat = .medium,
        style: CardStyle = .iOS,
        titleStyle: Header.TitleStyle = .title3,
        status: Status? = nil,
        width: ContainerWidth = .expanding(),
        backgroundColor: Color? = .white,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = .icon(icon, size: .header(titleStyle))
        self.alignment = alignment
        self.action = action
        self.spacing = spacing
        self.padding = padding
        self.style = style
        self.titleStyle = titleStyle
        self.status = status
        self.width = width
        self.backgroundColor = backgroundColor
        self.content = { content() }
    }

    /// Creates Orbit Card wrapper component with empty content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        alignment: HorizontalAlignment = .leading,
        action: CardAction = .none,
        spacing: CGFloat = .medium,
        padding: CGFloat = .medium,
        style: CardStyle = .iOS,
        titleStyle: Header.TitleStyle = .title3,
        status: Status? = nil,
        width: ContainerWidth = .expanding(),
        backgroundColor: Color? = .white
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            alignment: alignment,
            action: action,
            spacing: spacing,
            padding: padding,
            style: style,
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
        Card("Card title", description: "Card description", icon: .baggageSet, action: .buttonLink("ButtonLink"), style: .default) {
            customContentPlaceholder
            customContentPlaceholder
        }
        .padding()
        .background(Color.cloudLight)
        .previewDisplayName("Standalone")
    }
    
    static var standaloneIntrinsic: some View {
        Card("Card title", description: "Card description", icon: .baggageSet, style: .default, width: .intrinsic) {
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
                ListChoiceGroup(width: .intrinsic) {
                    ListChoice("ListChoice in ListChoiceGroup")
                    ListChoice("ListChoice in ListChoiceGroup")
                }
                customContentPlaceholder
            }
            
            Card("Card without content", action: .buttonLink("Edit"))

            Card() {
                customContentPlaceholder
                customContentPlaceholder
            }

            Card("Card with custom spacing and padding", action: .buttonLink("ButtonLink"), spacing: .xxSmall, padding: 0) {
                customContentPlaceholder
                customContentPlaceholder
            }

            Card(spacing: .xxSmall, padding: 0) {
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
            Card("Card title", description: "Card description", icon: .baggageSet, action: .buttonLink("ButtonLink"), style: .default) {
                customContentPlaceholder
                customContentPlaceholder
            }
            
            Card("Card without content", action: .buttonLink("Edit"), style: .default)
            
            Card(style: .default) {
                customContentPlaceholder
                customContentPlaceholder
            }
            
            Card("Card with custom spacing and padding", action: .buttonLink("ButtonLink"), spacing: .xxSmall, padding: 0, style: .default) {
                customContentPlaceholder
                customContentPlaceholder
            }
            
            Card(spacing: .xxSmall, padding: 0, style: .default) {
                customContentPlaceholder
                customContentPlaceholder
            }
            
            Card(
                "Very very very long and multi-line title",
                description: "Very very very very very long and multi-line description",
                action: .buttonLink("Update"),
                style: .default,
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
}
