import SwiftUI

public enum ListChoiceDisclosure: Equatable {
    
    public enum ButtonType {
        case add
        case remove
    }
    
    case none
    /// An iOS-style disclosure indicator.
    case disclosure(Color = .inkLight)
    /// A non-interactive button.
    case button(type: ButtonType)
    /// A non-interactive checkbox.
    case checkbox(isChecked: Bool = true)
}

/// Shows one of a selectable list of items with similar structures.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/listchoice/)
/// - Important: Component expands horizontally up to ``Layout/readableMaxWidth``.
public struct ListChoice<Content: View>: View {

    let title: String
    let description: String
    let icon: Icon.Content
    let disclosure: ListChoiceDisclosure
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
                HStack(spacing: .medium) {
                    headerWithValue
                    
                    disclosureView
                        .padding(.trailing, .medium)
                }
                .frame(maxWidth: Layout.readableMaxWidth, alignment: .leading)
                .overlay(separator, alignment: .bottom)
            }
        )
        .buttonStyle(ListChoiceButtonStyle())
        .accessibility(label: SwiftUI.Text(title))
        .accessibility(hint: SwiftUI.Text(description))
        .accessibility(removeTraits: accessibilityTraitsToRemove)
        .accessibility(addTraits: accessibilityTraitsToAdd)
    }
    
    @ViewBuilder var headerWithValue: some View {
        HStack(spacing: 0) {
            header
            if isHeaderEmpty == false {
                Spacer(minLength: .xSmall)
            }
            Strut(height: 48)
            content()
        }
        .padding(.leading, .medium)
        .padding(.trailing, disclosure == .none ? .medium : 0)
    }
    
    @ViewBuilder var header: some View {
        Header(
            title,
            description: description,
            iconContent: icon,
            titleStyle: .title4,
            descriptionStyle: .custom(.small),
            horizontalSpacing: .xSmall,
            verticalSpacing: .xxxSmall
        )
        .padding(.vertical, .small)
    }

    @ViewBuilder var disclosureView: some View {
        switch disclosure {
            case .none:
                EmptyView()
            case .disclosure(let color):
                Icon(symbol: .chevronRight, size: .medium, color: color)
                    .padding(.leading, -.xSmall)
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
        if isHeaderEmpty {
            return 0
        }
        
        if icon.isEmpty {
            return .medium
        }
        
        return .xxLarge
    }
    
    var isHeaderEmpty: Bool {
        icon.isEmpty && title.isEmpty && description.isEmpty
    }
    
    var accessibilityTraitsToAdd: AccessibilityTraits {
        switch disclosure {
            case .none, .disclosure, .button, .checkbox(false):     return []
            case .checkbox(true):                                   return .isSelected
        }
    }
    
    var accessibilityTraitsToRemove: AccessibilityTraits {
        switch disclosure {
            case .none, .disclosure, .button, .checkbox(true):      return []
            case .checkbox(false):                                  return .isSelected
        }
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
        showSeparator: Bool = true,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.disclosure = disclosure
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
        showSeparator: Bool = true,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            title,
            description: description,
            icon: .icon(icon, size: .default, color: .inkNormal),
            disclosure: disclosure,
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
        showSeparator: Bool = true,
        action: @escaping () -> Void = {}
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            disclosure: disclosure,
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
        showSeparator: Bool = true,
        action: @escaping () -> Void = {}
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: .icon(icon, size: .default, color: .inkNormal),
            disclosure: disclosure,
            showSeparator: showSeparator,
            action: action
        )
    }
    
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content,
        value: String,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {}
    ) where Content == Heading {
        self.title = title
        self.description = description
        self.icon = icon
        self.disclosure = disclosure
        self.showSeparator = showSeparator
        self.action = action
        self.content = { Heading(value, style: .title4) }
    }
    
    /// Creates Orbit ListChoice component with custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        value: String,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {}
    ) where Content == Heading {
        self.init(
            title,
            description: description,
            icon: .icon(icon, size: .default, color: .inkNormal),
            value: value,
            disclosure: disclosure,
            showSeparator: showSeparator,
            action: action
        )
    }
}

extension ListChoice {
    
    // Button style wrapper for ListChoice.
    // Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
    struct ListChoiceButtonStyle: SwiftUI.ButtonStyle {

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(
                    backgroundColor(isPressed: configuration.isPressed)
                        .contentShape(Rectangle())
                )
        }

        func backgroundColor(isPressed: Bool) -> Color {
            isPressed ? .inkLight.opacity(0.08) : .clear
        }
    }
}

