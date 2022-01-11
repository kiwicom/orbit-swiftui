import SwiftUI

/// Groups actionable content to make it easy to scan.
///
/// Can be used standalone or wrapped inside a ``TileGroup``.

/// - Related components:
///   - ``TileGroup``
///   - ``Card``
///   - ``ChoiceTile``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/tile/)
/// - Important: Component expands horizontally to infinity.
public struct Tile<Content: View>: View {

    let title: String
    let description: String
    let icon: Icon.Symbol
    let disclosure: Disclosure
    let border: Border
    let style: Style
    let status: Status?
    let backgroundColor: BackgroundColor?
    let titleColor: Text.Color
    let descriptionColor: Text.Color
    let iconColor: Color
    let action: () -> Void
    let content: () -> Content

    public var body: some View {
        tileContent
            .tileBorder(style: tileBorderStyle, status: status)
            .accessibility(label: SwiftUI.Text(title))
            .accessibility(hint: SwiftUI.Text(description))
    }

    @ViewBuilder var tileContent: some View {
        switch disclosure {
            case .none, .icon:
                SwiftUI.Button(
                    action: {
                        HapticsProvider.sendHapticFeedback(.light(0.5))
                        action()
                    },
                    label: {
                        buttonContent
                    }
                )
                .buttonStyle(ButtonStyle(backgroundColor: backgroundColor))
            case .buttonLink:
                buttonContent
                    .background(backgroundColor?.normal ?? .white)
        }
    }

    @ViewBuilder var buttonContent: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(alignment: style.iconAlignment, spacing: .small) {
                    Icon(icon, color: iconColor)
                        .alignmentGuide(.firstTextBaseline) { _ in
                            Text.Size.normal.value * 1.25
                        }

                    HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                        VStack(alignment: .leading, spacing: style == .iOS ? .xxxSmall : .xSmall) {
                            Text(title, size: .large, color: titleColor, weight: style.titleWeight)
                            Text(description, size: style.descriptionSize, color: descriptionColor)
                        }
                        .padding(.vertical, style.verticalPadding)

                        Spacer()

                        buttonLink
                            .padding(.trailing, .medium)
                    }
                }
                .padding(.leading, .medium)
                
                content()
            }

            // Provide minimal height (frame(minHeight:) collapses multiline text in snapshots)
            Color.clear
                .frame(width: 0, height: style.minHeight)

            disclosureIcon
                .padding(.trailing, .medium)
        }
        .overlay(separator, alignment: .bottom)
    }

    @ViewBuilder var buttonLink: some View {
        switch disclosure {
            case .none, .icon:
                EmptyView()
            case .buttonLink(let label, let action):
                Spacer(minLength: 0)
                ButtonLink(label, action: action)
                    .padding(.vertical, -.xxxSmall)
        }
    }

    @ViewBuilder var disclosureIcon: some View {
        switch disclosure {
            case .none, .buttonLink:
                EmptyView()
            case .icon(let icon, let color, _):
                Icon(icon, color: color ?? style.defaultDisclosureColor)
                    .padding(.leading, .xSmall)
                    .padding(.trailing, -style.disclosureIconOffset)
        }
    }

    @ViewBuilder var separator: some View {
        if border == .separator {
            switch style {
                case .default:
                    Color.cloudNormal
                        .frame(height: BorderWidth.thin)
                case .iOS:
                    HairlineSeparator()
                        .padding(.leading, separatorPadding)
            }
        }
    }

    var separatorPadding: CGFloat {
        icon == .none ? .medium : .xxxLarge
    }
    
    var tileBorderStyle: TileBorder.Style? {
        border == .default ? style.tileBorderStyle : nil
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
        icon: Icon.Symbol = .none,
        disclosure: Disclosure = .icon(.chevronRight),
        border: Border = .default,
        style: Style = .default,
        status: Status? = nil,
        backgroundColor: BackgroundColor? = nil,
        titleColor: Text.Color = .inkNormal,
        descriptionColor: Text.Color = .inkLight,
        iconColor: Color = .inkNormal,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.disclosure = disclosure
        self.border = border
        self.style = style
        self.status = status
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.descriptionColor = descriptionColor
        self.iconColor = iconColor
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
        icon: Icon.Symbol = .none,
        disclosure: Disclosure = .icon(.chevronRight),
        border: Border = .default,
        style: Style = .default,
        status: Status? = nil,
        backgroundColor: BackgroundColor? = nil,
        titleColor: Text.Color = .inkNormal,
        descriptionColor: Text.Color = .inkLight,
        iconColor: Color = .inkNormal,
        action: @escaping () -> Void = {}
    ) where Content == EmptyView {
        self.init(
            title: title,
            description: description,
            icon: icon,
            disclosure: disclosure,
            border: border,
            style: style,
            status: status,
            backgroundColor: backgroundColor,
            titleColor: titleColor,
            descriptionColor: descriptionColor,
            iconColor: iconColor,
            action: action,
            content: { EmptyView() }
        )
    }
}

