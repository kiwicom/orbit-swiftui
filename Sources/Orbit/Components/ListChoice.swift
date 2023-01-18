import SwiftUI

public enum ListChoiceDisclosure: Equatable {
    
    public enum ButtonType {
        case add
        case remove
    }
    
    case none
    /// An iOS-style disclosure indicator.
    case disclosure(Color = .inkNormal)
    /// A non-interactive button.
    case button(type: ButtonType)
    /// A non-interactive ButtonLink.
    case buttonLink(String, style: ButtonLink.Style = .primary)
    /// A non-interactive checkbox.
    case checkbox(isChecked: Bool = true, state: Checkbox.State = .normal)
    /// A non-interactive radio.
    case radio(isChecked: Bool = true, state: Radio.State = .normal)
    /// An icon content.
    case icon(Icon.Content)
}

/// Shows one of a selectable list of items with similar structures.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/listchoice/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct ListChoice<HeaderContent: View, Content: View>: View {

    public let verticalPadding: CGFloat = .small + 0.5 // = 45 height @ normal size

    @Environment(\.idealSize) var idealSize

    let title: String
    let description: String
    let iconContent: Icon.Content
    let value: String
    let disclosure: ListChoiceDisclosure
    let showSeparator: Bool
    let action: () -> Void
    @ViewBuilder let content: Content
    @ViewBuilder let headerContent: HeaderContent

    public var body: some View {
        if isEmpty == false {
            SwiftUI.Button(
                action: {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                    action()
                },
                label: {
                    buttonContent
                }
            )
            .buttonStyle(ListChoiceButtonStyle())
            .accessibilityElement(children: .ignore)
            .accessibility(label: .init(title))
            .accessibility(value: .init(value))
            .accessibility(hint: .init(description))
            .accessibility(addTraits: .isButton)
            .accessibility(addTraits: accessibilityTraitsToAdd)
        }
    }

    @ViewBuilder var buttonContent: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                header
                content
            }

            TextStrut(.normal)
                .padding(.vertical, verticalPadding)

            disclosureView
                .padding(.horizontal, .medium)
                .padding(.vertical, .small)
                .allowsHitTesting(false)
        }
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .leading)
        .overlay(separator, alignment: .bottom)
    }
    
    @ViewBuilder var header: some View {
        if isHeaderEmpty == false || isCustomHeaderEmpty == false {
            HStack(spacing: 0) {
                headerTexts

                if isHeaderEmpty == false, idealSize.horizontal == nil {
                    Spacer(minLength: 0)
                }

                headerContent
                    .padding(.leading, .xSmall)
                    .padding(.leading, isHeaderEmpty ? .medium : 0)
                    .padding(.trailing, disclosure == .none ? .medium : 0)
                    .accessibility(.listChoiceValue)
            }
        }
    }
    
    @ViewBuilder var headerTexts: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .top, spacing: .xSmall) {
                Icon(content: iconContent)
                    .foregroundColor(.inkDark)
                    .accessibility(.listChoiceIcon)
                
                if isHeaderTextEmpty == false {
                    VStack(alignment: .leading, spacing: .xxxSmall) {
                        Text(title, weight: .medium)
                            .accessibility(.listChoiceTitle)
                        Text(description, size: .small, color: .inkNormal)
                            .accessibility(.listChoiceDescription)
                    }
                }
            }
            .padding(.leading, .medium)
            .padding(.vertical, verticalPadding)
        }
    }

    @ViewBuilder var disclosureView: some View {
        switch disclosure {
            case .none:
                EmptyView()
            case .disclosure(let color):
                Icon(.chevronRight, color: color)
                    .padding(.leading, -.xSmall)
            case .button(let type):
                disclosureButton(type: type)
            case .buttonLink(let label, let style):
                ButtonLink(label, style: style)
            case .checkbox(let isChecked, let state):
                Checkbox(state: state, isChecked: isChecked)
            case .radio(let isChecked, let state):
                Radio(state: state, isChecked: isChecked)
            case .icon(let content):
                Icon(content: content)
        }
    }
    
    @ViewBuilder func disclosureButton(type: ListChoiceDisclosure.ButtonType) -> some View {
        switch type {
            case .add:      Button(.plus, style: .primarySubtle, size: .small).fixedSize()
            case .remove:   Button(.close, style: .criticalSubtle, size: .small).fixedSize()
        }
    }

    @ViewBuilder var separator: some View {
        if showSeparator {
            Separator()
                .padding(.leading, separatorPadding)
        }
    }

    var separatorPadding: CGFloat {
        if isHeaderEmpty {
            return 0
        }
        
        if iconContent.isEmpty {
            return .medium
        }
        
        return .xxLarge
    }

    var isEmpty: Bool {
        isHeaderEmpty && isCustomHeaderEmpty && isCustomContentEmpty && disclosure == .none
    }
    
    var isHeaderEmpty: Bool {
        iconContent.isEmpty && isHeaderTextEmpty
    }

    var isCustomHeaderEmpty: Bool {
        headerContent is EmptyView
    }

    var isCustomContentEmpty: Bool {
        content is EmptyView
    }

    var isHeaderTextEmpty: Bool {
        title.isEmpty && description.isEmpty
    }
    
    var accessibilityTraitsToAdd: AccessibilityTraits {
        switch disclosure {
            case .none, .disclosure, .button(.add), .buttonLink, .checkbox(false, _), .radio(false, _), .icon:
                return []
            case .button(.remove), .checkbox(true, _), .radio(true, _):
                return .isSelected
        }
    }

    private init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        value: String = "",
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content,
        @ViewBuilder headerContent: () -> HeaderContent
    ) {
        self.title = title
        self.description = description
        self.value = value
        self.iconContent = icon
        self.disclosure = disclosure
        self.showSeparator = showSeparator
        self.action = action
        self.content = content()
        self.headerContent = headerContent()
    }
}

