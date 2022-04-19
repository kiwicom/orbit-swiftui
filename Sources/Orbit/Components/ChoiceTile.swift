import SwiftUI

public enum ChoiceTileIndicator {
    
    public enum Alignment {
        case bottomTrailing
        case bottom
    }
    
    case none
    case radio
    case checkbox
}

public enum ChoiceTileAlignment {

    public static let padding: CGFloat = .small
    
    case `default`
    case center
}

/// Button style wrapper for ``ChoiceTile``.
/// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
public struct ChoiceTileButtonStyle: SwiftUI.ButtonStyle {

    let indicator: ChoiceTileIndicator
    let alignment: ChoiceTileAlignment
    let isError: Bool
    let isSelected: Bool

    /// Creates button style wrapper for ``ChoiceTile``.
    public init(indicator: ChoiceTileIndicator, alignment: ChoiceTileAlignment, isError: Bool, isSelected: Bool) {
        self.indicator = indicator
        self.alignment = alignment
        self.isError = isError
        self.isSelected = isSelected
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(indicatorOverlay, alignment: indicatorAlignment)
            .padding(ChoiceTileAlignment.padding)
            .tileBorder(
                isSelected: isSelected,
                backgroundColor: backgroundColor(isPressed: configuration.isPressed),
                shadow: shadow(isPressed: configuration.isPressed))
    }

    @ViewBuilder var indicatorOverlay: some View {
        indicatorElement
            .disabled(true)
            .padding(.xxxSmall)
    }
    
    @ViewBuilder var indicatorElement: some View {
        switch indicator {
            case .none:         EmptyView()
            case .radio:        Radio(state: isError ? .error : .normal, isChecked: isSelected)
            case .checkbox:     Checkbox(state: isError ? .error : .normal, isChecked: isSelected)
        }
    }
    
    var indicatorAlignment: Alignment {
        switch alignment {
            case .default:      return .bottomTrailing
            case .center:       return .bottom
        }
    }
    
    func backgroundColor(isPressed: Bool) -> Color {
        isPressed ? .whiteHover : .white
    }
    
    func shadow(isPressed: Bool) -> TileBorderModifier.Shadow {
        if isError {
            return .none
        }
        
        switch (isSelected, isPressed) {
            case (false, false):    return .small
            case (false, true):     return .default
            case (true, false):     return .small
            case (true, true):      return .default
        }
    }
}

/// Enables users to encapsulate radio or checkbox to pick exactly one option from a group.
///
/// - Related components:
///   - ``Tile``
///   - ``TileGroup``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/choice-tile/)
/// - Important: Component expands horizontally to infinity.
public struct ChoiceTile<Content: View>: View {
    
