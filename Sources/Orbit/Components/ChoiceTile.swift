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
    case `default`
    case center
}

/// Enables users to encapsulate radio or checkbox to pick exactly one option from a group.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/choice-tile/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct ChoiceTile<Content: View>: View {

    @Environment(\.idealSize) var idealSize

    public let padding: CGFloat = .small
    public let verticalTextPadding: CGFloat = .xxSmall - 1/6    // Results in ±52 height at normal text size

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
    @ViewBuilder let content: Content

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.3))
                action()
            },
            label: {
                HStack(spacing: 0) {
                    TextStrut(.large)
                        .padding(.vertical, verticalTextPadding)

                    VStack(alignment: .leading, spacing: padding) {
                        header
                        content
                        messageView
                    }
                }
                .padding(.top, badgeOverlay.isEmpty ? 0 : .small)
                .overlay(indicatorOverlay, alignment: indicatorAlignment)
                .padding(padding)
                .frame(maxWidth: idealSize.horizontal == true ? nil: .infinity, alignment: .leading)
            }
        )
        .buttonStyle(TileButtonStyle(isSelected: isSelected, status: errorShouldHighlightBorder ? .critical : nil))
        .overlay(badgeOverlayView, alignment: .top)
        .accessibilityElement(children: .ignore)
        .accessibility(label: .init(title))
        .accessibility(value: .init(badgeOverlay.isEmpty ?  badge : badgeOverlay))
        .accessibility(hint: .init(message.description.isEmpty ? description : message.description))
        .accessibility(addTraits: .isButton)
        .accessibility(addTraits: isSelected ? .isSelected : [])
    }
    
    @ViewBuilder var header: some View {
        if isHeaderContentEmpty == false {
            switch alignment {
                case .default:
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        
                        Icon(content: iconContent, size: .heading(titleStyle))
                            .foregroundColor(.inkNormal)
                            .padding(.trailing, .xSmall)
                            .accessibility(.choiceTileIcon)
                        
                        VStack(alignment: .leading, spacing: .xxSmall) {
                            Heading(title, style: titleStyle)
                                .accessibility(.choiceTileTitle)

                            Text(description, color: .inkLight)
                                .accessibility(.choiceTileDescription)
                        }

                        if idealSize.horizontal == nil {
                            Spacer(minLength: 0)
                        }
                        
                        Badge(badge, style: .status(.info))
                            .padding(.leading, .xSmall)
                            .accessibility(.choiceTileBadge)
                    }
                case .center:
                    VStack(spacing: .xxSmall) {
                        if illustration == .none {
                            Icon(content: iconContent, size: .heading(titleStyle))
                                .padding(.bottom, .xxSmall)
                        } else {
                            Illustration(illustration, layout: .resizeable)
                                .frame(height: 68)
                                .padding(.bottom, .xxSmall)
                        }

                        Heading(title, style: titleStyle, alignment: .center)
                            .accessibility(.choiceTileTitle)

                        Text(description, color: .inkLight, alignment: .center)
                            .accessibility(.choiceTileDescription)

                        Badge(badge, style: .neutral)
                            .accessibility(.choiceTileBadge)
                    }
                    .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity)
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
        Badge(badgeOverlay, style: .status(isError && isSelected ? .critical : .info, inverted: true))
            .alignmentGuide(.top) { dimensions in
                dimensions.height / 2
            }
    }

    @ViewBuilder var indicatorOverlay: some View {
        indicatorElement
            .disabled(true)
            .padding(.xxxSmall)
    }

    @ViewBuilder var indicatorElement: some View {
        switch indicator {
            case .none:         EmptyView()
            case .radio:        Radio(state: errorShouldHighlightIndicator ? .error : .normal, isChecked: shouldSelectIndicator)
            case .checkbox:     Checkbox(state: errorShouldHighlightIndicator ? .error : .normal, isChecked: shouldSelectIndicator)
        }
    }

    var isHeaderContentEmpty: Bool {
        title.isEmpty && description.isEmpty && iconContent.isEmpty && badge.isEmpty
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

    var indicatorAlignment: Alignment {
        switch alignment {
            case .default:      return .bottomTrailing
            case .center:       return .bottom
        }
    }
    
    var indicatorSize: CGFloat {
        switch indicator {
            case .none:             return 0
            case .radio:            return Radio.ButtonStyle.size
            case .checkbox:         return Checkbox.ButtonStyle.size
        }
    }
    
    var messagePadding: CGFloat {
        indicatorSize > 0
            ? (indicatorSize + padding + .xSmall)
            : 0
    }
}

