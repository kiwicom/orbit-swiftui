import SwiftUI

/// Orbit input component that displays a rich selectable option to pick from a single or multiple selection group.
///
/// A ``ChoiceTile`` consists of a title, description, icon, content and a selection indicator.
///
/// ```swift
/// ChoiceTile("Full", isSelected: $isFull) {
///     // Tap action
/// } content: {
///     // Content
/// }
/// ```
///
/// ### Customizing appearance
///
/// The title and icon colors can be modified by ``textColor(_:)`` and ``iconColor(_:)`` modifiers.
/// The icon size can be modified by ``iconSize(custom:)`` modifier.
/// 
/// The default background can be overridden by ``SwiftUI/View/backgroundStyle(_:)`` modifier.
/// 
/// ```swift
/// ChoiceTile("Full", icon: .informationCircle, isSelected: $isFull) {
///     // Tap action
/// }
/// .textColor(.blueDark)
/// .iconColor(.inkNormal)
/// .iconSize(.small)
/// .backgroundStyle(.cloudLight)
/// ```
/// 
/// A ``Status`` can be modified by ``status(_:)`` modifier:
///
/// ```swift
/// ChoiceTile("Not available") {
///     // Tap action
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
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/choice-tile/)
public struct ChoiceTile<Icon: View, Badge: View, Title: View, Description: View, Header: View, Illustration: View, Content: View>: View {

    @Environment(\.backgroundShape) private var backgroundShape
    @Environment(\.idealSize) private var idealSize
    @Environment(\.status) private var status
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let indicator: ChoiceTileIndicator?
    private let isSelected: Bool
    private let isError: Bool
    private let message: Message?
    private let alignment: ChoiceTileAlignment
    private let action: () -> Void
    @ViewBuilder private let badge: Badge
    @ViewBuilder private let title: Title
    @ViewBuilder private let description: Description
    @ViewBuilder private let content: Content
    @ViewBuilder private let icon: Icon
    @ViewBuilder private let header: Header
    @ViewBuilder private let illustration: Illustration

    public var body: some View {
        SwiftUI.Button {
            if isHapticsEnabled {
                HapticsProvider.sendHapticFeedback(.light(0.3))
            }
            
            action()
        } label: {
            HStack(spacing: 0) {
                VStack(alignment: contentAlignment, spacing: .small) {
                    headerRow
                    content
                    messageView
                    centerIndicator
                }
                
                TextStrut()
                    .padding(.vertical, .xxSmall)   // Minimum 52pt @ normal size
            }
            .frame(maxWidth: idealSize.horizontal == true ? nil: .infinity, alignment: .leading)
            .overlay(indicatorOverlay, alignment: indicatorAlignment)
            .padding(.small)
        }
        .buttonStyle(
            TileButtonStyle(isSelected: isSelected)
        )
        .status(errorShouldHighlightBorder ? .critical : status)
        .overlay(badgeOverlayView, alignment: .top)
        .accessibility {
            title
        } value: {
            badge
        } hint: {
            Text(messageDescription)
        }
        .accessibility(addTraits: .isButton)
        .accessibility(addTraits: isSelected ? .isSelected : [])
        .accessibility(.choiceTile)
    }
    
