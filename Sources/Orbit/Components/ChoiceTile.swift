import SwiftUI

/// Enables users to encapsulate radio or checkbox to pick exactly one option from a group.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/choice-tile/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct ChoiceTile<Content: View, Icon: View, Header: View, Illustration: View>: View {

    @Environment(\.backgroundShape) private var backgroundShape
    @Environment(\.idealSize) private var idealSize
    @Environment(\.status) private var status
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    public let padding: CGFloat = .small

    let title: String
    let description: String
    let badgeOverlay: String
    let indicator: ChoiceTileIndicator
    let titleStyle: Heading.Style
    let isSelected: Bool
    let isError: Bool
    let message: Message?
    let alignment: ChoiceTileAlignment
    let action: () -> Void
    @ViewBuilder let content: Content
    @ViewBuilder let icon: Icon
    @ViewBuilder let header: Header
    @ViewBuilder let illustration: Illustration

    public var body: some View {
        SwiftUI.Button(
            action: {
                if isHapticsEnabled {
                    HapticsProvider.sendHapticFeedback(.light(0.3))
                }
                
                action()
            },
            label: {
                HStack(spacing: 0) {
                    VStack(alignment: contentAlignment, spacing: padding) {
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
                .padding(padding)
            }
        )
        .buttonStyle(
            TileButtonStyle(isSelected: isSelected)
        )
        .status(errorShouldHighlightBorder ? .critical : status)
        .overlay(badgeOverlayView, alignment: .top)
        .accessibilityElement(children: .ignore)
        .accessibility(label: .init(title))
        .accessibility(value: .init(badgeOverlay))
        .accessibility(hint: .init(messageDescription.isEmpty ? description : messageDescription))
        .accessibility(addTraits: .isButton)
        .accessibility(addTraits: isSelected ? .isSelected : [])
    }
    
    @ViewBuilder var headerRow: some View {
        if isHeaderContentEmpty == false {
            switch alignment {
                case .default:
                    HStack(alignment: .top, spacing: 0) {
                        iconView
                            .padding(.trailing, .xSmall)

                        VStack(alignment: .leading, spacing: .xxSmall) {
                            Heading(title, style: titleStyle)
                                .accessibility(.choiceTileTitle)

                            Text(description)
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

                        Heading(title, style: titleStyle)
                            .accessibility(.choiceTileTitle)

                        Text(description)
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

    @ViewBuilder var iconView: some View {
        icon
            .iconSize(custom: titleStyle.lineHeight)
            .font(.system(size: Orbit.Icon.Size.fromTextSize(size: titleStyle.size)))
            .foregroundColor(.inkNormal)
            .accessibility(.choiceTileIcon)
    }
    
    @ViewBuilder var messageView: some View {
        FieldMessage(message, spacing: .xSmall)
            .padding(.trailing, indicatorTrailingPadding)
    }

    @ViewBuilder var centerIndicator: some View {
        if alignment == .center {
            indicatorContent
        }
    }

    @ViewBuilder var indicatorOverlay: some View {
        if alignment == .default {
            indicatorContent
        }
    }

    @ViewBuilder var badgeOverlayView: some View {
        Badge(badgeOverlay, type: .status(isError && isSelected ? .critical : .info, inverted: true))
            .alignmentGuide(.top) { dimensions in
                dimensions.height / 2
            }
    }

    @ViewBuilder var indicatorContent: some View {
        indicatorElement
            .allowsHitTesting(false)
            .padding(.xxxSmall)
            .padding(.bottom, indicatorContentBottomPadding)
    }

    @ViewBuilder var indicatorElement: some View {
        switch indicator {
            case .none:         EmptyView()
            case .radio:        Radio(state: errorShouldHighlightIndicator ? .error : .normal, isChecked: .constant(shouldSelectIndicator))
            case .checkbox:     Checkbox(state: errorShouldHighlightIndicator ? .error : .normal, isChecked: .constant(shouldSelectIndicator))
        }
    }

    var isHeaderContentEmpty: Bool {
        title.isEmpty && description.isEmpty && icon.isEmpty && header is EmptyView
    }

    var shouldSelectIndicator: Bool {
        isSelected && isError == false
    }

    var errorShouldHighlightIndicator: Bool {
        isError && isSelected == false
    }

    var errorShouldHighlightBorder: Bool {
        isError && isSelected
    }

    var contentAlignment: HorizontalAlignment {
        switch alignment {
            case .default:      return .leading
            case .center:       return .center
        }
    }

    var indicatorAlignment: Alignment {
        switch alignment {
            case .default:      return .bottomTrailing
            case .center:       return .bottom
        }
    }
    
    var indicatorSize: CGFloat {
        switch indicator {
            case .none:             return 0
            case .radio:            return RadioButtonStyle.size
            case .checkbox:         return CheckboxButtonStyle.size
        }
    }
    
    var indicatorTrailingPadding: CGFloat {
        isHeaderOnlyContent
            ? (indicatorSize + padding + .xxSmall)
            : 0
    }

    var indicatorContentBottomPadding: CGFloat {
        isHeaderOnlyContent
            ? .xxxSmall
            : 0
    }

    var isHeaderOnlyContent: Bool {
        alignment == .default && content is EmptyView && message == nil
    }

    var messageDescription: String {
        message?.description ?? ""
    }
}

// MARK: - Inits
public extension ChoiceTile {

    /// Creates Orbit ChoiceTile component.
    ///
    /// Custom background color be specified using `.backgroundStyle()` modifier.
    ///
    /// - Parameters:
    ///   - content: The content shown below the header.
    ///   - header: A trailing view placed inside the tile header.
    init(
        _ title: String = "",
        description: String = "",
        badgeOverlay: String = "",
        indicator: ChoiceTileIndicator = .radio,
        titleStyle: Heading.Style = .title3,
        isSelected: Bool = false,
        isError: Bool = false,
        message: Message? = nil,
        alignment: ChoiceTileAlignment = .default,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder illustration: () -> Illustration = { EmptyView() }
    ) {
        self.title = title
        self.description = description
        self.badgeOverlay = badgeOverlay
        self.indicator = indicator
        self.titleStyle = titleStyle
        self.isSelected = isSelected
        self.isError = isError
        self.message = message
        self.alignment = alignment
        self.action = action
        self.content = content()
        self.icon = icon()
        self.header = header()
        self.illustration = illustration()
    }

    /// Creates Orbit ChoiceTile component.
    ///
    /// Custom background color be specified using `.backgroundStyle()` modifier.
    ///
    /// - Parameters:
    ///   - content: The content shown below the header.
    ///   - header: A trailing view placed inside the tile header.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol? = nil,
        badgeOverlay: String = "",
        indicator: ChoiceTileIndicator = .radio,
        titleStyle: Heading.Style = .title3,
        isSelected: Bool = false,
        isError: Bool = false,
        message: Message? = nil,
        alignment: ChoiceTileAlignment = .default,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder illustration: () -> Illustration = { EmptyView() }
    ) where Icon == Orbit.Icon {
        self.init(
            title,
            description: description,
            badgeOverlay: badgeOverlay,
            indicator: indicator,
            titleStyle: titleStyle,
            isSelected: isSelected,
            isError: isError,
            message: message,
            alignment: alignment
        ) {
            action()
        } content: {
            content()
        } icon: {
            Icon(icon)
        } header: {
            header()
        } illustration: {
            illustration()
        }
    }
}

// MARK: - Types

/// An indicator used for Orbit ChoiceTile.
public enum ChoiceTileIndicator {

    public enum Alignment {
        case bottomTrailing
        case bottom
    }

    case none
    case radio
    case checkbox
}

/// Alignment variant of Orbit ChoiceTile.
public enum ChoiceTileAlignment {
    case `default`
    case center
}

// MARK: - Identifiers
public extension AccessibilityID {

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
            title,
            description: description,
            badgeOverlay: "Recommended",
            message: .help("Message"),
            alignment: .center
        ) {
            // No action
        } content: {
            contentPlaceholder
        } header: {
            headerPlaceholder
        } illustration: {
            illustrationPlaceholder
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var idealSize: some View {
        VStack(alignment: .leading, spacing: .medium) {
            ChoiceTile("Intrinsic", icon: .grid, action: {})
            ChoiceTile("Intrinsic", icon: .grid) {
                // No action
            } header: {
                Badge("Badge")
            }
            ChoiceTile("Intrinsic", icon: .grid, message: .error("Error"), action: {})
            ChoiceTile("Intrinsic", icon: .grid, alignment: .center, action: {})
            ChoiceTile("Intrinsic", icon: .grid, message: .error("Error"), alignment: .center, action: {})
            ChoiceTile("Intrinsic longer", icon: .grid) {
                // No action
            } content: {
                intrinsicContentPlaceholder
            } header: {
                Badge("Badge")
            }
            ChoiceTile("Intrinsic", icon: .grid, message: .error("Error")) {
                // No action
            } content: {
                intrinsicContentPlaceholder
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
                    description: "Long and multiline description with no title",
                    isSelected: isSelected.wrappedValue,
                    message: .warning("Warning multiline and very very very very long message")
                ) {
                    isSelected.wrappedValue.toggle()
                } content: {
                    contentPlaceholder
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
                badgeOverlay: "Recommended",
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