// MARK: - Types
public extension Tile {

    typealias BackgroundColor = (normal: Color, active: Color)

    enum Disclosure {
        case none
        /// Icon with optional color override.
        case icon(Icon.Symbol, color: Color? = nil, alignment: VerticalAlignment = .center)
        case buttonLink(_ label: String, action: () -> Void = {})
    }

    enum Style {

        case `default`
        /// A tile style that visually matches the iOS plain table row appearance.
        case iOS

        public var iconAlignment: VerticalAlignment {
            self == .iOS ? .center : .firstTextBaseline
        }

        public var verticalPadding: CGFloat {
            self == .iOS ? .xSmall : .medium
        }

        public var minHeight: CGFloat {
            self == .iOS ? Layout.preferredButtonHeight : 56
        }

        public var titleWeight: Font.Weight {
            self == .iOS ? .regular : .medium
        }

        public var descriptionSize: Text.Size {
            self == .iOS ? .small : .normal
        }

        public var defaultDisclosureColor: Color {
            self == .iOS ? .cloudDarker : .inkLight
        }

        public var disclosureIconOffset: CGFloat {
            self == .iOS ? .xxSmall : 0
        }
        
        public var tileBorderStyle: TileBorder.Style {
            switch self {
                case .default:      return .default
                case .iOS:          return .iOS
            }
        }
    }

    enum Border {
        /// No border or separator applied. For custom usage inside other components.
        case none
        /// Border around the whole tile for standalone usage outside of ``TileGroup``.
        case `default`
        /// Bottom separator only. To be used inside a ``TileGroup``.
        case separator
        /// Error style border.
        case error
    }

    /// Button style wrapper for Tile.
    /// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
    struct ButtonStyle: SwiftUI.ButtonStyle {

        let backgroundColor: BackgroundColor?

        public init(backgroundColor: BackgroundColor? = nil) {
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
                case (.none, true):                         return .cloudLight
                case (.none, false):                        return .white
            }
        }
    }
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
            snapshotsIOS
            snapshotsIOSRegular
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
            Tile("iOS style tile", description: "Description", disclosure: .buttonLink("Edit"), style: .iOS)
            Tile("iOS style tile", description: "Description", icon: .airplane, style: .iOS)
            Tile("iOS style tile", description: "Description", icon: .airplane, style: .iOS, status: .critical)
        }
        .previewDisplayName("Figma")
    }

    static var snapshots: some View {
        VStack(spacing: .large) {
            Tile("Full border")
            Tile("Full border", disclosure: .buttonLink("Edit"), status: .info)
            Tile("Full border", status: .critical)
            
            Tile("Custom Content", disclosure: .none) {
                Color.productLight
                    .frame(height: 60)
                    .overlay(Text("Custom content", color: .inkLight))
            }
            Tile("Custom Content", description: "Description", status: .warning) {
                Color.productLight
                    .frame(height: 60)
                    .overlay(Text("Custom content", color: .inkLight))
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

    static var snapshotsIOS: some View {
        iOSContent
            .padding(.horizontal, -.medium)
            .background(background)
            .previewDisplayName("Style - iOS")
    }

    static var snapshotsIOSRegular: some View {
        iOSContent
            .frame(width: 450)
            .background(background)
            .environment(\.horizontalSizeClass, .regular)
            .previewDisplayName("Style - iOS Regular")
    }

    static var iOSContent: some View {
        VStack(spacing: .large) {
            Tile("Full border", style: .iOS)
            Tile("Full border", disclosure: .buttonLink("Edit"), style: .iOS, status: .info)
            Tile("Full border", style: .iOS, status: .critical)
            Tile("Custom Content", disclosure: .none, style: .iOS) {
                Color.productLight
                    .frame(height: 60)
                    .overlay(Text("Custom content", color: .inkLight))
            }
            Tile("Custom Content", style: .iOS, status: .warning) {
                Color.productLight
                    .frame(height: 60)
                    .overlay(Text("Custom content", color: .inkLight))
            }

            VStack(spacing: 0) {
                Tile(
                    "Bottom separator",
                    description: description,
                    border: .separator,
                    style: .iOS
                )

                Tile(
                    "Bottom separator",
                    description: description,
                    icon: .circle,
                    disclosure: .buttonLink("Edit"),
                    border: .separator,
                    style: .iOS
                )
            }

            Tile(
                "No borders",
                description: description,
                icon: .settings,
                border: .none,
                style: .iOS
            )
        }
        .padding()
    }

    static var background: some View {
        Color.cloudLight.opacity(0.8)
    }
}