    @ViewBuilder private var headerRow: some View {
        if isHeaderContentEmpty == false {
            switch alignment {
                case .default:
                    HStack(alignment: .top, spacing: 0) {
                        iconView
                            .padding(.trailing, .xSmall)

                        VStack(alignment: .leading, spacing: .xxSmall) {
                            title
                                .accessibility(.choiceTileTitle)

                            description
                                .textColor(.inkNormal)
                                .accessibility(.choiceTileDescription)
                        }
                        // A workaround for a layout issue when applied to header
                        .padding(.trailing, isHeaderContentEmpty ? 0 : .small)

                        if idealSize.horizontal != true {
                            Spacer(minLength: 0)
                        }

                        header
                    }
                    .padding(.vertical, .xxxSmall) // = 52 height @ normal size
                    .padding(.trailing, indicatorTrailingPadding)
                case .center:
                    VStack(spacing: .xxSmall) {
                        if illustration.isEmpty {
                            iconView
                                .padding(.bottom, .xxSmall)
                        } else {
                            illustration
                                .frame(height: 68)
                                .padding(.bottom, .xxSmall)
                        }

                        title
                            .accessibility(.choiceTileTitle)

                        description
                            .textColor(.inkNormal)
                            .accessibility(.choiceTileDescription)

                        header
                    }
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity)
                    .padding(.top, .small)
            }
        }
    }

    @ViewBuilder private var iconView: some View {
        icon
            .iconSize(.large)
            .foregroundColor(.inkNormal)
            .accessibility(.choiceTileIcon)
    }
    
    @ViewBuilder private var messageView: some View {
        FieldMessage(message, spacing: .xSmall)
            .padding(.trailing, indicatorTrailingPadding)
    }

    @ViewBuilder private var centerIndicator: some View {
        if alignment == .center {
            indicatorContent
        }
    }

    @ViewBuilder private var indicatorOverlay: some View {
        if alignment == .default {
            indicatorContent
        }
    }

    @ViewBuilder private var badgeOverlayView: some View {
        badge
            .status(isError && isSelected ? .critical : .info)
            .alignmentGuide(.top) { dimensions in
                dimensions.height / 2
            }
    }

    @ViewBuilder private var indicatorContent: some View {
        indicatorElement
            .allowsHitTesting(false)
            .padding(.xxxSmall)
            .padding(.bottom, indicatorContentBottomPadding)
    }

    @ViewBuilder private var indicatorElement: some View {
        switch indicator {
            case .none:         
                EmptyView()
            case .radio:        
                Radio(
                    isChecked: .constant(shouldSelectIndicator),
                    state: errorShouldHighlightIndicator ? .error : .normal 
                )
            case .checkbox:     
                Checkbox(
                    isChecked: .constant(shouldSelectIndicator),
                    state: errorShouldHighlightIndicator ? .error : .normal 
                )
            case .switch:       
                Switch(isOn: .constant(shouldSelectIndicator))
        }
    }

    private var isHeaderContentEmpty: Bool {
        title.isEmpty && description.isEmpty && icon.isEmpty && header is EmptyView
    }

    private var shouldSelectIndicator: Bool {
        isSelected && isError == false
    }

    private var errorShouldHighlightIndicator: Bool {
        isError && isSelected == false
    }

    private var errorShouldHighlightBorder: Bool {
        isError && isSelected
    }

    private var contentAlignment: HorizontalAlignment {
        switch alignment {
            case .default:      return .leading
            case .center:       return .center
        }
    }

    private var indicatorAlignment: Alignment {
        switch alignment {
            case .default:      return .bottomTrailing
            case .center:       return .bottom
        }
    }
    
    private var indicatorWidth: CGFloat {
        switch indicator {
            case .none:             return 0
            case .radio:            return RadioButtonStyle.size
            case .checkbox:         return CheckboxButtonStyle.size
            case .switch:           return 50
        }
    }
    
    private var indicatorTrailingPadding: CGFloat {
        isHeaderOnlyContent
            ? (indicatorWidth + .medium)
            : 0
    }

    private var indicatorContentBottomPadding: CGFloat {
        isHeaderOnlyContent
            ? .xxxSmall
            : 0
    }

    private var isHeaderOnlyContent: Bool {
        alignment == .default && content is EmptyView && message == nil
    }

    private var messageDescription: String {
        message?.description ?? ""
    }
    
    /// Creates Orbit ``ChoiceTile`` component with custom content.
    ///
    /// - Parameters:
    ///   - content: The content shown below the header.
    ///   - header: A trailing view placed inside the tile header.
    public init(
        indicator: ChoiceTileIndicator? = .radio,
        isSelected: Bool = false,
        isError: Bool = false,
        message: Message? = nil,
        alignment: ChoiceTileAlignment = .default,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder title: () -> Title = { EmptyView() },
        @ViewBuilder description: () -> Description = { EmptyView() },
        @ViewBuilder icon: () -> Icon = { EmptyView() },
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder badge: () -> Badge = { EmptyView() },
        @ViewBuilder illustration: () -> Illustration = { EmptyView() }
    ) {
        self.indicator = indicator
        self.isSelected = isSelected
        self.isError = isError
        self.message = message
        self.alignment = alignment
        self.action = action
        self.content = content()
        self.title = title()
        self.description = description()
        self.icon = icon()
        self.badge = badge()
        self.header = header()
        self.illustration = illustration()
    }
}

