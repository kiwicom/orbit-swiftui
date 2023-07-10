import SwiftUI

/// Shows one of a selectable list of items with similar structures.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/listchoice/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct ListChoice<Header: View, Icon: View, Content: View>: View {

    public let verticalPadding: CGFloat = .small + 0.5 // = 45 height @ normal size

    @Environment(\.idealSize) private var idealSize
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    let title: String
    let description: String
    let value: String
    let disclosure: ListChoiceDisclosure
    let showSeparator: Bool
    let action: () -> Void
    @ViewBuilder let content: Content
    @ViewBuilder let icon: Icon
    @ViewBuilder let header: Header

    public var body: some View {
        if isEmpty == false {
            SwiftUI.Button {
                if isHapticsEnabled {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                }
                
                action()
            } label: {
                buttonContent
            }
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
                headerRow
                content
            }

            TextStrut()
                .padding(.vertical, verticalPadding)

            disclosureView
                .padding(.horizontal, .medium)
                .padding(.vertical, .small)
                .allowsHitTesting(false)
        }
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .leading)
        .overlay(separator, alignment: .bottom)
    }
    
    @ViewBuilder var headerRow: some View {
        if isHeaderEmpty == false || (header is EmptyView) == false {
            HStack(spacing: 0) {
                headerTexts
                    .padding(.trailing, .xSmall)

                if isHeaderEmpty == false, idealSize.horizontal != true {
                    Spacer(minLength: 0)
                }

                header
                    .padding(.leading, isHeaderEmpty ? .medium : 0)
                    .padding(.trailing, disclosure == .none ? .medium : 0)
                    .accessibility(.listChoiceValue)
            }
        }
    }
    
    @ViewBuilder var headerTexts: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .top, spacing: .xSmall) {
                icon
                    .accessibility(.listChoiceIcon)
                
                if isHeaderTextEmpty == false {
                    VStack(alignment: .leading, spacing: .xxxSmall) {
                        Text(title)
                            .fontWeight(.medium)
                            .accessibility(.listChoiceTitle)
                        
                        Text(description)
                            .textSize(.small)
                            .textColor(.inkNormal)
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
                Orbit.Icon(.chevronForward)
                    .textColor(color)
                    .padding(.leading, -.xSmall)
            case .button(let type):
                disclosureButton(type: type)
            case .buttonLink(let label, let type):
                ButtonLink(label, type: type, action: {})
            case .checkbox(let isChecked, let state):
                Checkbox(state: state, isChecked: .constant(isChecked))
            case .radio(let isChecked, let state):
                Radio(state: state, isChecked: .constant(isChecked))
            case .icon(let content):
                Orbit.Icon(content)
        }
    }
    
    @ViewBuilder func disclosureButton(type: ListChoiceDisclosure.ButtonType) -> some View {
        Button(type: type == .add ? .primarySubtle : .criticalSubtle) {
            // No action
        } icon: {
            Orbit.Icon(.plus)
                .rotationEffect(.degrees(type == .add ? 0 : 45))
                .animation(.easeOut(duration: 0.2), value: type)
        }
        .buttonSize(.compact)
        .idealSize()
    }

    @ViewBuilder var separator: some View {
        if showSeparator {
            Separator()
                .padding(.leading, separatorPadding)
        }
    }

    var separatorPadding: CGFloat {
        if header is EmptyView {
            return 0
        }
        
        if icon.isEmpty {
            return .medium
        }
        
        return .xxLarge
    }

    var isEmpty: Bool {
        isHeaderEmpty && header is EmptyView && content is EmptyView && disclosure == .none
    }

    var isHeaderEmpty: Bool {
        icon.isEmpty && isHeaderTextEmpty
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

    /// Creates Orbit ListChoice component with custom content.
    public init(
        _ title: String = "",
        description: String = "",
        value: String = "",
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder header: () -> Header = { EmptyView() }
    ) {
        self.title = title
        self.description = description
        self.value = value
        self.disclosure = disclosure
        self.showSeparator = showSeparator
        self.action = action
        self.content = content()
        self.icon = icon()
        self.header = header()
    }
}

// MARK: - Inits
public extension ListChoice {

    /// Creates Orbit ListChoice component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol? = nil,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder header: () -> Header = { EmptyView() }
    ) where Icon == Orbit.Icon {
        self.init(
            title,
            description: description,
            disclosure: disclosure,
            showSeparator: showSeparator
        ) {
            action()
        } content: {
            content()
        } icon: {
            Icon(icon)
        } header: {
            header()
        }
    }
}

