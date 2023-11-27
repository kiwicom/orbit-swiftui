import SwiftUI

/// Orbit component that displays an option to pick from a group.
///
/// A ``Tile`` consists of a title, description, icon and content.
///
/// ```swift
/// Tile("Profile", icon: .account) {
///     // Tap action
/// } content: {
///     // Content
/// }
/// ```
///
/// A `Tile` can be used standalone or wrapped in a ``TileGroup``. 
///
/// ### Customizing appearance
///
/// The title and icon colors can be modified by ``textColor(_:)`` and ``iconColor(_:)`` modifiers.
/// The icon size can be modified by ``iconSize(custom:)`` modifier.
/// 
/// The default background can be overridden by ``backgroundStyle(_:)-9odue`` modifier.
/// 
/// A ``Status`` can be modified by ``status(_:)`` modifier:
///
/// ```swift
/// Tile("Not available") {
///     // Action
/// }
/// .status(.critical)
/// ```
///
/// Before the action is triggered, a haptic feedback is fired via ``HapticsProvider/sendHapticFeedback(_:)``.
///
/// ### Layout
///
/// Component expands horizontally unless prevented by the native `fixedSize()` or ``idealSize()`` modifier.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/tile/)
public struct Tile<Content: View, Icon: View>: View {

    @Environment(\.idealSize) private var idealSize
    @Environment(\.isInsideTileGroup) private var isInsideTileGroup
    @Environment(\.isTileSeparatorVisible) private var isTileSeparatorVisible
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let title: String
    private let description: String
    private let disclosure: TileDisclosure
    private let showBorder: Bool
    private let titleStyle: Heading.Style
    private let descriptionColor: Color
    private let action: () -> Void
    @ViewBuilder private let content: Content
    @ViewBuilder private let icon: Icon

    public var body: some View {
        SwiftUI.Button {
            if isHapticsEnabled {
                HapticsProvider.sendHapticFeedback(.light(0.5))
            }
            
            action()
        } label: {
            buttonContent
        }
        .buttonStyle(TileButtonStyle(style: tileBorderStyle))
        .accessibilityElement(children: .ignore)
        .accessibility(label: .init(title))
        .accessibility(hint: .init(description))
        .accessibility(addTraits: .isButton)
    }

    @ViewBuilder private var buttonContent: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                header
                content
            }

            if idealSize.horizontal != true {
                Spacer(minLength: 0)
            }

            TextStrut()
                .textSize(.large)
                .padding(.vertical, TileButtonStyle.verticalTextPadding)

            disclosureIcon
        }
        .overlay(customContentButtonLinkOverlay, alignment: .topTrailing)
        .overlay(separator, alignment: .init(horizontal: .listRowSeparatorLeading, vertical: .bottom))
    }
    
    @ViewBuilder private var header: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .top, spacing: .xSmall) {
                icon
                    .font(.system(size: Orbit.Icon.Size.fromTextSize(size: titleStyle.size)))
                    .foregroundColor(.inkNormal)
                    .accessibility(.tileIcon)

                VStack(alignment: .leading, spacing: .xxSmall) {
                    Heading(title, style: titleStyle)
                        .accessibility(.tileTitle)

                    Text(description)
                        .textColor(descriptionColor)
                        .accessibility(.tileDescription)
                }
                .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
                .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .leading)

                inactiveButtonLink
            }
            .padding(.vertical, TileButtonStyle.verticalTextPadding)
            .padding(.horizontal, .medium)
        }
    }

    @ViewBuilder private var customContentButtonLinkOverlay: some View {
        if isHeaderEmpty {
            inactiveButtonLink
                .padding(.medium)
        }
    }

    @ViewBuilder private var inactiveButtonLink: some View {
        switch disclosure {
            case .none, .icon:
                EmptyView()
            case .buttonLink(let label, let type):
                ButtonLink(label, type: type, action: {})
                    .buttonSize(.compact)
                    .textColor(nil)
                    .disabled(true)
                    .padding(.vertical, -.xxSmall)
                    .accessibility(.tileDisclosureButtonLink)
        }
    }

    @ViewBuilder private var disclosureIcon: some View {
        switch disclosure {
            case .none, .buttonLink:
                EmptyView()
            case .icon(let icon, _):
                Orbit.Icon(icon)
                    .iconColor(.inkNormal)
                    .padding(.leading, .xSmall)
                    .padding(.trailing, .medium)
                    .accessibility(.tileDisclosureIcon)
        }
    }

    @ViewBuilder private var separator: some View {
        if isInsideTileGroup, isTileSeparatorVisible {
            Separator()
        }
    }
    
    private var tileBorderStyle: TileBorderStyle {
        showBorder && isInsideTileGroup == false ? .default : .none
    }
    
    private var isHeaderEmpty: Bool {
        title.isEmpty && description.isEmpty && icon.isEmpty
    }
}

// MARK: - Inits
public extension Tile {
    
    /// Creates Orbit ``Tile`` component with custom icon.
    init(
        _ title: String = "",
        description: String = "",
        disclosure: TileDisclosure = .icon(.chevronForward),
        showBorder: Bool = true,
        titleStyle: Heading.Style = .title4,
        descriptionColor: Color = .inkNormal,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder icon: () -> Icon
    ) {
        self.title = title
        self.description = description
        self.disclosure = disclosure
        self.showBorder = showBorder
        self.titleStyle = titleStyle
        self.descriptionColor = descriptionColor
        self.action = action
        self.content = content()
        self.icon = icon()
    }
    
    /// Creates Orbit ``Tile`` component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol? = nil,
        disclosure: TileDisclosure = .icon(.chevronForward),
        showBorder: Bool = true,
        titleStyle: Heading.Style = .title4,
        descriptionColor: Color = .inkNormal,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) where Icon == Orbit.Icon {
        self.init(
            title,
            description: description,
            disclosure: disclosure,
            showBorder: showBorder,
            titleStyle: titleStyle,
            descriptionColor: descriptionColor
        ) {
            action()
        } content: {
            content()
        } icon: {
            Icon(icon)
        }
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

public enum TileDisclosure: Equatable {
    case none
    /// Icon with optional color override.
    case icon(Icon.Symbol, alignment: VerticalAlignment = .center)
    /// ButtonLink indicator.
    case buttonLink(_ label: String, type: ButtonLinkType = .primary)
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
            Tile {
                // No action
            } content: {
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

            Tile(title, description: description, icon: .airplane) {
                // No action
            }
            .iconColor(.blueNormal)
            .status(.info)

            Tile("SF Symbol", description: description) {
                // No action
            } icon: {
                Icon("info.circle.fill")
            }
            .status(.critical)

            Tile("Country Flag", description: description, icon: .grid, disclosure: .buttonLink("Action", type: .primary), action: {})
            Tile(title, description: description, icon: .airplane, disclosure: .buttonLink("Action", type: .critical), action: {})
            Tile(title, description: description, icon: .airplane, disclosure: .icon(.grid), action: {})
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var customContentMix: some View {
        VStack(spacing: .large) {
            Tile(disclosure: .none) {
                // No action
            } content: {
                contentPlaceholder
            }
            Tile(disclosure: .buttonLink("Action", type: .critical)) {
                // No action
            } content: {
                contentPlaceholder
            }
            Tile {
                // No action
            } content: {
                contentPlaceholder
            }
            Tile("Tile with custom content", disclosure: .buttonLink("Action", type: .critical)) {
                // No action
            } content: {
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
