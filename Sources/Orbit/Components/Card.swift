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
/// The default background can be overridden by ``backgroundStyle(_:)-9odue`` modifier.
///
/// ### Layout
/// 
/// The component adds a `VStack` with `.medium` spacing between the header and any provided content.
/// The provided content itself is separated by zero spacing.
///
/// The optional action is aligned to the title using firstTextBaseline alignment 
/// and has a negative vertical padding applied to fit the default ``ButtonLink`` component.
///
/// To use the full space provided by card for the content, use zero `contentPadding`. 
/// This padding is applied to horizontal and bottom edges around the whole content:
///
/// ```swift
/// Card("Card with filling content", contentPadding: 0) {
///     content1
///     content2
/// }
/// ```
///
/// To fully customize the layout of content,  use a custom vertical stack and negative paddings:
///
/// ```swift
/// Card("Card with custom content layout") {
///     VStack(alignment: .trailing, spacing: .xSmall) {
///         content1
///         content2
///     }
///     .padding(.top, -.medium)
/// }
/// ```
///
/// Component expands horizontally unless prevented by native `fixedSize()` or ``idealSize()`` modifier:
///
/// ```swift
/// Card("Narrow Card") {
///     IntrinsicContent
/// }
/// .idealSize()
/// ```
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/card/)
/// - Important: Avoid using the component when the content is large and should be embedded in a lazy stack.
public struct Card<Content: View, Action: View>: View {

    @Environment(\.backgroundShape) private var backgroundShape
    @Environment(\.idealSize) private var idealSize

    private let title: String
    private let description: String
    private let contentPadding: CGFloat
    private let showBorder: Bool
    private let titleStyle: Heading.Style
    @ViewBuilder private let content: Content
    @ViewBuilder private let action: Action

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                // Header uses fixed spacing
                .padding(.bottom, isContentEmpty ? 0 : .medium)

            if isContentEmpty == false {
                content
                    .environment(\.backgroundShape, nil)
                    .padding(.horizontal, contentPadding)
            }
        }
        .padding(.top, isHeaderEmpty ? contentPadding : 0)
        .padding(.bottom, isContentEmpty ? 0 : contentPadding)
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .leading)
        .background(resolvedBackground)
        .tileBorder(
            showBorder ? .iOS : .none
        )
        .ignoreScreenLayoutHorizontalPadding(limitToSizeClass: .compact)
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder private var header: some View {
        if isHeaderEmpty == false {
            VStack(alignment: .leading, spacing: .xxSmall) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Heading(title, style: titleStyle)
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
                        .textColor(.inkNormal)
                        .accessibility(.cardDescription)
                    
                    if title.isEmpty {
                        if idealSize.horizontal != true {
                            Spacer(minLength: .small)
                        }
                        
                        topTrailingAction
                    }
                }
            }
            .padding([.horizontal, .top], .medium)
            .padding(.bottom, isContentEmpty ? .medium : 0)
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
        contentPadding: CGFloat = .medium,
        @ViewBuilder content: () -> Content,
        @ViewBuilder action: () -> Action = { EmptyView() }
    ) {
        self.title = title
        self.description = description
        self.showBorder = showBorder
        self.titleStyle = titleStyle
        self.contentPadding = contentPadding
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
            
            Card("Card with custom layout", description: TilePreviews.descriptionMultiline, contentPadding: 0) {
                contentPlaceholder
                contentPlaceholder
            } action: {
                ButtonLink("ButtonLink", action: {})
            }
            
            Card("Card with no content", description: TilePreviews.descriptionMultiline) {
                EmptyView()
            } action: {
                ButtonLink("Edit", type: .critical, action: {})
            }
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
        Card(contentPadding: 0) {
            contentPlaceholder
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
            showBorder: false,
            contentPadding: 0
        ) {
            ListChoice("ListChoice", action: {})
                .backgroundStyle(.blueLight, active: .greenLight)
            ListChoice("ListChoice", icon: .map, action: {})
            ListChoice("ListChoice", description: "ListChoice description", icon: .airplane, showSeparator: false, action: {})
        }
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
