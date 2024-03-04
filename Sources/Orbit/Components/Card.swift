import SwiftUI

/// Orbit component that separates content into sections.
///
/// A ``Card`` consists of a title, description, content and optional top-trailing action.
///
/// ```swift
/// Card("Card", description: "Description") {
///     content1
///     content2
/// } action: {
///     ButtonLink("Action") {
///         // Tap action
///     }
/// }
/// ```
/// 
/// ### Customizing appearance
/// 
/// The title color can be modified by ``textColor(_:)`` modifier.
/// The default background can be overridden by ``SwiftUI/View/backgroundStyle(_:)`` modifier.
///
/// ### Layout
///
/// The optional action is aligned to the title using firstTextBaseline alignment 
/// and has a negative vertical padding applied to fit the default ``ButtonLink`` component.
/// 
/// The component adds a `VStack` over provided content.
/// The stack layout can be configured by using  ``SwiftUI/View/cardLayout(_:)`` modifier.
/// The content padding is applied only to horizontal and bottom edges around the content. 
/// The space between header and content is fixed.
///
/// For example, to use the full space provided by card for the content, use ``CardLayout/fill`` layout:
///
/// ```swift
/// Card("Card with fill content layout") {
///     ListChoice("Choice 1") { /* Tap action */ }
///     ListChoice("Choice 2") { /* Tap action */ }
/// }
/// .cardLayout(.fill)
/// ```
///
/// To customize the layout of the content, use custom values for alignment, padding or spacing:
///
/// ```swift
/// Card("Card with custom content layout") {
///     content1
///     content2
/// }
/// .cardLayout(alignment: .center, padding: .xSmall, spacing: .xSmall)
/// ```
///
/// Component expands horizontally unless prevented by native `fixedSize()` or ``idealSize()`` modifier:
///
/// ```swift
/// Card("Narrow Card") {
///     intrinsicContent
/// }
/// .idealSize()
/// ```
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/card/)
/// - Important: Avoid using the component when the content is large and should be embedded in a lazy stack.
public struct Card<Content: View, Action: View>: View {

    @Environment(\.backgroundShape) private var backgroundShape
    @Environment(\.cardLayout) private var cardLayout
    @Environment(\.idealSize) private var idealSize
    @Environment(\.textColor) private var textColor

    private let title: String
    private let description: String
    private let showBorder: Bool
    private let titleStyle: Heading.Style
    @ViewBuilder private let content: Content
    @ViewBuilder private let action: Action

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            if isContentEmpty == false {
                VStack(alignment: cardLayout.alignment, spacing: cardLayout.spacing) {
                    content
                }
                .environment(\.backgroundShape, nil)
                .padding([.horizontal, .bottom], cardLayout.padding)
                .padding(.top, isHeaderEmpty ? cardLayout.padding : 0)
            }
        }
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .leading)
        .background(resolvedBackground)
        .tileBorder(showBorder ? .iOS : .none)
        .ignoreScreenLayoutHorizontalPadding(limitToSizeClass: .compact)
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder private var header: some View {
        if isHeaderEmpty == false {
            VStack(alignment: .leading, spacing: .xxSmall) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Heading(title, style: titleStyle)
                        .textColor(.inkDark)
                        .accessibility(.cardTitle)
                    
                    if title.isEmpty == false {
                        if idealSize.horizontal != true {
                            Spacer(minLength: .small)
                        }
                        
                        topTrailingAction
                    }
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text(description)
                        .textColor(descriptionColor)
                        .accessibility(.cardDescription)
                    
                    if title.isEmpty {
                        if idealSize.horizontal != true {
                            Spacer(minLength: .small)
                        }
                        
                        topTrailingAction
                    }
                }
            }
            .padding(.medium)
        }
    }
    
    @ViewBuilder private var topTrailingAction: some View {
        action
            .buttonSize(.compact)
            // Prevent the default ButtonLink from vertically expanding the header
            .padding(.vertical, -.xSmall)
            .accessibility(.cardAction)
    }
    
    @ViewBuilder private var resolvedBackground: some View {
        if let backgroundShape {
            backgroundShape.inactiveView
        } else {
            Color.whiteDarker
        }
    }
    
    private var descriptionColor: Color? {
        textColor ?? nil
    }

    private var isHeaderEmpty: Bool {
        if action.isEmpty, title.isEmpty, description.isEmpty {
            return true
        } else {
            return false
        }
    }

    private var isContentEmpty: Bool {
        content is EmptyView
    }
}

