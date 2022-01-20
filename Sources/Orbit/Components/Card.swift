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
/// - Important: Component expands horizontally to infinity up to a ``Layout/readableMaxWidth``.
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
    let titleStyle: Heading.Style
    let status: Status?
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
        .frame(maxWidth: Layout.readableMaxWidth, alignment: .leading)
        .tileBorder(
            style: style.tileBorderStyle,
            status: status,
            backgroundColor: backgroundColor,
            shadow: shadow
        )
        .frame(maxWidth: .infinity)
        .padding(.horizontal, horizontalPadding)
    }

    @ViewBuilder var header: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: .small) {

                Header(title, description: description, iconContent: iconContent, titleStyle: titleStyle)

                Spacer(minLength: .xxxSmall)

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

    var horizontalPadding: CGFloat {
        horizontalSizeClass == .regular ? .medium : 0
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
        titleStyle: Heading.Style = .title3,
        status: Status? = nil,
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
        titleStyle: Heading.Style = .title3,
        status: Status? = nil,
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
        titleStyle: Heading.Style = .title3,
        status: Status? = nil,
        backgroundColor: Color? = .white,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = .icon(icon, size: .heading(titleStyle))
        self.alignment = alignment
        self.action = action
        self.spacing = spacing
        self.padding = padding
        self.style = style
        self.titleStyle = titleStyle
        self.status = status
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
        titleStyle: Heading.Style = .title3,
        status: Status? = nil,
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
            backgroundColor: backgroundColor
        ) { EmptyView() }
    }
}

// MARK: - Previews
struct CardPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            standaloneIos
            snapshots
            snapshotsDefault

            content
                .frame(width: 800)
                .environment(\.horizontalSizeClass, .regular)
                .previewDisplayName("Regular wide")

            content
                .frame(width: 450)
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
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Standalone")
    }
    
    static var standaloneIos: some View {
        Card("Card title", description: "Card description", icon: .baggageSet, action: .buttonLink("ButtonLink")) {
            customContentPlaceholder
            customContentPlaceholder
        }
        .padding()
        .background(Color.cloudLight)
        .previewLayout(.sizeThatFits)
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