// MARK: - Inits
public extension ChoiceTile {

    /// Creates Orbit ChoiceTile component over custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
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
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = icon
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
        self.content = content()
    }

    /// Creates Orbit ChoiceTile component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        illustration: Illustration.Image = .none,
        badge: String = "",
        badgeOverlay: String = "",
        indicator: ChoiceTileIndicator = .radio,
        titleStyle: Heading.Style = .title3,
        isSelected: Bool = false,
        isError: Bool = false,
        message: MessageType = .none,
        alignment: ChoiceTileAlignment = .default,
        action: @escaping () -> Void = {}
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
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
            content: { EmptyView() }
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
            sizing
            intrinsic

            storybook
            storybookCentered
            storybookMix
        }
        .padding(.medium)
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
            contentPlaceholder
        }
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    ChoiceTile("Height \(state.wrappedValue)", description: description, icon: .grid)
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    ChoiceTile("Height \(state.wrappedValue)", icon: .grid)
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    ChoiceTile(description: "Height \(state.wrappedValue)", icon: .grid)
                }
            }
            StateWrapper(initialState: CGFloat(0)) { state in
                ContentHeightReader(height: state) {
                    ChoiceTile("Height \(state.wrappedValue)")
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(Color.whiteNormal)
        .previewDisplayName("Sizing")
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
            contentPlaceholder
        }
        .previewDisplayName("Centered")
    }

    static var intrinsic: some View {
        ChoiceTile("Intrinsic", icon: .grid) {
            intrinsicContentPlaceholder
        }
        .idealSize()
    }

    static var storybook: some View {
        VStack(spacing: .medium) {
            content
        }
    }

    static var storybookCentered: some View {
        VStack(spacing: .medium) {
            contentCentered
        }
    }

    static var storybookMix: some View {
        VStack(spacing: .medium) {
            StateWrapper(initialState: false) { isSelected in
                ChoiceTile(
                    "Checkbox indictor with long and multiline title",
                    icon: .symbol(.grid, color: .greenNormal),
                    indicator: .checkbox,
                    isSelected: isSelected.wrappedValue,
                    message: .help("Info multiline and very very very very long message")
                ) {
                    isSelected.wrappedValue.toggle()
                } content: {
                    contentPlaceholder
                }
            }
            StateWrapper(initialState: false) { isSelected in
                ChoiceTile(
                    description: "Long and multiline description with no title",
                    icon: .countryFlag("cz"),
                    isSelected: isSelected.wrappedValue,
                    message: .warning("Warning multiline and very very very very long message")
                ) {
                    isSelected.wrappedValue.toggle()
                } content: {
                    contentPlaceholder
                }
            }
            StateWrapper(initialState: false) { isSelected in
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

    static var snapshot: some View {
        VStack(spacing: .medium) {
            standalone
            Separator()
            standaloneCentered
        }
        .padding(.medium)
    }

    static func choiceTile(titleStyle: Heading.Style, showHeader: Bool, isError: Bool, isSelected: Bool) -> some View {
        StateWrapper(initialState: isSelected) { state in
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
                alignment: .center
            ) {
                state.wrappedValue.toggle()
            } content: {
                contentPlaceholder
            }
        }
    }
}

struct ChoiceTileDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")

            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        ChoiceTilePreviews.standalone
    }
}
