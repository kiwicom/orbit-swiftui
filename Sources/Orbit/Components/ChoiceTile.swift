import SwiftUI

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
    let iconContent: Icon.Content
    let style: Style
    let isSelected: Bool
    let message: MessageType
    let action: () -> Void
    let content: () -> Content

    public var body: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Heading(title, iconContent: iconContent, style: .title3)

            content()

            FormFieldMessage(message, spacing: .xSmall)
                .padding(.trailing, .medium + indicatorWidth)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            indicator
                .disabled(true),
            alignment: .bottomTrailing
        )
        .padding(.medium)
        .tileBorder(status: isSelected ? .info : nil, backgroundColor: .white, shadowSize: .small)
        .onTapGesture {
            action()
        }
        .accessibility(addTraits: .isButton)
        .accessibility(removeTraits: isSelected == false ? .isSelected : [])
        .accessibility(addTraits: isSelected ? .isSelected : [])
    }

    @ViewBuilder var indicator: some View {
        switch style {
            case .radio:    Radio(isChecked: isSelected, action: {})
            case .checkbox: Checkbox(isChecked: isSelected, action: {})
        }
    }

    var indicatorWidth: CGFloat {
        style == .radio ? Radio.ButtonStyle.size.width : Checkbox.ButtonStyle.size.width
    }
}

// MARK: - Inits
public extension ChoiceTile {

    /// Creates Orbit ChoiceTile wrapper component over custom content.
    init(
        _ title: String = "",
        iconContent: Icon.Content = .none,
        style: Style = .radio,
        isSelected: Bool = false,
        message: MessageType = .none,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.iconContent = iconContent
        self.message = message
        self.style = style
        self.isSelected = isSelected
        self.action = action
        self.content = content
    }

    /// Creates Orbit ChoiceTile wrapper component over custom content.
    init(
        _ title: String = "",
        icon: Icon.Symbol,
        style: Style = .radio,
        isSelected: Bool = false,
        message: MessageType = .none,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.iconContent = .icon(icon, size: .default)
        self.message = message
        self.style = style
        self.isSelected = isSelected
        self.action = action
        self.content = content
    }
}

// MARK: - Types
public extension ChoiceTile {

    enum Style {
        case radio
        case checkbox
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
                    style: .radio,
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
        ChoiceTile("ChoiceTile heading", icon: .email, style: .checkbox, message: .help("Message")) {
            Color.productLight
                .frame(height: 80)
                .overlay(Text("Custom ChoiceTile content", color: .inkLight))
        }
    }

    static var snapshots: some View {
        VStack(spacing: .large) {
            HStack(alignment: .top, spacing: .medium) {
                VStack(alignment: .leading, spacing: .medium) {
                    ChoiceTile("Label", icon: .flightNomad, style: .radio, message: .help("Helpful message")) {
                        Text("Unchecked Radio", size: .small, color: .inkLight)
                    }

                    ChoiceTile("Label", style: .checkbox, message: .help("Helpful message")) {
                        Text("Unchecked Checkbox", size: .small, color: .inkLight)
                    }
                }

                VStack(alignment: .leading, spacing: .medium) {
                    ChoiceTile("Label", style: .radio, isSelected: true, message: .help("Helpful message")) {
                        Text("Checked Checkbox", size: .small, color: .inkLight)
                    }

                    ChoiceTile("Label", style: .checkbox, isSelected: true, message: .error("Error message")) {
                        Text("Checked Checkbox", size: .small, color: .inkLight)
                    }
                }
            }

            Separator()

            ChoiceTile(style: .radio, message: .help("Helpful multiline message")) {
                VStack(alignment: .leading) {
                    Heading("Multiline long choice title label", style: .title4, color: .inkNormal)
                    Text("Multiline and very long description", size: .small, color: .inkLight)
                }
            }
            .frame(maxWidth: 180)
        }
        .frame(width: 500)
        .padding()
    }
}
