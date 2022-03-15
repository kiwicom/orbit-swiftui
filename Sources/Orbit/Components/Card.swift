import SwiftUI

public enum CardAction {
    case none
    case buttonLink(_ label: String, action: () -> Void = {}, accessibilityIdentifier: String = "")
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
    let borderStyle: TileBorderStyle
    let titleStyle: Label.TitleStyle
    let status: Status?
    let width: ContainerWidth
    let backgroundColor: Color?
    let content: () -> Content

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            if isContentEmpty == false {
                VStack(alignment: alignment, spacing: spacing) {
                    content()
                }
                .padding(padding)
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
            HStack(alignment: .firstTextBaseline, spacing: .small) {

                Label(title, description: description, iconContent: iconContent, titleStyle: titleStyle)

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
        borderStyle: TileBorderStyle = .iOS,
        titleStyle: Label.TitleStyle = .title4,
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
        self.borderStyle = borderStyle
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
        borderStyle: TileBorderStyle = .iOS,
        titleStyle: Label.TitleStyle = .title4,
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
        alignment: HorizontalAlignment = .leading,
        action: CardAction = .none,
        spacing: CGFloat = .medium,
        padding: CGFloat = .medium,
        borderStyle: TileBorderStyle = .iOS,
        titleStyle: Label.TitleStyle = .title4,
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
        self.borderStyle = borderStyle
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
        borderStyle: TileBorderStyle = .iOS,
        titleStyle: Label.TitleStyle = .title4,
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
            Card("Card title", description: "Card description", icon: .baggageSet, action: .buttonLink("ButtonLink"), borderStyle: .default) {
                customContentPlaceholder
                customContentPlaceholder
            }
            
            Card("Card without content", action: .buttonLink("Edit"), borderStyle: .default)
            
            Card(borderStyle: .default) {
                customContentPlaceholder
                customContentPlaceholder
            }
            
            Card("Card with custom spacing and padding", action: .buttonLink("ButtonLink"), spacing: .xxSmall, padding: 0, borderStyle: .default) {
                customContentPlaceholder
                customContentPlaceholder
            }
            
            Card(spacing: .xxSmall, padding: 0, borderStyle: .default) {
                customContentPlaceholder
                customContentPlaceholder
            }
            
            Card(
                "Very very very long and multi-line title",
                description: "Very very very very very long and multi-line description",
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
            "ListChoice group title",
            spacing: 0,
            padding: 0,
            borderStyle: .none,
            backgroundColor: .clear
        ) {
            VStack(spacing: 0) {
                ListChoice("ListChoice")
                ListChoice("ListChoice", icon: .notification)
                ListChoice("ListChoice", description: "ListChoice description", icon: .airplane)
            }
            .padding(.top, .xSmall)
        }
    }
}