    let title: String
    let description: String
    let badge: String
    let badgeOverlay: String
    let iconContent: Icon.Content
    let illustration: Illustration.Image
    let indicator: ChoiceTileIndicator
    let titleStyle: Heading.Style
    let isSelected: Bool
    let isError: Bool
    let message: MessageType
    let alignment: ChoiceTileAlignment
    let action: () -> Void
    let content: () -> Content

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.3))
                action()
            },
            label: {
                VStack(alignment: .leading, spacing: ChoiceTileAlignment.padding) {
                    header
                    content()
                    messageView
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, badgeOverlay.isEmpty ? 0 : .small)
            }
        )
        .buttonStyle(ChoiceTileButtonStyle(indicator: indicator, alignment: alignment, isError: isError, isSelected: isSelected))
        .accessibility(removeTraits: isSelected == false ? .isSelected : [])
        .accessibility(addTraits: isSelected ? .isSelected : [])
        .overlay(badgeOverlayView, alignment: .top)
    }
    
    @ViewBuilder var header: some View {
        if isHeaderContentEmpty == false {
            switch alignment {
                case .default:
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        
                        Icon(iconContent, size: .heading(titleStyle))
                            .padding(.trailing, .xSmall)
                        
                        VStack(alignment: .leading, spacing: .xxSmall) {
                            Heading(title, style: titleStyle)
                            Text(description, color: .inkLight)
                        }
                        
                        Spacer(minLength: 0)
                        
                        Badge(badge, style: .status(.info))
                    }
                case .center:
                    VStack(spacing: .xxSmall) {
                        if illustration == .none {
                            Icon(iconContent, size: .heading(titleStyle))
                                .padding(.bottom, .xxxSmall)
                        } else {
                            Illustration(illustration, layout: .resizeable)
                                .frame(height: .xxLarge)
                        }
                        Heading(title, style: titleStyle, alignment: .center)
                        Text(description, color: .inkLight, alignment: .center)
                        Badge(badge, style: .neutral)
                    }
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    @ViewBuilder var messageView: some View {
        switch alignment {
            case .default:
                FormFieldMessage(message, spacing: .xSmall)
                    .padding(.trailing, messagePadding)
            case .center:
                FormFieldMessage(message, spacing: .xSmall)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, messagePadding)
        }
    }
    
    @ViewBuilder var badgeOverlayView: some View {
        Badge(badgeOverlay, style: .status(.info, inverted: true))
            .offset(y: -Badge.Size.default.height / 2)
    }

    var isHeaderContentEmpty: Bool {
        title.isEmpty && description.isEmpty && iconContent.isEmpty && badge.isEmpty
    }
    
    var indicatorSize: CGSize {
        switch indicator {
            case .none:             return .zero
            case .radio:            return Radio.ButtonStyle.size
            case .checkbox:         return Checkbox.ButtonStyle.size
        }
    }
    
    var messagePadding: CGFloat {
        switch alignment {
            case .default:
                return indicatorSize.width > 0
                    ? (indicatorSize.width + ChoiceTileAlignment.padding + .xSmall)
                    : 0
            case .center:
                return indicatorSize.height > 0
                    ? (indicatorSize.height + ChoiceTileAlignment.padding + .xSmall)
                    : 0
        }
    }
}

// MARK: - Inits
public extension ChoiceTile {

    /// Creates Orbit ChoiceTile component over custom content.
    init(
        _ title: String = "",
        description: String = "",
        iconContent: Icon.Content,
        illustration: Illustration.Image = .none,
        badge: String = "",
        badgeOverlay: String = "",
        indicator: ChoiceTileIndicator = .radio,
        titleStyle: Heading.Style = .title3,
        isSelected: Bool = false,
        isError: Bool = false,
        message: MessageType = .none,
        alignment: ChoiceTileAlignment = .default,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = iconContent
        self.illustration = illustration
        self.badge = badge
        self.badgeOverlay = badgeOverlay
        self.indicator = indicator
        self.titleStyle = titleStyle
        self.isSelected = isSelected
        self.isError = isError
        self.message = message
        self.alignment = alignment
        self.action = action
        self.content = content
    }

    /// Creates Orbit ChoiceTile component over custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        illustration: Illustration.Image = .none,
        badge: String = "",
        badgeOverlay: String = "",
        indicator: ChoiceTileIndicator = .radio,
        titleStyle: Heading.Style = .title3,
        isSelected: Bool = false,
        isError: Bool = false,
        message: MessageType = .none,
        alignment: ChoiceTileAlignment = .default,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            title,
            description: description,
            iconContent: .icon(icon),
            illustration: illustration,
            badge: badge,
            badgeOverlay: badgeOverlay,
            indicator: indicator,
            titleStyle: titleStyle,
            isSelected: isSelected,
            isError: isError,
            message: message,
            alignment: alignment,
            action: action,
            content: content
        )
    }
}

// MARK: - Previews
struct ChoiceTilePreviews: PreviewProvider {

    static let title = "ChoiceTile title"
    static let description = "Additional information for this choice."