public extension ListChoice where Header == Text {

    /// Creates Orbit ListChoice component with text header value.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol? = nil,
        value: String,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) where Icon == Orbit.Icon {
        self.init(
            title,
            description: description,
            value: value,
            disclosure: disclosure,
            showSeparator: showSeparator
        ) {
            action()
        } content: {
            content()
        } icon: {
            Icon(icon)
        } header: {
            Text(value)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Types

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
    case buttonLink(String, type: ButtonLinkType = .primary)
    /// A non-interactive checkbox.
    case checkbox(isChecked: Bool = true, state: Checkbox.State = .normal)
    /// A non-interactive radio.
    case radio(isChecked: Bool = true, state: Radio.State = .normal)
    /// An icon content.
    case icon(Icon.Symbol)
}

/// ButtonStyle for Orbit ListChoice component.
///
/// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
public struct ListChoiceButtonStyle: SwiftUI.ButtonStyle {

    public func makeBody(configuration: Configuration) -> some View {
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
    static let badge = Badge("3", type: .status(.info, inverted: false))
    static let addButton = ListChoiceDisclosure.button(type: .add)
    static let removeButton = ListChoiceDisclosure.button(type: .remove)
    static let uncheckedCheckbox = ListChoiceDisclosure.checkbox(isChecked: false)
    static let checkedCheckbox = ListChoiceDisclosure.checkbox(isChecked: true)

    static var previews: some View {
        PreviewWrapper {
            standalone
            idealSize
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
                // No Action
            } content: {
                contentPlaceholder
            } header: {
                headerPlaceholder
            }

            // Empty
            ListChoice(disclosure: .none, action: {})
        }
        .previewDisplayName()
    }

    static var idealSize: some View {
        ListChoice(title, description: description, icon: .grid, action: {}) {
            intrinsicContentPlaceholder
        } header: {
            intrinsicContentPlaceholder
        }
        .idealSize()
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            Group {
                ListChoice("ListChoice", description: description, icon: .grid, value: value, action: {})
                ListChoice("ListChoice", icon: .grid, value: value, action: {})
                ListChoice(icon: .grid, action: {})
                ListChoice("ListChoice", disclosure: .none, action: {})
                ListChoice(description: "ListChoice", disclosure: .none, action: {})
                ListChoice("ListChoice", action: {})
            }
            .border(.cloudLight)
            .measured()
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var mix: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, description: "Multiline\ndescription", value: "USD", action: {})
            ListChoice(title, description: description, icon: .airplane, value: value, action: {})
            ListChoice(title, description: description, action: {}) {
                EmptyView()
            } header: {
                badge
            }
            ListChoice(title, description: description, icon: .grid, action: {}) {
                EmptyView()
            } header: {
                badge
            }
            ListChoice(title, description: description, icon: .grid, action: {}) {
                intrinsicContentPlaceholder
            } header: {
                intrinsicContentPlaceholder
            }
            ListChoice(disclosure: .none) {
                // No action
            } content: {
                contentPlaceholder
            }
            ListChoice(title, description: description, icon: .grid, action: {}) {
                contentPlaceholder
            } header: {
                headerPlaceholder
            }
            ListChoice(action: {}) {
                contentPlaceholder
            } header: {
                headerPlaceholder
            }
            ListChoice(disclosure: .none, action: {}) {
                contentPlaceholder
            } header: {
                headerPlaceholder
            }
        }
        .previewDisplayName()
    }
    
    static var buttons: some View {
        Card(contentLayout: .fill) {
            StateWrapper(ListChoiceDisclosure.button(type: .add)) { button in
                ListChoice(title, disclosure: button.wrappedValue) {
                    if .button(type: .add) ~= button.wrappedValue {
                        button.wrappedValue = .button(type: .remove)
                    } else {
                        button.wrappedValue = .button(type: .add)
                    }
                }
            }
            ListChoice(title, disclosure: removeButton, action: {})
            ListChoice(title, description: description, disclosure: addButton, action: {})
            ListChoice(title, description: description, disclosure: removeButton, action: {})
            ListChoice(title, icon: .airplane, disclosure: addButton, action: {})
            ListChoice(title, icon: .airplane, disclosure: removeButton, action: {})
            ListChoice(title, description: description, icon: .airplane, disclosure: addButton, action: {})
            ListChoice(title, description: description, icon: .airplane, disclosure: removeButton, action: {})
            ListChoice(title, description: description, icon: .airplane, value: value, disclosure: addButton, action: {})
            ListChoice(title, description: description, icon: .airplane, disclosure: removeButton, action: {}) {
                contentPlaceholder
            } header: {
                headerPlaceholder
            }
        }
        .previewDisplayName()
    }

    static var checkbox: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, disclosure: uncheckedCheckbox, action: {})
            ListChoice(title, disclosure: checkedCheckbox, action: {})
            ListChoice(title, description: description, disclosure: .checkbox(state: .error), action: {})
            ListChoice(title, description: description, disclosure: .checkbox(), action: {})
                .disabled(true)
            ListChoice(title, icon: .airplane, disclosure: .checkbox(isChecked: false, state: .error), action: {})
            ListChoice(title, icon: .airplane, disclosure: .checkbox(isChecked: false), action: {})
                .disabled(true)
            ListChoice(title, description: description, icon: .airplane, disclosure: uncheckedCheckbox, action: {})
            ListChoice(title, description: description, icon: .airplane, disclosure: checkedCheckbox, action: {})
            ListChoice(title, description: description, icon: .airplane, value: value, disclosure: uncheckedCheckbox, action: {})
            ListChoice(title, description: description, icon: .airplane, disclosure: checkedCheckbox, action: {}) {
                contentPlaceholder
            } header: {
                headerPlaceholder
            }
        }
        .previewDisplayName()
    }

    static var radio: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, description: description, disclosure: .radio(isChecked: false), action: {})
            ListChoice(title, description: description, disclosure: .radio(isChecked: true), action: {})
            ListChoice(title, description: description, disclosure: .radio(state: .error), action: {})
            ListChoice(title, description: description, disclosure: .radio(), action: {})
                .disabled(true)
            ListChoice(title, icon: .airplane, disclosure: .radio(isChecked: false, state: .error), action: {})
            ListChoice(title, icon: .airplane, disclosure: .radio(isChecked: false), action: {})
                .disabled(true)
            ListChoice(
                title,
                description: description,
                icon: .airplane,
                disclosure: .radio(isChecked: false)
            ) {
                // No action
            } content: {
                contentPlaceholder
            } header: {
                headerPlaceholder
            }
        }
        .previewDisplayName()
    }

    static var plain: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, disclosure: .none, action: {})
            ListChoice(title, description: description, disclosure: .none, action: {})
            ListChoice(title, description: "No Separator", disclosure: .none, showSeparator: false, action: {})
            ListChoice(title, icon: .airplane, disclosure: .none, action: {})
            ListChoice(title, icon: .airplane, disclosure: .none, action: {})
                .iconColor(.blueNormal)
            ListChoice(title, description: description, icon: .map, disclosure: .none, action: {})
            ListChoice(title, description: description, icon: .grid, value: value, disclosure: .none, action: {})
            ListChoice(title, description: description, disclosure: .none, action: {}) {
                EmptyView()
            } header: {
                badge
            }
            ListChoice(disclosure: .none) {
                // No action
            } content: {
                contentPlaceholder
            } header: {
                headerPlaceholder
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(spacing: .medium) {
            standalone
            idealSize
        }
    }
}