// MARK: - Convenience Inits
public extension ChoiceTile where Badge == Orbit.Badge<EmptyView, Text, EmptyView>, Title == Heading, Description == Text, Icon == Orbit.Icon {

    /// Creates Orbit ``ChoiceTile`` component.
    ///
    /// - Parameters:
    ///   - content: The content shown below the header.
    ///   - header: A trailing view placed inside the tile header.
    @_disfavoredOverload
    init(
        _ title: some StringProtocol = String(""),
        description: some StringProtocol = String(""),
        icon: Icon.Symbol? = nil,
        badge: some StringProtocol = String(""),
        indicator: ChoiceTileIndicator? = .radio,
        titleStyle: Heading.Style = .title3,
        isSelected: Bool = false,
        isError: Bool = false,
        message: Message? = nil,
        alignment: ChoiceTileAlignment = .default,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder illustration: () -> Illustration = { EmptyView() }
    ) {
        self.init(
            indicator: indicator,
            isSelected: isSelected,
            isError: isError,
            message: message,
            alignment: alignment
        ) {
            action()
        } content: {
            content()
        } title: {
            Heading(title, style: .title3)
        } description: {
            Text(description)
        } icon: {
            Icon(icon)
        } header: {
            header()
        } badge: {
            Orbit.Badge(type: .status(nil, inverted: true)) {
                Text(badge)
            }
        } illustration: {
            illustration()
        }
    }
    
    /// Creates Orbit ``ChoiceTile`` component with localizable texts.
    ///
    /// - Parameters:
    ///   - content: The content shown below the header.
    ///   - header: A trailing view placed inside the tile header.
    @_semantics("swiftui.init_with_localization")
    init(
        _ title: LocalizedStringKey = "",
        description: LocalizedStringKey = "",
        icon: Icon.Symbol? = nil,
        badge: LocalizedStringKey = "",
        indicator: ChoiceTileIndicator? = .radio,
        titleStyle: Heading.Style = .title3,
        isSelected: Bool = false,
        isError: Bool = false,
        message: Message? = nil,
        alignment: ChoiceTileAlignment = .default,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        titleComment: StaticString? = nil,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder illustration: () -> Illustration = { EmptyView() }
    ) {
        self.init(
            indicator: indicator,
            isSelected: isSelected,
            isError: isError,
            message: message,
            alignment: alignment
        ) {
            action()
        } content: {
            content()
        } title: {
            Heading(title, style: .title3, tableName: tableName, bundle: bundle)
        } description: {
            Text(description, tableName: tableName, bundle: bundle)
        } icon: {
            Icon(icon)
        } header: {
            header()
        } badge: {
            Orbit.Badge(type: .status(nil, inverted: true)) {
                Text(badge, tableName: tableName, bundle: bundle)
            }
        } illustration: {
            illustration()
        }
    }
}

// MARK: - Types

/// Indicator used for Orbit ``ChoiceTile``.
public enum ChoiceTileIndicator {
    case radio
    case checkbox
    case `switch`
}

/// Alignment variant of Orbit ``ChoiceTile``.
public enum ChoiceTileAlignment {
    case `default`
    case center
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let choiceTile               = Self(rawValue: "orbit.choicetile")
    static let choiceTileTitle          = Self(rawValue: "orbit.choicetile.title")
    static let choiceTileIcon           = Self(rawValue: "orbit.choicetile.icon")
    static let choiceTileDescription    = Self(rawValue: "orbit.choicetile.description")
    static let choiceTileBadge          = Self(rawValue: "orbit.choicetile.badge")
}

