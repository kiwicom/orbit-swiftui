import SwiftUI

public enum ListChoiceDisclosure {
    
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

/// Shows one of a selectable list of items with similar structures.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/listchoice/)
/// - Important: Component expands horizontally to infinity up to a ``Layout/readableMaxWidth``.
public struct ListChoice<Content: View>: View {

    let title: String
    let description: String
    let icon: Icon.Content
    let disclosure: ListChoiceDisclosure
    let backgroundColor: BackgroundColor?
    let showSeparator: Bool
    let action: () -> Void
    let content: () -> Content

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
            VStack(alignment: .leading, spacing: 0) {
                header
                content()
            }
            
            Spacer(minLength: 0)

            // Provide minimal height (frame(minHeight:) collapses multiline text in snapshots)
            Color.clear
                .frame(width: 0, height: 48)

            disclosureView
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
            descriptionStyle: .custom(.small),
            horizontalSpacing: .xSmall,
            verticalSpacing: .xxxSmall
        )
        .padding(.vertical, headerTextPadding)
        .padding(.leading, icon.isEmpty ? .medium : .small)
        .padding(.trailing, .medium)
    }

    @ViewBuilder var disclosureView: some View {
        switch disclosure {
            case .none:
                EmptyView()
            case .disclosure(let color):
                Icon(symbol: .chevronRight, size: .medium, color: color)
                    .padding(.trailing, -.xxSmall)
            case .button(let type):
                disclosureButton(type: type)
                    .padding(.vertical, .small)
                    .disabled(true)
            case .checkbox(let isChecked):
                Checkbox(isChecked: isChecked)
                    .disabled(true)
        }
    }
    
    @ViewBuilder func disclosureButton(type: ListChoiceDisclosure.ButtonType) -> some View {
        switch type {
            case .add:      Button(.plus, style: .primarySubtle, size: .small)
            case .remove:   Button(.close, style: .criticalSubtle, size: .small)
        }
    }

    @ViewBuilder var separator: some View {
        if showSeparator {
            HairlineSeparator()
                .padding(.leading, separatorPadding)
        }
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
    
    /// Creates Orbit ListChoice component with custom icon and content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content,
        disclosure: ListChoiceDisclosure = .disclosure(),
        backgroundColor: BackgroundColor? = nil,
        showSeparator: Bool = true,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.disclosure = disclosure
        self.backgroundColor = backgroundColor
        self.showSeparator = showSeparator
        self.action = action
        self.content = content
    }
    
    /// Creates Orbit ListChoice component with custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        backgroundColor: BackgroundColor? = nil,
        showSeparator: Bool = true,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            title,
            description: description,
            icon: .icon(icon, size: .default, color: .inkNormal),
            disclosure: disclosure,
            backgroundColor: backgroundColor,
            showSeparator: showSeparator,
            action: action,
            content: content
        )
    }
    
    /// Creates Orbit ListChoice component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content,
        disclosure: ListChoiceDisclosure = .disclosure(),
        backgroundColor: BackgroundColor? = nil,
        showSeparator: Bool = true,
        action: @escaping () -> Void = {}
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            disclosure: disclosure,
            backgroundColor: backgroundColor,
            showSeparator: showSeparator,
            action: action,
            content: { EmptyView() }
        )
    }
    
    /// Creates Orbit ListChoice component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        backgroundColor: BackgroundColor? = nil,
        showSeparator: Bool = true,
        action: @escaping () -> Void = {}
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: .icon(icon, size: .default, color: .inkNormal),
            disclosure: disclosure,
            backgroundColor: backgroundColor,
            showSeparator: showSeparator,
            action: action
        )
    }
}

// MARK: - Types
public extension ListChoice {
    
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
    static let addButton = ListChoiceDisclosure.button(type: .add)
    static let removeButton = ListChoiceDisclosure.button(type: .remove)
    static let uncheckedCheckbox = ListChoiceDisclosure.checkbox(isChecked: false)
    static let checkedCheckbox = ListChoiceDisclosure.checkbox(isChecked: true)
    
    static var plain: some View {
        VStack(spacing: .small) {
            ListChoice(title, disclosure: .none)
            ListChoice(title, description: description, disclosure: .none)
            ListChoice(title, description: "No Separator", disclosure: .none, showSeparator: false)
            ListChoice(title, icon: .airplane, disclosure: .none)
            ListChoice(title, icon: .icon(.airplane, size: .medium, color: .inkLighter), disclosure: .none)
            ListChoice(title, description: description, icon: .airplane, disclosure: .none)
            ListChoice(title, description: description, disclosure: .none) {
                customContentPlaceholder
            }
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
            ListChoice(title, description: description) {
                customContentPlaceholder
            }
        }
        .padding()
        .previewDisplayName("Chevron")
    }
    
    static var button: some View {
        VStack(spacing: .small) {
            ListChoice(title, disclosure: addButton)
            ListChoice(title, disclosure: removeButton)
            ListChoice(title, description: description, disclosure: addButton)
            ListChoice(title, description: description, disclosure: removeButton)
            ListChoice(title, icon: .airplane, disclosure: addButton)
            ListChoice(title, icon: .airplane, disclosure: removeButton)
            ListChoice(title, description: description, icon: .airplane, disclosure: addButton)
            ListChoice(title, description: description, icon: .airplane, disclosure: removeButton)
        }
        .padding()
        .previewDisplayName("Button")
    }

    static var checkbox: some View {
        VStack(spacing: .small) {
            ListChoice(title, disclosure: uncheckedCheckbox)
            ListChoice(title, disclosure: checkedCheckbox)
            ListChoice(title, description: description, disclosure: uncheckedCheckbox)
            ListChoice(title, description: description, disclosure: checkedCheckbox)
            ListChoice(title, icon: .airplane, disclosure: uncheckedCheckbox)
            ListChoice(title, icon: .airplane, disclosure: checkedCheckbox)
            ListChoice(title, description: description, icon: .airplane, disclosure: uncheckedCheckbox)
            ListChoice(title, description: description, icon: .airplane, disclosure: checkedCheckbox)
        }
        .padding()
        .previewDisplayName("Checkbox")
    }
}
