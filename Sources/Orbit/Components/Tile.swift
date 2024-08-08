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
/// The default background can be overridden by ``SwiftUI/View/backgroundStyle(_:)`` modifier.
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
public struct Tile<Icon: View, Title: View, Description: View, Content: View>: View {

    @Environment(\.idealSize) private var idealSize
    @Environment(\.isInsideTileGroup) private var isInsideTileGroup
    @Environment(\.isTileSeparatorVisible) private var isTileSeparatorVisible
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let disclosure: TileDisclosure?
    private let showBorder: Bool
    private let action: () -> Void
    @ViewBuilder private let icon: Icon
    @ViewBuilder private let title: Title
    @ViewBuilder private let description: Description
    @ViewBuilder private let content: Content

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
        .accessibility {
            title
        } hint: {
            description
        }
        .accessibility(addTraits: .isButton)
        .accessibility(.tile)
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
                    .font(
                        .system(size: Orbit.Icon.Size.fromTextSize(size: Heading.Style.title4.size))
                    )
                    .foregroundColor(.inkNormal)
                    .accessibility(.tileIcon)

                VStack(alignment: .leading, spacing: .xxSmall) {
                    title
                        .accessibility(.tileTitle)

                    description
                        .textColor(.inkNormal)
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
    
    private var tileBorderStyle: TileBorderStyle? {
        showBorder && isInsideTileGroup == false ? .default : nil
    }
    
    private var isHeaderEmpty: Bool {
        title.isEmpty && description.isEmpty && icon.isEmpty
    }
    
    /// Creates Orbit ``Tile`` component with custom content.
    public init(
        disclosure: TileDisclosure? = .icon(.chevronForward),
        showBorder: Bool = true,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder title: () -> Title = { EmptyView() },
        @ViewBuilder description: () -> Description = { EmptyView() },
        @ViewBuilder icon: () -> Icon = { EmptyView() }
    ) {
        self.disclosure = disclosure
        self.showBorder = showBorder
        self.title = title()
        self.description = description()
        self.action = action
        self.content = content()
        self.icon = icon()
    }
}

// MARK: - Inits
public extension Tile where Title == Heading, Description == Text, Icon == Orbit.Icon {
    
    /// Creates Orbit ``Tile`` component.
    @_disfavoredOverload
    init(
        _ title: some StringProtocol = String(""),
        description: some StringProtocol = String(""),
        icon: Icon.Symbol? = nil,
        disclosure: TileDisclosure? = .icon(.chevronForward),
        showBorder: Bool = true,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.init(
            disclosure: disclosure,
            showBorder: showBorder
        ) {
            action()
        } content: {
            content()
        } title: {
            Heading(title, style: .title4)
        } description: {
            Text(description)
        } icon: {
            Icon(icon)
        }
    }
    
    /// Creates Orbit ``Tile`` component with localizable texts.
    @_semantics("swiftui.init_with_localization")
    init(
        _ title: LocalizedStringKey = "",
        description: LocalizedStringKey = "",
        icon: Icon.Symbol? = nil,
        disclosure: TileDisclosure? = .icon(.chevronForward),
        showBorder: Bool = true,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        titleComment: StaticString? = nil,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.init(
            disclosure: disclosure,
            showBorder: showBorder
        ) {
            action()
        } content: {
            content()
        } title: {
            Heading(title, style: .title4, tableName: tableName, bundle: bundle)
        } description: {
            Text(description, tableName: tableName, bundle: bundle)
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
    /// Icon with optional color override.
    case icon(Icon.Symbol, alignment: VerticalAlignment = .center)
    /// ButtonLink indicator.
    case buttonLink(_ label: String, type: ButtonLinkType = .primary)
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let tile                         = Self(rawValue: "orbit.tile")
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

            Tile {
                // No action
            } title: {
                Heading("SF Symbol", style: .title4)
            } description: {
                Text(description)
            } icon: {
                Icon("info.circle.fill")
            }
            .status(.critical)

            Tile(disclosure: .buttonLink("Action", type: .primary)) {
                // No action
            } title: {
                Heading("Country Flag", style: .title4)
            } description: {
                Text(description)
            } icon: {
                CountryFlag("us")
            }
            
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