// MARK: - Previews
struct ListChoicePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            plain
            chevron
            button
            checkbox
            white
            backgroundColor
        }
        .background(Color.cloudLight)
        .previewLayout(.sizeThatFits)
    }
    
    static let title = "ListChoice tile"
    static let description = "Further description"
    static let value = "value"
    static let badge = Badge("3", style: .status(.info, inverted: false))
    static let addButton = ListChoiceDisclosure.button(type: .add)
    static let removeButton = ListChoiceDisclosure.button(type: .remove)
    static let uncheckedCheckbox = ListChoiceDisclosure.checkbox(isChecked: false)
    static let checkedCheckbox = ListChoiceDisclosure.checkbox(isChecked: true)
    
    static var standalone: some View {
        ListChoice(title, description: description, icon: .grid, value: "100")
    }
    
    static var plain: some View {
        ListChoiceGroup {
            ListChoice(title, disclosure: .none)
            ListChoice(title, description: description, disclosure: .none)
            ListChoice(title, description: "No Separator", disclosure: .none, showSeparator: false)
            ListChoice(title, icon: .airplane, disclosure: .none)
            ListChoice(title, icon: .icon(.airplane, size: .medium, color: .inkLighter), disclosure: .none)
            ListChoice(title, description: description, icon: .airplane, disclosure: .none)
            ListChoice(title, description: description, icon: .airplane, value: value, disclosure: .none)
            ListChoice(title, description: description, disclosure: .none) {
                badge
            }
            ListChoice(disclosure: .none) {
                customContentPlaceholder
            }
            .padding(.bottom)
        }
        .previewDisplayName("No disclosure")
    }
    
    static var chevron: some View {
        ListChoiceGroup {
            ListChoice(title)
            ListChoice(title, value: "10")
            ListChoice(title, description: description)
            ListChoice(title, description: "Multiline\ndescription", value: "USD")
            ListChoice(title, icon: .airplane)
            ListChoice(title, icon: .airplane, value: value)
            ListChoice(title, description: description, icon: .airplane)
            ListChoice(title, description: description, icon: .airplane, value: value)
            ListChoice(title, description: description) {
                badge
            }
            ListChoice(title, description: description, icon: .grid) {
                badge
            }
        }
        .previewDisplayName("Chevron")
    }
    
    static var button: some View {
        ListChoiceGroup {
            ListChoice(title, disclosure: addButton)
            ListChoice(title, disclosure: removeButton)
            ListChoice(title, description: description, disclosure: addButton)
            ListChoice(title, description: description, disclosure: removeButton)
            ListChoice(title, icon: .airplane, disclosure: addButton)
            ListChoice(title, icon: .airplane, disclosure: removeButton)
            ListChoice(title, description: description, icon: .airplane, disclosure: addButton)
            ListChoice(title, description: description, icon: .airplane, disclosure: removeButton)
            ListChoice(title, description: description, icon: .airplane, value: value, disclosure: addButton)
            ListChoice(title, description: description, icon: .airplane, disclosure: removeButton) {
                customContentPlaceholder
            }
        }
        .previewDisplayName("Button")
    }

    static var checkbox: some View {
        ListChoiceGroup {
            ListChoice(title, disclosure: uncheckedCheckbox)
            ListChoice(title, disclosure: checkedCheckbox)
            ListChoice(title, description: description, disclosure: uncheckedCheckbox)
            ListChoice(title, description: description, disclosure: checkedCheckbox)
            ListChoice(title, icon: .airplane, disclosure: uncheckedCheckbox)
            ListChoice(title, icon: .airplane, disclosure: checkedCheckbox)
            ListChoice(title, description: description, icon: .airplane, disclosure: uncheckedCheckbox)
            ListChoice(title, description: description, icon: .airplane, disclosure: checkedCheckbox)
            ListChoice(title, description: description, icon: .airplane, value: value, disclosure: uncheckedCheckbox)
            ListChoice(title, description: description, icon: .airplane, disclosure: checkedCheckbox) {
                customContentPlaceholder
            }
        }
        .previewDisplayName("Checkbox")
    }
    
    static var white: some View {
        VStack(spacing: .small) {
            ListChoice(title, disclosure: .none)
                .background(Color.white)
            ListChoice(title, description: description, disclosure: .none)
                .background(Color.white)
            ListChoice(title, description: "No Separator", disclosure: .none, showSeparator: false)
                .background(Color.white)
            ListChoice(title, icon: .airplane, disclosure: .none)
                .background(Color.white)
            ListChoice(title, icon: .icon(.airplane, size: .medium, color: .inkLighter), disclosure: .none)
                .background(Color.white)
            ListChoice(title, description: description, icon: .airplane, disclosure: .none)
                .background(Color.white)
            ListChoice(title, description: description, disclosure: .none) {
                customContentPlaceholder
            }
            .background(Color.white)
        }
        .padding()
        .previewDisplayName("White background")
    }
    
    static var backgroundColor: some View {
        VStack(spacing: .small) {
            ListChoice(title, value: value, disclosure: .none)
                .background(Color.orangeLight)
            
            ListChoice(title, icon: .grid, value: value)
                .background(Color.blueLight)
            
            ListChoice(title, icon: .grid) {
                customContentPlaceholder
            }
            .background(Color.redLight)
        }
        .padding()
        .previewDisplayName("Custom background")
    }
}