// MARK: - Inits
public extension Card {

    /// Creates Orbit ``Card`` component.
    init(
        _ title: String = "",
        description: String = "",
        showBorder: Bool = true,
        titleStyle: Heading.Style = .title3,
        @ViewBuilder content: () -> Content,
        @ViewBuilder action: () -> Action = { EmptyView() }
    ) {
        self.title = title
        self.description = description
        self.showBorder = showBorder
        self.titleStyle = titleStyle
        self.content = content()
        self.action = action()
    }
}

// MARK: - Identifiers
public extension AccessibilityID {

    static let cardTitle                = Self(rawValue: "orbit.card.title")
    static let cardDescription          = Self(rawValue: "orbit.card.description")
    static let cardAction               = Self(rawValue: "orbit.card.action")
}

// MARK: - Types

/// The layout of Orbit ``Card`` stack content.
public struct CardLayout {
    
    /// Content layout uses a `VStack` with default `.medium` padding and spacing.
    public static let `default` = Self()
    
    /// Content layout uses a `VStack` with no padding and spacing to fill the content to `Card` edges.
    public static let fill = Self(alignment: .leading, padding: 0, spacing: 0)
    
    var alignment: HorizontalAlignment = .leading
    var padding: CGFloat = .medium
    var spacing: CGFloat = .medium
}

// MARK: - Previews
struct CardPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
                .screenLayout()

            content
                .screenLayout()

            standaloneIdealSize
                .padding(.medium)

            snapshot
        }
        .background(Color.screen)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        cardWithFillLayoutContentNoHeader
        cardWithOnlyCustomContent
        cardWithTiles
        cardMultilineCritical
        clear
    }

    static var standalone: some View {
        VStack(spacing: .medium) {
            Card("Card", description: TilePreviews.descriptionMultiline) {
                contentPlaceholder
                contentPlaceholder
            } action: {
                ButtonLink("ButtonLink", action: {})
            }
            
            Card("Card with filling layout", description: TilePreviews.descriptionMultiline) {
                contentPlaceholder
                contentPlaceholder
            } action: {
                ButtonLink("ButtonLink", action: {})
            }
            .cardLayout(.fill)
            
            Card("Card with no content", description: TilePreviews.descriptionMultiline) {
                EmptyView()
            } action: {
                ButtonLink("Edit", type: .critical, action: {})
            }
            .textColor(.blueDark)
        }
        .previewDisplayName()
    }
    
    static var standaloneIdealSize: some View {
        HStack(spacing: .large) {
            Card("Card", description: "Intrinsic") {
                intrinsicContentPlaceholder
            }

            Spacer(minLength: 0)
        }
        .idealSize()
        .previewDisplayName()
    }

    static var cardWithFillLayoutContentNoHeader: some View {
        Card {
            contentPlaceholder
            contentPlaceholder
        }
        .cardLayout(.fill)
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
        Card("Card with mixed content", description: "Card description") {
            VStack(spacing: .xSmall) {
                contentPlaceholder
                
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
                
                VStack(spacing: 0) {
                    ListChoice("ListChoice 1", action: {})
                    ListChoice("ListChoice 2", action: {})
                }
                .padding(.horizontal, -.medium)
                
                contentPlaceholder
            }
        } action: {
            ButtonLink("ButtonLink", action: {})
        }
        .previewDisplayName()
    }

    static var cardMultilineCritical: some View {
        Card(
            "Card with very very very very very very long and multi-line title",
            description: "Very very very very very long and multi-line description"
        ) {
            contentPlaceholder
        } action: {
            ButtonLink("ButtonLink with a long description", action: {})
        }
        .status(.critical)
        .previewDisplayName()
    }
    
    static var clear: some View {
        Card(
            "Card without borders and background",
            showBorder: false
        ) {
            ListChoice("ListChoice", action: {})
                .backgroundStyle(.blueLight, active: .greenLight)
            ListChoice("ListChoice", icon: .map, action: {})
            ListChoice("ListChoice", description: "ListChoice description", icon: .airplane, showSeparator: false, action: {})
        }
        .cardLayout(.fill)
        .backgroundStyle(.clear)
        .padding(.vertical, -.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var snapshot: some View {
        VStack(spacing: .medium) {
            standalone
            standaloneIdealSize
        }
        .screenLayout()
        .background(Color.screen)
    }
}