// MARK: - Inits
public extension ListChoice {
    
    /// Creates Orbit ListChoice component with custom content and vertically centered header content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content,
        @ViewBuilder headerContent: () -> HeaderContent
    ) {
        self.init(
            title,
            description: description,
            icon: icon,
            value: "",
            disclosure: disclosure,
            showSeparator: showSeparator,
            action: action,
            content: content,
            headerContent: headerContent
        )
    }

    /// Creates Orbit ListChoice component with optional vertically centered header content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {},
        @ViewBuilder headerContent: () -> HeaderContent
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            disclosure: disclosure,
            showSeparator: showSeparator,
            action: action,
            content: { EmptyView() },
            headerContent: headerContent
        )
    }

    /// Creates Orbit ListChoice component with optional content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) where HeaderContent == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            disclosure: disclosure,
            showSeparator: showSeparator,
            action: action,
            content: content
        ) {
            EmptyView()
        }
    }

    /// Creates Orbit ListChoice component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {}
    ) where HeaderContent == EmptyView, Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            disclosure: disclosure,
            showSeparator: showSeparator,
            action: action
        ) {
            EmptyView()
        } headerContent: {
            EmptyView()
        }
    }
}

public extension ListChoice where HeaderContent == Text {

    /// Creates Orbit ListChoice component with text based header value and optional custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        value: String,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            title,
            description: description,
            icon: icon,
            value: value,
            disclosure: disclosure,
            showSeparator: showSeparator,
            action: action,
            content: content
        ) {
            Text(value, weight: .medium)
        }
    }

    /// Creates Orbit ListChoice component with text based header value.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        value: String,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {}
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            value: value,
            disclosure: disclosure,
            showSeparator: showSeparator,
            action: action,
            content: { EmptyView() }
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
            isPressed ? .inkNormal.opacity(0.06) : .clear
        }
    }
}

// MARK: - Identifiers
public extension AccessibilityID {

    static let listChoiceTitle          = Self(rawValue: "orbit.listchoice.title")
    static let listChoiceIcon           = Self(rawValue: "orbit.listchoice.icon")
    static let listChoiceDescription    = Self(rawValue: "orbit.listchoice.description")
    static let listChoiceValue          = Self(rawValue: "orbit.listchoice.value")
}

// MARK: - Previews
struct ListChoicePreviews: PreviewProvider {

    static let title = "ListChoice tile"
    static let description = "Further description"
    static let value = "Value"
    static let badge = Badge("3", style: .status(.info, inverted: false))
    static let addButton = ListChoiceDisclosure.button(type: .add)
    static let removeButton = ListChoiceDisclosure.button(type: .remove)
    static let uncheckedCheckbox = ListChoiceDisclosure.checkbox(isChecked: false)
    static let checkedCheckbox = ListChoiceDisclosure.checkbox(isChecked: true)

