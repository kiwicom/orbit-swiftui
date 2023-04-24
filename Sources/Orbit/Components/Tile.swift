import SwiftUI

/// Groups actionable content to make it easy to scan.
///
/// Can be used standalone or wrapped inside a ``TileGroup``.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/tile/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct Tile<Content: View>: View {

    @Environment(\.idealSize) private var idealSize
    @Environment(\.isInsideTileGroup) private var isInsideTileGroup
    @Environment(\.isTileSeparatorVisible) private var isTileSeparatorVisible
    @Environment(\.status) private var status

    public let verticalTextPadding: CGFloat = 14 // = 52 height @ normal size

    let title: String
    let description: String
    let icon: Icon.Content?
    let disclosure: TileDisclosure
    let showBorder: Bool
    let backgroundColor: BackgroundColor?
    let titleStyle: Heading.Style
    let descriptionColor: Color
    let action: () -> Void
    @ViewBuilder let content: Content

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.5))
                action()
            },
            label: {
                buttonContent
            }
        )
        .buttonStyle(TileButtonStyle(style: tileBorderStyle, status: status, backgroundColor: backgroundColor))
        .accessibilityElement(children: .ignore)
        .accessibility(label: .init(title))
        .accessibility(hint: .init(description))
        .accessibility(addTraits: .isButton)
    }

    @ViewBuilder var buttonContent: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                header
                content
            }

            if idealSize.horizontal == nil {
                Spacer(minLength: 0)
            }

            TextStrut(.large)
                .padding(.vertical, verticalTextPadding)

            disclosureIcon
                .padding(.trailing, .medium)
        }
        .overlay(customContentButtonLinkOverlay, alignment: .topTrailing)
        .overlay(separator, alignment: .bottom)
    }
    
    @ViewBuilder var header: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .top, spacing: 0) {
                Icon(icon, size: titleStyle.iconSize)
                    .padding(.trailing, .xSmall)
                    .accessibility(.tileIcon)

                VStack(alignment: .leading, spacing: .xxSmall) {
                    Heading(title, style: titleStyle)
                        .accessibility(.tileTitle)

                    Text(description)
                        .textColor(descriptionColor)
                        .accessibility(.tileDescription)
                }

                if idealSize.horizontal == nil {
                    Spacer(minLength: 0)
                }

                inactiveButtonLink
            }
            .padding(.vertical, verticalTextPadding)
            .padding(.horizontal, .medium)
        }
    }

    @ViewBuilder var customContentButtonLinkOverlay: some View {
        if isHeaderEmpty {
            inactiveButtonLink
                .padding(.medium)
        }
    }

    @ViewBuilder var inactiveButtonLink: some View {
        switch disclosure {
            case .none, .icon:
                EmptyView()
            case .buttonLink(let label, let style):
                ButtonLink(label, style: style, action: {})
                    .textColor(nil)
                    .disabled(true)
                    .padding(.vertical, -.xxxSmall)
                    .accessibility(.tileDisclosureButtonLink)
        }
    }

    @ViewBuilder var disclosureIcon: some View {
        switch disclosure {
            case .none, .buttonLink:
                EmptyView()
            case .icon(let icon, _):
                Icon(icon)
                    .iconColor(.inkNormal)
                    .padding(.leading, .xSmall)
                    .accessibility(.tileDisclosureIcon)
        }
    }

    @ViewBuilder var separator: some View {
        if isInsideTileGroup, isTileSeparatorVisible {
            Separator()
                .padding(.leading, .medium)
        }
    }

    var separatorPadding: CGFloat {
        isIconEmpty ? .medium : .xxxLarge
    }
    
    var tileBorderStyle: TileBorderStyle {
        showBorder && isInsideTileGroup == false ? .default : .none
    }
    
    var isHeaderEmpty: Bool {
        title.isEmpty && description.isEmpty && isIconEmpty
    }

    var isIconEmpty: Bool {
        icon?.isEmpty ?? true
    }
}

// MARK: - Inits
public extension Tile {
    
    /// Creates Orbit Tile component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content? = nil,
        disclosure: TileDisclosure = .icon(.chevronForward),
        showBorder: Bool = true,
        backgroundColor: BackgroundColor? = nil,
        titleStyle: Heading.Style = .title4,
        descriptionColor: Color = .inkNormal,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.disclosure = disclosure
        self.showBorder = showBorder
        self.backgroundColor = backgroundColor
        self.titleStyle = titleStyle
        self.descriptionColor = descriptionColor
        self.action = action
        self.content = content()
    }
}

// MARK: - Modifiers
public extension Tile {

    /// Sets the visibility of the separator associated with this tile.
    ///
    /// Only applies if the tile is contained in a ``TileGroup``.
    ///
    /// - Parameter isVisible: Whether the separator is visible or not.
    func tileSeparator(_ isVisible: Bool) -> some View {
        self
            .environment(\.isTileSeparatorVisible, isVisible)
    }
}

