import SwiftUI

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
    let icon: Icon.Content
    let action: Action
    let spacing: CGFloat
    let padding: CGFloat
    let alignment: HorizontalAlignment
    let style: Style
    let status: Status?
    let backgroundColor: Color?
    let content: Content

    public var body: some View {
        VStack(alignment: .leading, spacing: .medium) {
            header

            if isContentEmpty == false {
                VStack(alignment: alignment, spacing: spacing) {
                    content
                }
                .padding(.top, isHeaderEmpty ? padding : 0)
                .padding([.horizontal, .bottom], padding)
            }
        }
        .frame(maxWidth: Layout.readableMaxWidth, alignment: .leading)
        .tileBorder(style: style.tileBorderStyle, status: status, backgroundColor: backgroundColor)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, horizontalPadding)
    }

    @ViewBuilder var header: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: .small) {

                icon.view(defaultColor: .inkNormal)
                    .alignmentGuide(.firstTextBaseline) { _ in
                        Heading.Style.title3.size * 1.1
                    }

                VStack(alignment: .leading, spacing: .xxxSmall) {
                    Heading(title, style: .title3)
                    Text(description, color: .inkLight)
                }

                Spacer(minLength: .xxxSmall)

                switch action {
                    case .buttonLink(let label, let action):
                        if label.isEmpty == false {
                            ButtonLink(label, action: action)
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
        if case .none = action, case .none = icon, title.isEmpty, description.isEmpty {
            return true
        } else {
            return false
        }
    }

    var isContentEmpty: Bool {
        content is EmptyView
    }
}

// MARK: - Types
public extension Card {
    
    enum Action {
        case none
        case buttonLink(_ label: String, action: () -> Void = {})
    }
    
    enum Style {

        case `default`
        /// A card style that visually matches the iOS plain table section appearance.
        case iOS
        
        public var tileBorderStyle: TileBorder.Style {
            switch self {
                case .default:      return .default
                case .iOS:          return .iOS
            }
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
        alignment: HorizontalAlignment = .leading,
        action: Action = .none,
        spacing: CGFloat = .medium,
        padding: CGFloat = .medium,
        style: Style = .iOS,
        status: Status? = nil,
        backgroundColor: Color = .white,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.alignment = alignment
        self.action = action
        self.spacing = spacing
        self.padding = padding
        self.style = style
        self.status = status
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    /// Creates Orbit Card wrapper component with empty content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        alignment: HorizontalAlignment = .leading,
        action: Action = .none,
        spacing: CGFloat = .medium,
        padding: CGFloat = .medium,
        style: Style = .iOS,
        status: Status? = nil,
        backgroundColor: Color = .white
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
            snapshots
            
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
        Card("Card title", description: "Card description", action: .buttonLink("ButtonLink")) {
            Color.productLight
                .frame(height: 80)
                .overlay(Text("Custom card content", color: .inkLight))
        }
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Standalone")
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

    static var content: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            Card("Card without content", action: .buttonLink("Edit"))

            Card("Title", description: "Description", action: .buttonLink("Edit Passenger")) {
                Text("Card content with a very very very very very very veryvery long text.")
                Badge("Card content", style: .neutral)
            }

            cardContent

            Card {
                Alert("Card content without a header")
            }

            Card(spacing: .medium) {
                Heading("Custom Long Heading", style: .title1)
                Text("Card content with a custom header")
                Alert("Card content alert with a custom header", icon: .informationCircle)
            }
        }
        .padding(.vertical)
        .background(Color.cloudLight)
    }

    static var cardContent: some View {
        Card(
            "Very very very long and multi-line title",
            description: "Very very very very very long and multi-line description",
            action: .buttonLink("Update"),
            status: .critical
        ) {
            Alert("Card content alert")
            Text("Card content with a very very very very very very veryvery long text.")
        }
    }
}
