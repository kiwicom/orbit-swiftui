import SwiftUI

/// Button style wrapper for Tile-like components.
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
                style: style,
                isSelected: isSelected,
                status: status,
                backgroundColor: backgroundColor(isPressed: configuration.isPressed),
                shadow: shadow(isPressed: configuration.isPressed))
    }

    func backgroundColor(isPressed: Bool) -> Color {
        switch (backgroundColor, isPressed) {
            case (let backgroundColor?, true):          return backgroundColor.active
            case (let backgroundColor?, false):         return backgroundColor.normal
            case (.none, true):                         return .whiteHover
            case (.none, false):                        return .whiteNormal
        }
    }

    func shadow(isPressed: Bool) -> TileBorderModifier.Shadow {
        isPressed ? .small : .default
    }
}

public enum TileDisclosure {
    case none
    /// Icon with optional color override.
    case icon(Icon.Content, alignment: VerticalAlignment = .center)
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
}

/// Groups actionable content to make it easy to scan.
///
/// Can be used standalone or wrapped inside a ``TileGroup``.
///
/// - Related components:
///   - ``TileGroup``
///   - ``Card``
///   - ``ChoiceTile``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/tile/)
/// - Important: Component expands horizontally to infinity up to a ``Layout/readableMaxWidth``.
public struct Tile<Content: View>: View {

    public let verticalTextPadding: CGFloat = .medium - 1/6    // Makes height exactly 52 at normal text size

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
            .frame(maxWidth: .infinity, alignment: .leading)

            TextStrut(.large)
                .padding(.vertical, verticalTextPadding)

            disclosureIcon
                .padding(.trailing, .medium)
        }
        .frame(maxWidth: Layout.readableMaxWidth, alignment: .leading)
        .overlay(separator, alignment: .bottom)
    }
    
    @ViewBuilder var header: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Icon(content: iconContent, size: .heading(titleStyle))
                    .foregroundColor(.inkNormal)
                    .padding(.trailing, .xSmall)
                    .accessibility(.tileIcon)

                VStack(alignment: .labelTextLeading, spacing: .xxSmall) {
                    Heading(title, style: titleStyle)
                        .accessibility(.tileTitle)
                    Text(description, color: .inkLight)
                        .accessibility(.tileDescription)
                }
                .padding(.vertical, verticalTextPadding)

                Spacer(minLength: 0)

                inactiveButtonLink
            }
            .padding(.horizontal, .medium)
        }
    }

    @ViewBuilder var inactiveButtonLink: some View {
        switch disclosure {
            case .none, .icon:
                EmptyView()
            case .buttonLink(let label, let style):
                ButtonLink(label, style: style)
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
                Icon(content: icon)
                    .foregroundColor(.inkLight)
                    .padding(.leading, .xSmall)
                    .accessibility(.tileDisclosureIcon)
        }
    }

    @ViewBuilder var separator: some View {
        if border == .separator {
            Separator()
                .padding(.leading, .medium)
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
        icon: Icon.Content = .none,
        disclosure: TileDisclosure = .icon(.chevronRight),
        border: TileBorder = .default,
        status: Status? = nil,
        backgroundColor: BackgroundColor? = nil,
        titleStyle: Heading.Style = .title4,
        descriptionColor: Text.Color = .inkLight,
        action: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = icon
        self.disclosure = disclosure
        self.border = border
        self.status = status
        self.backgroundColor = backgroundColor
        self.titleStyle = titleStyle
        self.descriptionColor = descriptionColor
        self.action = action
        self.content = content()
    }
    
    /// Creates Orbit Tile component.
    ///
    /// - Parameters:
    ///   - style: Appearance of tile. Can be styled to match iOS default table row.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        disclosure: TileDisclosure = .icon(.chevronRight),
        border: TileBorder = .default,
        status: Status? = nil,
        backgroundColor: BackgroundColor? = nil,
        titleStyle: Heading.Style = .title4,
        descriptionColor: Text.Color = .inkLight,
        action: @escaping () -> Void = {}
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
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

    static let title = "Title"
    static let description = "Description"
    static let descriptionMultiline = """
        Description with <strong>very</strong> <ref>very</ref> <u>very</u> long multiline \
        description and <u>formatting</u> with <applink1>links</applink1>
        """

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizing
            storybook
            storybookMix
        }
        .previewLayout(.sizeThatFits)
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Tile("Height \(state.wrappedValue)", description: description, icon: .grid)
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Tile("Height \(state.wrappedValue)", icon: .grid)
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Tile(description: "Height \(state.wrappedValue)", icon: .grid)
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    Tile("Height \(state.wrappedValue)")
                }
            }
        }
        .padding(.medium)
        .fixedSize(horizontal: false, vertical: true)
        .previewDisplayName("Sizing")
    }

    static var standalone: some View {
        Tile(title, description: description, icon: .grid)
            .padding(.medium)
            .previewDisplayName("Standalone")
    }

    static var storybook: some View {
        VStack(spacing: .large) {
            Tile(title)
            Tile(title, icon: .airplane)
            Tile(title, description: description)
            Tile(title, description: description, icon: .airplane)
            Tile {
                customContentPlaceholder
            }
        }
        .padding(.medium)
    }

    @ViewBuilder static var storybookMix: some View {
        VStack(spacing: .large) {
            Tile("Title with very very very very very long multiline text", description: descriptionMultiline, icon: .airplane) {
                customContentPlaceholder
            }
            Tile(title, description: description, icon: .symbol(.airplane, color: .blueNormal), status: .info)
            Tile("SF Symbol", description: description, icon: .sfSymbol("info.circle.fill"), status: .critical)
            Tile("Country Flag", description: description, icon: .countryFlag("cz"), disclosure: .buttonLink("Action", style: .primary))
            Tile(title, description: description, icon: .airplane, disclosure: .buttonLink("Action", style: .critical))
            Tile(title, description: description, icon: .airplane, disclosure: .icon(.grid))
            Tile(disclosure: .none) {
                customContentPlaceholder
            }
            Tile("Tile with custom content", disclosure: .none) {
                customContentPlaceholder
            }
            VStack(spacing: .medium) {
                Tile(
                    "Tile with no border",
                    description: descriptionMultiline,
                    icon: .grid,
                    border: .none
                )
                Tile(
                    "Tile with bottom separator",
                    description: descriptionMultiline,
                    border: .separator
                )
            }
        }
        .padding(.medium)
    }
}

struct TileDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")
            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        TilePreviews.storybook
    }
}