// MARK: - Types

public extension Tile {

    typealias BackgroundColor = (normal: Color, active: Color)
}

/// Button style wrapper for Tile-like components.
///
/// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
public struct TileButtonStyle: SwiftUI.ButtonStyle {

    let style: TileBorderStyle
    let isSelected: Bool
    let status: Status?
    let backgroundColor: Tile.BackgroundColor?

    /// Creates button style wrapper for Tile-like components.
    public init(style: TileBorderStyle = .default, isSelected: Bool = false, status: Status? = nil, backgroundColor: Tile.BackgroundColor? = nil) {
        self.style = style
        self.isSelected = isSelected
        self.status = status
        self.backgroundColor = backgroundColor
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundColor(isPressed: configuration.isPressed))
            .tileBorder(
                style,
                isSelected: isSelected
            )
            .status(status)
    }

    func backgroundColor(isPressed: Bool) -> Color {
        switch (backgroundColor, isPressed) {
            case (let backgroundColor?, true):          return backgroundColor.active
            case (let backgroundColor?, false):         return backgroundColor.normal
            case (.none, true):                         return .whiteHover
            case (.none, false):                        return .whiteDarker
        }
    }
}

public enum TileDisclosure: Equatable {
    case none
    /// Icon with optional color override.
    case icon(Icon.Content, alignment: VerticalAlignment = .center)
    /// ButtonLink indicator.
    case buttonLink(_ label: String, style: ButtonLink.Style = .primary)
}

// MARK: - Identifiers
public extension AccessibilityID {

    static let tileTitle                    = Self(rawValue: "orbit.tile.title")
    static let tileIcon                     = Self(rawValue: "orbit.tile.icon")
    static let tileDescription              = Self(rawValue: "orbit.tile.description")
    static let tileDisclosureButtonLink     = Self(rawValue: "orbit.tile.disclosure.buttonlink")
    static let tileDisclosureIcon           = Self(rawValue: "orbit.tile.disclosure.icon")
}

// MARK: - Previews
struct TilePreviews: PreviewProvider {

    static let title = "Title"
    static let description = "Description"
    static let descriptionMultiline = """
        Description with <strong>very</strong> <ref>very</ref> <u>very</u> long multiline \
        description and <u>formatting</u> with <applink1>links</applink1>
        """

    static var previews: some View {
        PreviewWrapper {
            standalone
            idealSize
            sizing
            tiles
            mix
            customContentMix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: .medium) {
            Tile(title, description: description, icon: .grid, action: {})
            Tile(title, description: description, icon: .grid, action: {}) {
                contentPlaceholder
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var idealSize: some View {
        Tile(title, description: description, icon: .grid, action: {})
            .idealSize()
            .padding(.medium)
            .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            Group {
                Tile("Tile", description: description, icon: .grid, action: {})
                Tile("Tile", icon: .grid, action: {})
                Tile(icon: .grid, action: {})
                Tile(description: "Tile", icon: .grid, action: {})
                Tile(description: "Tile", disclosure: .none, action: {})
                Tile("Tile", action: {})
            }
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var tiles: some View {
        VStack(spacing: .large) {
            Tile(title, action: {})
            Tile(title, icon: .airplane, action: {})
            Tile(title, description: description, action: {})
            Tile(title, description: description, icon: .airplane, action: {})
            Tile(action: {}) {
                contentPlaceholder
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var mix: some View {
        VStack(spacing: .large) {
            Tile("Title with very very very very very long multiline text", description: descriptionMultiline, icon: .airplane, action: {}) {
                contentPlaceholder
            }
            Tile(title, description: description, icon: .symbol(.airplane, color: .blueNormal), action: {})
                .status(.info)
            Tile("SF Symbol", description: description, icon: .sfSymbol("info.circle.fill"), action: {})
                .status(.critical)
            Tile("Country Flag", description: description, icon: .countryFlag("cz"), disclosure: .buttonLink("Action", style: .primary), action: {})
            Tile(title, description: description, icon: .airplane, disclosure: .buttonLink("Action", style: .critical), action: {})
            Tile(title, description: description, icon: .airplane, disclosure: .icon(.grid), action: {})
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var customContentMix: some View {
        VStack(spacing: .large) {
            Tile(disclosure: .none, action: {}) {
                contentPlaceholder
            }
            Tile(disclosure: .buttonLink("Action", style: .critical), action: {}) {
                contentPlaceholder
            }
            Tile(action: {}) {
                contentPlaceholder
            }
            Tile("Tile with custom content", disclosure: .buttonLink("Action", style: .critical), action: {}) {
                contentPlaceholder
            }
            Tile(
                "Tile with no border",
                description: descriptionMultiline,
                icon: .grid,
                showBorder: false,
                action: {}
            )
        }
        .padding(.medium)
        .previewDisplayName()
    }
}
