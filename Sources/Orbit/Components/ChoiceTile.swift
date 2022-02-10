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
    let status: Status?
    let isSelected: Bool

    /// Creates button style wrapper for ``ChoiceTile``.
    public init(
        indicator: ChoiceTileIndicator,
        alignment: ChoiceTileAlignment,
        status: Status?,
        isSelected: Bool
    ) {
        self.indicator = indicator
        self.alignment = alignment
        self.status = status
        self.isSelected = isSelected
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(indicatorOverlay, alignment: indicatorAlignment)
            .padding(ChoiceTileAlignment.padding)
            .tileBorder(
                status: isSelected && status == nil ? .info : status,
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
            case .radio:        Radio(state: status == .critical ? .error : .normal, isChecked: isSelected)
            case .checkbox:     Checkbox(state: status == .critical ? .error : .normal, isChecked: isSelected)
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
        if status != nil {
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
    let indicator: ChoiceTileIndicator
    let titleStyle: Header.TitleStyle
    let isSelected: Bool
    let status: Status?
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
                    footer
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, badgeOverlay.isEmpty ? 0 : .small)
            }
        )
        .buttonStyle(ChoiceTileButtonStyle(indicator: indicator, alignment: alignment, status: status, isSelected: isSelected))
        .accessibility(removeTraits: isSelected == false ? .isSelected : [])
        .accessibility(addTraits: isSelected ? .isSelected : [])
        .overlay(badgeOverlayView, alignment: .top)
    }
    
    @ViewBuilder var header: some View {
        switch alignment {
            case .default:
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Header(title, description: description, iconContent: iconContent, titleStyle: titleStyle, horizontalSpacing: .xSmall, verticalSpacing: .xxSmall)
                    Spacer(minLength: 0)
                    Badge(badge, style: .status(.info))
                }
            case .center:
                VStack(spacing: .xxSmall) {
                    iconContent.view()
                        .padding(.bottom, .xxxSmall)
                    centeredHeading
                    Text(description, color: .inkLight, alignment: .center)
                    Badge(badge, style: .neutral)
                }
                .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder var centeredHeading: some View {
        switch titleStyle {
            case .heading(let style, let color):           Heading(title, style: style, color: color, alignment: .center)
            case .text(let size, let weight, let color):   Text(title, size: size, color: color, weight: weight)
        }
    }
    
    @ViewBuilder var footer: some View {
        switch alignment {
            case .default:
                FormFieldMessage(message, spacing: .xSmall)
                    .padding(.trailing, footerPadding)
            case .center:
                FormFieldMessage(message, spacing: .xSmall)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, footerPadding)
        }
    }
    
    @ViewBuilder var badgeOverlayView: some View {
        Badge(badgeOverlay, style: .status(.info, inverted: true))
            .offset(y: -Badge.Size.default.height / 2)
    }

    var indicatorSize: CGSize {
        indicator == .radio
            ? Radio.ButtonStyle.size
            : Checkbox.ButtonStyle.size
    }
    
    var footerPadding: CGFloat {
        switch alignment {
            case .default:
                return indicatorSize.width > 0 ? (indicatorSize.width + ChoiceTileAlignment.padding) : 0
            case .center:
                return indicatorSize.height > 0 ? (indicatorSize.height + ChoiceTileAlignment.padding) : 0
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
        badge: String = "",
        badgeOverlay: String = "",
        indicator: ChoiceTileIndicator = .radio,
        titleStyle: Header.TitleStyle = .title3,
        isSelected: Bool = false,
        status: Status? = nil,
        message: MessageType = .none,
        alignment: ChoiceTileAlignment = .default,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = iconContent
        self.badge = badge
        self.badgeOverlay = badgeOverlay
        self.indicator = indicator
        self.titleStyle = titleStyle
        self.isSelected = isSelected
        self.status = status
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
        badge: String = "",
        badgeOverlay: String = "",
        indicator: ChoiceTileIndicator = .radio,
        titleStyle: Header.TitleStyle = .title3,
        isSelected: Bool = false,
        status: Status? = nil,
        message: MessageType = .none,
        alignment: ChoiceTileAlignment = .default,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            title,
            description: description,
            iconContent: .icon(icon, size: .header(titleStyle)),
            badge: badge,
            badgeOverlay: badgeOverlay,
            indicator: indicator,
            titleStyle: titleStyle,
            isSelected: isSelected,
            status: status,
            message: message,
            alignment: alignment,
            action: action,
            content: content
        )
    }
}

// MARK: - Previews
struct ChoiceTilePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapperWithState(initialState: false) { state in
            standalone
            standaloneCentered
            standaloneNarrow
            standaloneNarrowCentered

            snapshots
            snapshotsCentered