// MARK: - Previews
struct ChoiceTilePreviews: PreviewProvider {

    static let title = "ChoiceTile title"
    static let description = "Additional information for this choice."

    static var previews: some View {
        PreviewWrapper {
            standalone
            standaloneCentered
            indicators
            sizing
            idealSize
            styles
            stylesCentered
            mix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        ChoiceTile(title, description: description, icon: .grid, message: .help("Message")) {
            // No action
        } content: {
            contentPlaceholder
        } header: {
            headerPlaceholder
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var indicators: some View {
        VStack(spacing: .medium) {
            StateWrapper(false) { $isSelected in 
                ChoiceTile("Radio", description: description, indicator: .radio, isSelected: isSelected) {
                    isSelected.toggle()
                }
            }
            StateWrapper(false) { $isSelected in 
                ChoiceTile("Checkbox", description: description, indicator: .checkbox, isSelected: isSelected) {
                    isSelected.toggle()
                }
            }
            StateWrapper(false) { $isSelected in 
                ChoiceTile("Switch", description: description, indicator: .switch, isSelected: isSelected) {
                    isSelected.toggle()
                }
            }
            StateWrapper(false) { $isSelected in 
                ChoiceTile("No indicator", description: description, indicator: nil, isSelected: isSelected) {
                    isSelected.toggle()
                }
            }
            StateWrapper(false) { $isSelected in 
                ChoiceTile(indicator: nil, isSelected: isSelected) {
                    isSelected.toggle()
                } content: {
                    Icon(.check)
                        .opacity(isSelected ? 1 : 0)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                } title: {
                    Heading("Custom indicator", style: .title3)
                } description: {
                    Text(description)
                }
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            Group {
                ChoiceTile("ChoiceTile", description: description, icon: .grid, action: {})
                ChoiceTile("ChoiceTile", icon: .grid, action: {})
                ChoiceTile("ChoiceTile", action: {})
                ChoiceTile(icon: .grid, action: {})
                ChoiceTile(description: "ChoiceTile", icon: .grid, action: {})

                ChoiceTile {
                    // No action
                } header: {
                    Text("Value")
                }

                ChoiceTile {
                    // No action
                } content: {
                    Text("Value")
                }

                ChoiceTile {
                    // No action
                } content: {
                    Text("Intrinsic Content")
                        .textColor(.inkNormal)
                        .padding(.horizontal, .xxLarge)
                        .background(Color.productLightActive.opacity(0.3))
                }
                .idealSize()
            }
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var standaloneCentered: some View {
        ChoiceTile(
            message: .help("Message"),
            alignment: .center
        ) {
            // No action
        } content: {
            contentPlaceholder
        } title: {
            Heading(title, style: .title3)
        } description: {
            Text(description)
        } header: {
            headerPlaceholder
        } badge: {
            Orbit.Badge("Recommended", type: .status(nil, inverted: true))
        } illustration: {
            illustrationPlaceholder
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var idealSize: some View {
        VStack(alignment: .leading, spacing: .medium) {
            ChoiceTile("Intrinsic", icon: .grid, action: {})
            ChoiceTile {
                // No action
            } title: {
                Heading("Intrinsic", style: .title3)
            } icon: {
                Icon(.grid)
            } header: {
                Badge("Badge")
            }
            ChoiceTile("Intrinsic", icon: .grid, message: .error("Error"), action: {})
            ChoiceTile("Intrinsic", icon: .grid, alignment: .center, action: {})
            ChoiceTile("Intrinsic", icon: .grid, message: .error("Error"), alignment: .center, action: {})
            ChoiceTile {
                // No action
            } content: {
                intrinsicContentPlaceholder
            } title: {
                Heading("Intrinsic longer", style: .title3)
            } icon: {
                Icon(.grid)
            } header: {
                Badge("Badge")
            }
            ChoiceTile(message: .error("Error")) {
                // No action
            } content: {
                intrinsicContentPlaceholder
            } title: {
                Heading("Intrinsic", style: .title3)
            } icon: {
                Icon(.grid)
            } 
        }
        .idealSize()
        .padding(.medium)
        .previewDisplayName()
    }

    static var styles: some View {
        VStack(spacing: .medium) {
            content
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var stylesCentered: some View {
        VStack(spacing: .xLarge) {
            contentCentered
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(spacing: .medium) {
            StateWrapper(false) { isSelected in
                ChoiceTile(
                    "Checkbox indictor with long and multiline title",
                    icon: .grid,
                    indicator: .checkbox,
                    isSelected: isSelected.wrappedValue,
                    message: .help("Info multiline and very very very very long message")
                ) {
                    isSelected.wrappedValue.toggle()
                } content: {
                    contentPlaceholder
                }
                .iconColor(.greenNormal)
            }
            StateWrapper(false) { isSelected in
                ChoiceTile(
                    isSelected: isSelected.wrappedValue,
                    message: .warning("Warning multiline and very very very very long message")
                ) {
                    isSelected.wrappedValue.toggle()
                } content: {
                    contentPlaceholder
                } description: {
                    Text("Long and multiline description with no title")
                } icon: {
                    CountryFlag("cz")
                }
            }
            StateWrapper(false) { isSelected in
                ChoiceTile(
                    isSelected: isSelected.wrappedValue
                ) {
                    isSelected.wrappedValue.toggle()
                } content: {
                    Color.greenLight
                        .overlay(Text("Custom content, no header"))
                }
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var content: some View {
        choiceTile(titleStyle: .title4, showHeader: true, isError: false, isSelected: false)
            .backgroundStyle(.redLight)
        choiceTile(titleStyle: .title4, showHeader: true, isError: false, isSelected: true)
        choiceTile(titleStyle: .title3, showHeader: true, isError: false, isSelected: false)
        choiceTile(titleStyle: .title4, showHeader: false, isError: false, isSelected: true)
        choiceTile(titleStyle: .title4, showHeader: true, isError: true, isSelected: false)
        choiceTile(titleStyle: .title4, showHeader: true, isError: true, isSelected: true)
    }

    @ViewBuilder static var contentCentered: some View {
        choiceTileCentered(titleStyle: .title4, showIllustration: true, isError: false, isSelected: false)
        choiceTileCentered(titleStyle: .title4, showIllustration: false, isError: false, isSelected: true)
        choiceTileCentered(titleStyle: .title4, showIllustration: true, isError: true, isSelected: false)
        choiceTileCentered(titleStyle: .title4, showIllustration: true, isError: true, isSelected: true)
    }

    static func choiceTile(titleStyle: Heading.Style, showHeader: Bool, isError: Bool, isSelected: Bool) -> some View {
        StateWrapper(isSelected) { state in
            ChoiceTile(
                showHeader ? title : "",
                description: showHeader ? description : "",
                icon: showHeader ? .grid : .none,
                titleStyle: titleStyle,
                isSelected: state.wrappedValue,
                isError: isError
            ) {
                state.wrappedValue.toggle()
            } content: {
                contentPlaceholder
            }
        }
    }

    static func choiceTileCentered(titleStyle: Heading.Style, showIllustration: Bool, isError: Bool, isSelected: Bool) -> some View {
        StateWrapper(isSelected) { state in
            ChoiceTile(
                title,
                description: description,
                icon: showIllustration ? .none : .grid,
                badge: "Recommended",
                titleStyle: titleStyle,
                isSelected: state.wrappedValue,
                isError: isError,
                alignment: .center
            ) {
                state.wrappedValue.toggle()
            } content: {
                contentPlaceholder
            } illustration: {
                if showIllustration {
                    illustrationPlaceholder
                }
            }
        }
    }
}
