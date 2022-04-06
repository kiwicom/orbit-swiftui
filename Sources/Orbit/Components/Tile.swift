import SwiftUI

/// Button style wrapper for Tile.
/// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
public struct TileButtonStyle: SwiftUI.ButtonStyle {

    let backgroundColor: Tile.BackgroundColor?

    public init(backgroundColor: Tile.BackgroundColor? = nil) {
        self.backgroundColor = backgroundColor
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundColor(isPressed: configuration.isPressed))
    }

    func backgroundColor(isPressed: Bool) -> Color {
        switch (backgroundColor, isPressed) {
            case (let backgroundColor?, true):          return backgroundColor.active
            case (let backgroundColor?, false):         return backgroundColor.normal
            case (.none, true):                         return .whiteHover
            case (.none, false):                        return .white
        }
    }
}

public enum TileDisclosure {
    case none
    /// Icon with optional color override.
    case icon(Icon.Symbol, color: Color? = nil, alignment: VerticalAlignment = .center)
    /// ButtonLink indicator.
    case buttonLink(_ label: String, style: ButtonLink.Style = .primary)
}

public enum TileBorder {
    /// No border or separator applied. For custom usage inside other components.
    case none
    /// Border around the whole tile for standalone usage outside of ``TileGroup``.
    case `default`
    /// Bottom separator only. To be used inside a ``TileGroup``.
    case separator
    /// Error style border.
    case error
}

/// Groups actionable content to make it easy to scan.
///
/// Can be used standalone or wrapped inside a ``TileGroup``.

/// - Related components:
///   - ``TileGroup``
///   - ``Card``
///   - ``ChoiceTile``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/tile/)
/// - Important: Component expands horizontally to infinity up to a ``Layout/readableMaxWidth``.
public struct Tile<Content: View>: View {

    let title: String
    let description: String
    let iconContent: Icon.Content
    let disclosure: TileDisclosure
    let border: TileBorder
    let status: Status?
    let backgroundColor: BackgroundColor?
    let titleStyle: Heading.Style
    let descriptionColor: Text.Color
    let action: () -> Void
    let content: () -> Content

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
        .buttonStyle(TileButtonStyle(backgroundColor: backgroundColor))
        .tileBorder(style: tileBorderStyle, status: status, shadow: shadow)
        .accessibility(label: SwiftUI.Text(title))
        .accessibility(hint: SwiftUI.Text(description))
    }

    @ViewBuilder var buttonContent: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                header
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Strut(56)

            disclosureIcon
                .padding(.trailing, .medium)
        }
        .frame(maxWidth: Layout.readableMaxWidth, alignment: .leading)
        .overlay(separator, alignment: .bottom)
    }
    
    var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            
            Icon(iconContent, size: .heading(titleStyle))
                .padding(.trailing, .xSmall)
            
            VStack(alignment: .labelTextLeading, spacing: .xxSmall) {
                Heading(title, style: titleStyle)
                Text(description, color: .inkLight)
            }
            .padding(.vertical, .medium)

            Spacer(minLength: 0)

            inactiveButtonLink
        }
        .padding(.horizontal, .medium)
    }

    @ViewBuilder var inactiveButtonLink: some View {
        switch disclosure {
            case .none, .icon:
                EmptyView()
            case .buttonLink(let label, let style):
                Spacer(minLength: 0)
                ButtonLink(label, style: style)
                    .disabled(true)
                    .padding(.vertical, -.xxxSmall)
        }
    }

    @ViewBuilder var disclosureIcon: some View {
        switch disclosure {
            case .none, .buttonLink:
                EmptyView()
            case .icon(let icon, let color, _):
                Icon(icon, color: color ?? .inkLight)
                    .padding(.leading, .xSmall)
        }
    }

    @ViewBuilder var separator: some View {
        if border == .separator {
            Color.cloudNormal
                .frame(height: BorderWidth.thin)
        }
    }

    var separatorPadding: CGFloat {
        iconContent.isEmpty ? .medium : .xxxLarge
    }
    
    var tileBorderStyle: TileBorderStyle {
        border == .default ? .default : .none
    }
    
    var isHeaderEmpty: Bool {
        title.isEmpty && description.isEmpty && iconContent.isEmpty
    }
    
    var shadow: TileBorderModifier.Shadow {
        status == nil ? .small : .none
    }
}

// MARK: - Inits
public extension Tile {
    
    /// Creates Orbit Tile component with custom content.
    ///
    /// - Parameters:
    ///   - style: Appearance of tile. Can be styled to match iOS default table row.
    init(
        _ title: String = "",
        description: String = "",
        iconContent: Icon.Content,
        disclosure: TileDisclosure = .icon(.chevronRight),
        border: TileBorder = .default,
        status: Status? = nil,
        backgroundColor: BackgroundColor? = nil,
        titleStyle: Heading.Style = .title4,
        descriptionColor: Text.Color = .inkLight,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = iconContent
        self.disclosure = disclosure
        self.border = border
        self.status = status
        self.backgroundColor = backgroundColor
        self.titleStyle = titleStyle
        self.descriptionColor = descriptionColor
        self.action = action
        self.content = content
    }
    
