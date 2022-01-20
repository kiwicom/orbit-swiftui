import SwiftUI

public enum ChoiceTileIndicator {
    case none
    case radio
    case checkbox
}

/// Button style wrapper for ``ChoiceTile``.
/// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
public struct ChoiceTileButtonStyle: SwiftUI.ButtonStyle {

    let indicator: ChoiceTileIndicator
    let status: Status?
    let isSelected: Bool

    /// Creates button style wrapper for ``ChoiceTile``.
    public init(
        indicator: ChoiceTileIndicator,
        status: Status?,
        isSelected: Bool
    ) {
        self.indicator = indicator
        self.status = status
        self.isSelected = isSelected
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(indicatorOverlay.disabled(true), alignment: .bottomTrailing)
            .padding(.medium)
            .tileBorder(
                status: isSelected ? .info : nil,
                backgroundColor: backgroundColor(isPressed: configuration.isPressed),
                shadow: shadow(isPressed: configuration.isPressed))
    }

    @ViewBuilder var indicatorOverlay: some View {
        switch indicator {
            case .none:         EmptyView()
            case .radio:        Radio(isChecked: isSelected, action: {})
            case .checkbox:     Checkbox(isChecked: isSelected, action: {})
        }
    }
    
    func backgroundColor(isPressed: Bool) -> Color {
        isPressed ? .whiteHover : .white
    }
    
    func shadow(isPressed: Bool) -> TileBorderModifier.Shadow {
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
    let iconContent: Icon.Content
    let indicator: ChoiceTileIndicator
    let titleStyle: Heading.Style
    let isSelected: Bool
    let status: Status?
    let message: MessageType
    let action: () -> Void
    let content: () -> Content

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.3))
                action()
            },
            label: {
                VStack(alignment: .leading, spacing: .medium) {
                    Header(title, description: description, iconContent: iconContent, titleStyle: titleStyle)

                    content()

                    FormFieldMessage(message, spacing: .xSmall)
                        .padding(.trailing, .medium + indicatorWidth)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        )
        .buttonStyle(ChoiceTileButtonStyle(indicator: indicator, status: status, isSelected: isSelected))
        .accessibility(removeTraits: isSelected == false ? .isSelected : [])
        .accessibility(addTraits: isSelected ? .isSelected : [])
    }

    var indicatorWidth: CGFloat {
        indicator == .radio
            ? Radio.ButtonStyle.size.width
            : Checkbox.ButtonStyle.size.width
    }
}

// MARK: - Inits
public extension ChoiceTile {

    /// Creates Orbit ChoiceTile component over custom content.
    init(
        _ title: String = "",
        description: String = "",
        iconContent: Icon.Content,
        indicator: ChoiceTileIndicator = .radio,
        titleStyle: Heading.Style = .title3,
        isSelected: Bool = false,
        status: Status? = nil,
        message: MessageType = .none,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.iconContent = iconContent
        self.indicator = indicator
        self.message = message
        self.titleStyle = titleStyle
        self.isSelected = isSelected
        self.status = status
        self.action = action
        self.content = content
    }

    /// Creates Orbit ChoiceTile component over custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        indicator: ChoiceTileIndicator = .radio,
        titleStyle: Heading.Style = .title3,
        isSelected: Bool = false,
        status: Status? = nil,
        message: MessageType = .none,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            title,
            description: description,
            iconContent: .icon(icon, size: .heading(titleStyle)),
            indicator: indicator,
            titleStyle: titleStyle,
            isSelected: isSelected,
            status: status,
            message: message,
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

            snapshots

            VStack(spacing: .large) {
                ChoiceTile(
                    "ChoiceTile",
                    icon: .email,
                    indicator: .radio,
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
        ChoiceTile("ChoiceTile heading", description: "Description", icon: .email, indicator: .checkbox, message: .help("Message")) {
            customContentPlaceholder
        }
        .padding()
    }

    static var snapshots: some View {
        VStack(spacing: .large) {
            HStack(alignment: .top, spacing: .medium) {
                VStack(alignment: .leading, spacing: .medium) {
                    ChoiceTile("Label", icon: .flightNomad, indicator: .radio, message: .help("Helpful message")) {
                        Text("Unchecked Radio", size: .small, color: .inkLight)
                    }

                    ChoiceTile("Label", indicator: .checkbox, message: .help("Helpful message")) {
                        Text("Unchecked Checkbox", size: .small, color: .inkLight)
                    }
                }

                VStack(alignment: .leading, spacing: .medium) {
                    ChoiceTile("Label", indicator: .radio, isSelected: true, message: .help("Helpful message")) {
                        Text("Checked Checkbox", size: .small, color: .inkLight)
                    }

                    ChoiceTile("Label", indicator: .checkbox, isSelected: true, message: .error("Error message")) {
                        Text("Checked Checkbox", size: .small, color: .inkLight)
                    }
                }
            }

            ChoiceTile(
                "Multiline long choice title label",
                description: "Multiline and very long description",
                icon: .baggageSet,
                indicator: .radio,
                titleStyle: .title1,
                message: .help("Helpful multiline message")
            ) {
                customContentPlaceholder
            }
            .frame(maxWidth: 250)
            
            ChoiceTile("ChoiceTile", indicator: .radio, isSelected: true) {
                customContentPlaceholder
            }
            
            ChoiceTile(indicator: .checkbox, isSelected: true) {
                customContentPlaceholder
            }
            
            ChoiceTile(indicator: .none, isSelected: true) {
                customContentPlaceholder
            }
        }
        .padding()
    }
}