            VStack(spacing: .large) {
                ChoiceTile(
                    "ChoiceTile",
                    icon: .grid,
                    isSelected: state.wrappedValue,
                    message: .help("Helpful message"),
                    action: {
                        state.wrappedValue.toggle()
                    },
                    content: {
                        VStack(alignment: .leading) {
                            Heading("Label", style: .title4, color: .inkNormal)
                            Text("Tap to check or uncheck", size: .small, color: .inkLight)
                        }
                    }
                )
            }
            .padding()
            .previewDisplayName("Live Preview")
        }
        .previewLayout(PreviewLayout.sizeThatFits)
    }
    
    static var standalone: some View {
        ChoiceTile(
            "Title",
            description: "Description",
            icon: .grid,
            badge: "Popular",
            message: .help("Message")
        ) {
            customContentPlaceholder
        }
        .padding()
    }
    
    static var standaloneCentered: some View {
        ChoiceTile(
            "Title",
            description: "Description",
            icon: .grid,
            badge: "Included",
            badgeOverlay: "Recommended",
            message: .help("Message"),
            alignment: .center
        ) {
            customContentPlaceholder
        }
        .padding()
    }

    static var standaloneNarrow: some View {
        ChoiceTile(
            "Title with very long multiline text",
            description: "Description with very long text",
            icon: .grid,
            badge: "Popular",
            message: .help("Message with very long multiline text")
        ) {
            customContentPlaceholder
        }
        .frame(width: 200)
        .padding()
    }
    
    static var standaloneNarrowCentered: some View {
        ChoiceTile(
            "Title with very long multiline text",
            description: "Description with very long text",
            icon: .grid,
            badge: "Included",
            badgeOverlay: "Recommended",
            message: .help("Message with very long multiline text"),
            alignment: .center
        ) {
            customContentPlaceholder
        }
        .frame(width: 200)
        .padding()
    }

    static var snapshots: some View {
        VStack(spacing: .large) {
            HStack(alignment: .top, spacing: .medium) {
                VStack(alignment: .leading, spacing: .medium) {
                    ChoiceTile("Label", description: "Unchecked Radio", icon: .flightNomad, message: .help("Helpful message")) {}

                    ChoiceTile("Label", description: "Unchecked Checkbox", indicator: .checkbox, message: .help("Helpful message")) {}
                }

                VStack(alignment: .leading, spacing: .medium) {
                    ChoiceTile("Label", description: "Unchecked Checkbox", isSelected: true, message: .help("Helpful message")) {}

                    ChoiceTile("Label", description: "Checked Checkbox", indicator: .checkbox, isSelected: true, status: .critical, message: .error("Error message")) {}
                }
            }

            ChoiceTile(
                "Multiline long choice title label",
                description: "Multiline and very long description",
                icon: .grid,
                titleStyle: .title1,
                message: .help("Helpful multiline message")
            ) {
                customContentPlaceholder
            }
            .frame(maxWidth: 250)
            
            ChoiceTile("ChoiceTile", indicator: .radio, isSelected: true) {
                customContentPlaceholder
            }
            
            ChoiceTile(indicator: .checkbox, isSelected: false, status: .critical) {
                customContentPlaceholder
            }
            
            ChoiceTile(indicator: .none, isSelected: true) {
                customContentPlaceholder
            }
        }
        .padding()
    }
    
    static var snapshotsCentered: some View {
        VStack(spacing: .large) {
            HStack(alignment: .top, spacing: .medium) {
                VStack(alignment: .leading, spacing: .medium) {
                    ChoiceTile("Label", description: "Checked Radio", icon: .flightNomad, message: .help("Helpful message"), alignment: .center) {}

                    ChoiceTile("Label", description: "Unchecked Checkbox", indicator: .checkbox, message: .help("Helpful message"), alignment: .center) {}
                }

                VStack(alignment: .leading, spacing: .medium) {
                    ChoiceTile("Label", description: "Unchecked Radio", isSelected: true, message: .help("Helpful message"), alignment: .center) {}

                    ChoiceTile("Label", description: "Checked Checkbox", indicator: .checkbox, isSelected: true, status: .critical, message: .error("Error message"), alignment: .center) {}
                }
            }

            ChoiceTile(
                "Multiline long choice title label",
                description: "Multiline and very long description",
                icon: .grid,
                titleStyle: .title1,
                message: .help("Helpful multiline message"),
                alignment: .center
            ) {
                customContentPlaceholder
            }
            .frame(maxWidth: 250)
            
            ChoiceTile("ChoiceTile", indicator: .radio, isSelected: true, alignment: .center) {
                customContentPlaceholder
            }
            
            ChoiceTile(indicator: .checkbox, isSelected: true, alignment: .center) {
                customContentPlaceholder
            }
            
            ChoiceTile(indicator: .none, isSelected: true, alignment: .center) {
                customContentPlaceholder
            }
        }
        .padding()
    }
}
