import SwiftUI

/// Shows one of a selectable list of items with similar structures.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/listchoice/)
/// - Important: Component expands horizontally to infinity up to a ``Layout/readableMaxWidth``.
public struct ListChoice: View {

    let title: String
    let description: String
    let icon: Icon.Content
    let trailingElement: ListChoice.TrailingElement
    let backgroundColor: BackgroundColor?
    let action: () -> Void

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
        .buttonStyle(ListChoiceButtonStyle(backgroundColor: backgroundColor))
        .accessibility(label: SwiftUI.Text(title))
        .accessibility(hint: SwiftUI.Text(description))
    }

    var buttonContent: some View {
        HStack(spacing: 0) {
            header
                .frame(maxWidth: .infinity, alignment: .leading)

            // Provide minimal height (frame(minHeight:) collapses multiline text in snapshots)
            Color.clear
                .frame(width: 0, height: 48)

            trailingElementView
                .padding(.trailing, .medium)
        }
        .frame(maxWidth: Layout.readableMaxWidth, alignment: .leading)
        .overlay(separator, alignment: .bottom)
    }
    
    var header: some View {
        Header(
            title,
            description: description,
            iconContent: icon,
            titleStyle: .title4,
            descriptionSize: .small,
            horizontalSpacing: .xSmall,
            verticalSpacing: .xxxSmall
        )
        .padding(.vertical, headerTextPadding)
        .padding(.leading, icon.isEmpty ? .medium : .small)
        .padding(.trailing, .medium)
    }

    @ViewBuilder var trailingElementView: some View {
        switch trailingElement {
            case .none:
                EmptyView()
            case .disclosure(let color):
                Icon(symbol: .chevronRight, size: .medium, color: color)
            case .button(let type):
                trailingButton(type: type)
                    .padding(.vertical, .small)
                    .disabled(true)
            case .checkbox(let isChecked):
                Checkbox(isChecked: isChecked)
                    .disabled(true)
        }
    }
    
    @ViewBuilder func trailingButton(type: TrailingElement.ButtonType) -> some View {
        switch type {
            case .add:
                Button(.plus, style: .primarySubtle, size: .small)
            case .remove:
                Button(.close, style: .criticalSubtle, size: .small)
        }
    }

    var separator: some View {
        HairlineSeparator()
            .padding(.leading, separatorPadding)
    }

    var separatorPadding: CGFloat {
        icon.isEmpty ? .medium : .xxLarge
    }
    
    var isHeaderEmpty: Bool {
        title.isEmpty && description.isEmpty && icon.isEmpty
    }
    
    var headerTextPadding: CGFloat {
        title.isEmpty || description.isEmpty ? .medium : .small
    }
}

// MARK: - Inits
public extension ListChoice {
    
    /// Creates Orbit ListChoice component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        trailingElement: ListChoice.TrailingElement = .disclosure(),
        backgroundColor: BackgroundColor? = nil,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.description = description
        self.icon = .icon(icon, size: .default, color: .inkNormal)
        self.trailingElement = trailingElement
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    /// Creates Orbit ListChoice component with custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content,
        trailingElement: ListChoice.TrailingElement = .disclosure(),
        backgroundColor: BackgroundColor? = nil,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.trailingElement = trailingElement
        self.backgroundColor = backgroundColor
        self.action = action
    }
}

// MARK: - Types
public extension ListChoice {
    
    enum TrailingElement {
        
        public enum ButtonType {
            case add
            case remove
        }
        
        case none
        /// An iOS-style disclosure indicator.
        case disclosure(Color = .cloudDarker)
        /// A non-interactive button.
        case button(type: ButtonType)
        /// A non-interactive checkbox.
        case checkbox(isChecked: Bool = true)
    }

    typealias BackgroundColor = (normal: Color, active: Color)
}

extension ListChoice {
    
    // Button style wrapper for ListChoice.
    // Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
    struct ListChoiceButtonStyle: SwiftUI.ButtonStyle {

        let backgroundColor: ListChoice.BackgroundColor?

        public init(backgroundColor: ListChoice.BackgroundColor? = nil) {
            self.backgroundColor = backgroundColor
        }

        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(backgroundColor(isPressed: configuration.isPressed))
        }

        func backgroundColor(isPressed: Bool) -> Color {
            switch (backgroundColor, isPressed) {
                case (let backgroundColor?, true):          return backgroundColor.active
                case (let backgroundColor?, false):         return backgroundColor.normal
                case (.none, true):                         return .whiteHover
                case (.none, false):                        return .white
            }
        }
    }
}

// MARK: - Previews
struct ListChoicePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            plain
            chevron
            button
            checkbox
        }
        .background(Color.cloudLight.opacity(0.8))
        .previewLayout(.sizeThatFits)
    }
    
    static let title = "ListChoice tile"
    static let description = "Further description"
    static let addButton = ListChoice.TrailingElement.button(type: .add)
    static let removeButton = ListChoice.TrailingElement.button(type: .remove)
    static let uncheckedCheckbox = ListChoice.TrailingElement.checkbox(isChecked: false)
    static let checkedCheckbox = ListChoice.TrailingElement.checkbox(isChecked: true)
    
    static var plain: some View {
        VStack(spacing: .small) {
            ListChoice(title, trailingElement: .none)
            ListChoice(title, description: description, trailingElement: .none)
            ListChoice(title, icon: .airplane, trailingElement: .none)
            ListChoice(title, description: description, icon: .airplane, trailingElement: .none)
        }
        .padding()
        .previewDisplayName("No disclosure")
    }
    
    static var chevron: some View {
        VStack(spacing: .small) {
            ListChoice(title)
            ListChoice(title, description: description)
            ListChoice(title, icon: .airplane)
            ListChoice(title, description: description, icon: .airplane)
        }
        .padding()
        .previewDisplayName("Chevron")
    }
    
    static var button: some View {
        VStack(spacing: .small) {
            ListChoice(title, trailingElement: addButton)
            ListChoice(title, trailingElement: removeButton)
            ListChoice(title, description: description, trailingElement: addButton)
            ListChoice(title, description: description, trailingElement: removeButton)
            ListChoice(title, icon: .airplane, trailingElement: addButton)
            ListChoice(title, icon: .airplane, trailingElement: removeButton)
            ListChoice(title, description: description, icon: .airplane, trailingElement: addButton)
            ListChoice(title, description: description, icon: .airplane, trailingElement: removeButton)
        }
        .padding()
        .previewDisplayName("Button")
    }

    static var checkbox: some View {
        VStack(spacing: .small) {
            ListChoice(title, trailingElement: uncheckedCheckbox)
            ListChoice(title, trailingElement: checkedCheckbox)
            ListChoice(title, description: description, trailingElement: uncheckedCheckbox)
            ListChoice(title, description: description, trailingElement: checkedCheckbox)
            ListChoice(title, icon: .airplane, trailingElement: uncheckedCheckbox)
            ListChoice(title, icon: .airplane, trailingElement: checkedCheckbox)
            ListChoice(title, description: description, icon: .airplane, trailingElement: uncheckedCheckbox)
            ListChoice(title, description: description, icon: .airplane, trailingElement: checkedCheckbox)
        }
        .padding()
        .previewDisplayName("Checkbox")
    }
}