    static var previews: some View {
        PreviewWrapper {
            standalone
            standaloneCentered

            storybook
            storybookCentered
            storybookMix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        ChoiceTile(
            title,
            description: description,
            icon: .grid,
            badge: "Popular",
            message: .help("Message")
        ) {
            customContentPlaceholder
        }
        .padding(.medium)
    }

    static var standaloneCentered: some View {
        ChoiceTile(
            title,
            description: description,
            illustration: .priorityBoarding,
            badge: "Included",
            badgeOverlay: "Recommended",
            message: .help("Message"),
            alignment: .center
        ) {
            customContentPlaceholder
        }
        .padding(.medium)
        .previewDisplayName("Centered")
    }

    static var storybook: some View {
        VStack(spacing: 0) {
            content
        }
    }

    static var storybookCentered: some View {
        VStack(spacing: 0) {
            contentCentered
        }
    }

    static var storybookMix: some View {
        VStack(spacing: .medium) {
            StateWrapper(initialState: false) { isSelected in
                ChoiceTile(
                    "Checkbox indictor with long and multiline title",
                    icon: .grid,
                    indicator: .checkbox,
                    isSelected: isSelected.wrappedValue,
                    message: .help("Info multiline and very very very very long message")
                ) {
                    customContentPlaceholder
                }
            }
            StateWrapper(initialState: false) { isSelected in
                ChoiceTile(
                    description: "Long and multiline description with no title",
                    icon: .grid,
                    isSelected: isSelected.wrappedValue,
                    message: .warning("Warning multiline and very very very very long message")
                ) {
                    customContentPlaceholder
                }
            }
            StateWrapper(initialState: false) { isSelected in
                ChoiceTile(isSelected: isSelected.wrappedValue) {
                    Color.greenLight
                        .overlay(Text("Custom content, no header"))
                }
            }
        }
        .padding(.medium)
    }

    @ViewBuilder static var content: some View {
        choiceTile(titleStyle: .title4, showHeader: true, isError: false, isSelected: false)
        choiceTile(titleStyle: .title4, showHeader: true, isError: false, isSelected: true)
        choiceTile(titleStyle: .title3, showHeader: true, isError: false, isSelected: false)
        choiceTile(titleStyle: .title3, showHeader: true, isError: false, isSelected: true)
        choiceTile(titleStyle: .title4, showHeader: false, isError: false, isSelected: false)
        choiceTile(titleStyle: .title4, showHeader: false, isError: false, isSelected: true)
        choiceTile(titleStyle: .title4, showHeader: true, isError: true, isSelected: false)
        choiceTile(titleStyle: .title4, showHeader: true, isError: true, isSelected: true)
    }

    @ViewBuilder static var contentCentered: some View {
        choiceTileCentered(titleStyle: .title4, showIllustration: true, isError: false, isSelected: false)
        choiceTileCentered(titleStyle: .title4, showIllustration: true, isError: false, isSelected: true)
        choiceTileCentered(titleStyle: .title3, showIllustration: true, isError: false, isSelected: false)
        choiceTileCentered(titleStyle: .title3, showIllustration: true, isError: false, isSelected: true)
        choiceTileCentered(titleStyle: .title3, showIllustration: false, isError: false, isSelected: false)
        choiceTileCentered(titleStyle: .title3, showIllustration: false, isError: false, isSelected: true)
        choiceTileCentered(titleStyle: .title4, showIllustration: true, isError: true, isSelected: false)
        choiceTileCentered(titleStyle: .title4, showIllustration: true, isError: true, isSelected: true)
    }

    static func choiceTile(titleStyle: Heading.Style, showHeader: Bool, isError: Bool, isSelected: Bool) -> some View {
        StateWrapper(initialState: isSelected) { state in
            ChoiceTile(
                showHeader ? title : "",
                description: showHeader ? description : "",
                icon: showHeader ? .grid : .none,
                titleStyle: titleStyle,
                isSelected: state.wrappedValue,
                isError: isError,
                action: {
                    state.wrappedValue.toggle()
                },
                content: {
                    customContentPlaceholder
                }
            )
        }
        .padding(.medium)
    }

    static func choiceTileCentered(titleStyle: Heading.Style, showIllustration: Bool, isError: Bool, isSelected: Bool) -> some View {
        StateWrapper(initialState: isSelected) { state in
            ChoiceTile(
                title,
                description: description,
                icon: showIllustration ? .none : .grid,
                illustration: showIllustration ? .priorityBoarding : .none,
                badgeOverlay: "Recommended",
                titleStyle: titleStyle,
                isSelected: state.wrappedValue,
                isError: isError,
                alignment: .center,
                action: {
                    state.wrappedValue.toggle()
                },
                content: {
                    customContentPlaceholder
                }
            )
        }
        .padding(.medium)
    }
}