    /// Creates Orbit Tile component with custom content.
    ///
    /// - Parameters:
    ///   - style: Appearance of tile. Can be styled to match iOS default table row.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        disclosure: TileDisclosure = .icon(.chevronRight),
        border: TileBorder = .default,
        status: Status? = nil,
        backgroundColor: BackgroundColor? = nil,
        titleStyle: Heading.Style = .title4,
        descriptionColor: Text.Color = .inkLight,
        iconColor: Color = .inkNormal,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = .icon(icon, color: iconColor)
        self.disclosure = disclosure
        self.border = border
        self.status = status
        self.backgroundColor = backgroundColor
        self.titleStyle = titleStyle
        self.descriptionColor = descriptionColor
        self.action = action
        self.content = content
    }
    
    /// Creates Orbit Tile component.
    ///
    /// - Parameters:
    ///   - style: Appearance of tile. Can be styled to match iOS default table row.
    init(
        _ title: String = "",
        description: String = "",
        iconContent: Icon.Content,
        disclosure: TileDisclosure = .icon(.chevronRight),
        border: TileBorder = .default,
        status: Status? = nil,
        backgroundColor: BackgroundColor? = nil,
        titleStyle: Heading.Style = .title4,
        descriptionColor: Text.Color = .inkLight,
        action: @escaping () -> Void = {}
    ) where Content == EmptyView {
        self.init(
            title: title,
            description: description,
            iconContent: iconContent,
            disclosure: disclosure,
            border: border,
            status: status,
            backgroundColor: backgroundColor,
            titleStyle: titleStyle,
            descriptionColor: descriptionColor,
            action: action,
            content: { EmptyView() }
        )
    }
    
    /// Creates Orbit Tile component.
    ///
    /// - Parameters:
    ///   - style: Appearance of tile. Can be styled to match iOS default table row.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        disclosure: TileDisclosure = .icon(.chevronRight),
        border: TileBorder = .default,
        status: Status? = nil,
        backgroundColor: BackgroundColor? = nil,
        titleStyle: Heading.Style = .title4,
        descriptionColor: Text.Color = .inkLight,
        iconColor: Color = .inkNormal,
        action: @escaping () -> Void = {}
    ) where Content == EmptyView {
        self.init(
            title: title,
            description: description,
            iconContent: .icon(icon, color: iconColor),
            disclosure: disclosure,
            border: border,
            status: status,
            backgroundColor: backgroundColor,
            titleStyle: titleStyle,
            descriptionColor: descriptionColor,
            action: action,
            content: { EmptyView() }
        )
    }
}

// MARK: - Types
public extension Tile {

    typealias BackgroundColor = (normal: Color, active: Color)
}

// MARK: - Previews
struct TilePreviews: PreviewProvider {

    static let description = """
        Description with <strong>very</strong> <ref>very</ref> <u>very</u> long multiline \
        description and <u>formatting</u> with <applink1>links</applink1>
        """

    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshots
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Tile("Title", description: "Description", icon: .airplane)
            .padding(.medium)
            .previewDisplayName("Standalone")
    }

    static var figma: some View {
        VStack(spacing: .small) {
            standalone        
        }
        .previewDisplayName("Figma")
    }

    static var snapshots: some View {
        VStack(spacing: .large) {
            Tile("Full border")
            
            Tile("Full border", disclosure: .buttonLink("Edit"), status: .info) {
                customContentPlaceholder
            }
            
            Tile("Full border", disclosure: .buttonLink("Edit", style: .critical), status: .critical) {
                customContentPlaceholder
            }
            
            Tile {
                customContentPlaceholder
            }
            Tile(disclosure: .none) {
                customContentPlaceholder
            }
            Tile("Tile with custom content", disclosure: .none) {
                customContentPlaceholder
            }
            Tile("Tile with custom content", description: "Description", status: .warning) {
                customContentPlaceholder
            }
            
            Tile("Tile with HUGE TITLE", description: "Short description", icon: .circle, status: .warning, titleStyle: .title1) {
                customContentPlaceholder
            }

            VStack(spacing: 0) {
                Tile(
                    "Bottom separator",
                    description: description,
                    border: .separator
                )

                Tile(
                    "Bottom separator",
                    description: description,
                    icon: .circle,
                    disclosure: .buttonLink("Edit"),
                    border: .separator
                )
            }

            Tile(
                "No borders",
                description: description,
                icon: .settings,
                border: .none
            )

        }
        .padding()
        .background(background)
        .previewDisplayName("Style - Default")
    }

    static var background: some View {
        Color.cloudLight.opacity(0.8)
    }
}