    static var previews: some View {
        PreviewWrapper {
            standalone
            intrinsic
            sizing
            plain
            checkbox
            radio
            mix
            buttons
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack(spacing: 0) {
            ListChoice(title, description: description, icon: .grid) {
                contentPlaceholder
            } headerContent: {
                headerPlaceholder
            }

            // Empty
            ListChoice(disclosure: .none)
        }
        .previewDisplayName()
    }

    static var intrinsic: some View {
        ListChoice(title, description: description, icon: .grid) {
            intrinsicContentPlaceholder
        } headerContent: {
            intrinsicContentPlaceholder
        }
        .idealSize()
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            Group {
                ListChoice("ListChoice", description: description, icon: .grid, value: value)
                ListChoice("ListChoice", icon: .grid, value: value)
                ListChoice(icon: .grid)
                ListChoice("ListChoice", disclosure: .none)
                ListChoice(description: "ListChoice", disclosure: .none)
                ListChoice("ListChoice")
            }
            .border(Color.cloudLight)
            .measured()
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var mix: some View {
        Card(contentLayout: .fill) {
            ListChoice(title)
            ListChoice(title, value: "10")
            ListChoice(title, description: description)
            ListChoice(title, description: "Multiline\ndescription", value: "USD")
            ListChoice(title, icon: .airplane)
            ListChoice(title, icon: .airplane, value: value)
            ListChoice(title, description: description, icon: .airplane)
            ListChoice(title, description: description, icon: .airplane, value: value)
            ListChoice(title, description: description, headerContent: {
                badge
            })
            ListChoice(title, description: description, icon: .grid, headerContent: {
                badge
            })
        }
        .previewDisplayName()
    }
    
    static var buttons: some View {
        Card(contentLayout: .fill) {
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
                contentPlaceholder
            } headerContent: {
                headerPlaceholder
            }
        }
        .previewDisplayName()
    }

    static var checkbox: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, disclosure: uncheckedCheckbox)
            ListChoice(title, disclosure: checkedCheckbox)
            ListChoice(title, description: description, disclosure: .checkbox(state: .error))
            ListChoice(title, description: description, disclosure: .checkbox())
                .disabled(true)
            ListChoice(title, icon: .airplane, disclosure: .checkbox(isChecked: false, state: .error))
            ListChoice(title, icon: .airplane, disclosure: .checkbox(isChecked: false))
                .disabled(true)
            ListChoice(title, description: description, icon: .airplane, disclosure: uncheckedCheckbox)
            ListChoice(title, description: description, icon: .airplane, disclosure: checkedCheckbox)
            ListChoice(title, description: description, icon: .airplane, value: value, disclosure: uncheckedCheckbox)
            ListChoice(title, description: description, icon: .airplane, disclosure: checkedCheckbox) {
                contentPlaceholder
            } headerContent: {
                headerPlaceholder
            }
        }
        .previewDisplayName()
    }

    static var radio: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, description: description, disclosure: .radio(isChecked: false))
            ListChoice(title, description: description, disclosure: .radio(isChecked: true))
            ListChoice(title, description: description, disclosure: .radio(state: .error))
            ListChoice(title, description: description, disclosure: .radio())
                .disabled(true)
            ListChoice(title, icon: .airplane, disclosure: .radio(isChecked: false, state: .error))
            ListChoice(title, icon: .airplane, disclosure: .radio(isChecked: false))
                .disabled(true)
            ListChoice(
                title,
                description: description,
                icon: .airplane,
                disclosure: .radio(isChecked: false)
            ) {
                contentPlaceholder
            } headerContent: {
                headerPlaceholder
            }
        }
        .previewDisplayName()
    }

    static var plain: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, disclosure: .none)
            ListChoice(title, description: description, disclosure: .none)
            ListChoice(title, description: "No Separator", disclosure: .none, showSeparator: false)
            ListChoice(title, icon: .airplane, disclosure: .none)
            ListChoice(title, icon: .symbol(.airplane, color: .blueNormal), disclosure: .none)
            ListChoice(title, description: description, icon: .countryFlag("cs"), disclosure: .none)
            ListChoice(title, description: description, icon: .grid, value: value, disclosure: .none)
            ListChoice(title, description: description, disclosure: .none, headerContent: {
                badge
            })
            ListChoice(disclosure: .none) {
                contentPlaceholder
            } headerContent: {
                headerPlaceholder
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        standalone
    }
}
