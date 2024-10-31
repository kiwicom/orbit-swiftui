import SwiftUI

/// Orbit input component that displays a selectable row as a choice in a group of similar items.
///
/// A ``ListChoice`` consists of a title, description, icon, disclosure and optional content.
///
/// ```swift
/// ListChoice("Profile", icon: .user) {
///     // Tap action
/// } content: {
///     // Content
/// }
/// ``` 
/// 
/// A secondary header content can be provided using a `String` value:
/// 
/// ```swift
/// ListChoice("Amount", value: amount) {
///     // Tap action
/// }
/// ```   
/// 
/// or using a custom content:
/// 
/// ```swift
/// ListChoice {
///     // Tap action
/// } content: {
///     // Custom content
/// } title: {
///     Text(title)
/// } description: {
///     Text(description)
/// } icon: {
///     Icon(.user)
/// } header: {
///     Text(value)
/// }
/// ```
///
/// ### Customizing appearance
///
/// The title and icon colors can be modified by ``textColor(_:)`` and ``iconColor(_:)`` modifiers.
/// The icon size can be modified by ``iconSize(custom:)`` modifier.
/// 
/// The default background can be overridden by ``backgroundStyle(_:)`` modifier.
/// 
/// A ``Status`` can be modified by ``status(_:)`` modifier:
///
/// ```swift
/// ListChoice("Not available") {
///     // Action
/// }
/// .status(.critical)
/// ```
///
/// A ListChoice shows a separator at the bottom by default.
/// Use ``showsSeparator(_:)`` to modify separator visibility for ListChoice components in a subview:
///
/// ```swift
/// VStack {
///     ListChoice("ListChoice with no separator") { /* No action */ }
///         .showsSeparator(false)
///     ListChoice("ListChoice with separator") { /* No action */ }
/// }
/// 
/// VStack {
///     ListChoice("ListChoice with no separator") { /* No action */ }
///     ListChoice("ListChoice with no separator") { /* No action */ }
/// }
/// .showsSeparator(false)
/// ```
///
/// Before the action is triggered, a haptic feedback is fired via ``HapticsProvider/sendHapticFeedback(_:)``.
///
/// ### Layout
///
/// Component expands horizontally unless prevented by the native `fixedSize()` or ``idealSize()`` modifier.
///
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/listchoice/)
public struct ListChoice<Icon: View, Title: View, Description: View, Header: View, Content: View>: View, PotentiallyEmptyView {

    private let verticalPadding: CGFloat = .small // = 45 height @ normal size

    @Environment(\.idealSize) private var idealSize
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled
    @Environment(\.showsSeparator) private var showsSeparator

    private let disclosure: ListChoiceDisclosure?
    private let action: () -> Void
    @ViewBuilder private let title: Title
    @ViewBuilder private let description: Description
    @ViewBuilder private let content: Content
    @ViewBuilder private let icon: Icon
    @ViewBuilder private let header: Header

    public var body: some View {
        if isEmpty == false {
            SwiftUI.Button {
                if isHapticsEnabled {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                }
                
                action()
            } label: {
                buttonContent
                    .padding(.bottom, 1)
                    .overlay(separator, alignment: .init(horizontal: .listRowSeparatorLeading, vertical: .bottom))
                    .clipped()
            }
            .buttonStyle(ListChoiceButtonStyle())
            .accessibility {
                title
            } value: {
                header
            } hint: {
                description
            }
            .accessibility(addTraits: accessibilityTraits)
            .accessibility(.listChoice)
        }
    }

    @ViewBuilder private var buttonContent: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                headerRow
                content
            }

            TextStrut()
                .padding(.vertical, verticalPadding)

            disclosureView
                .accessibility(.listChoiceDisclosure)
                .padding(.horizontal, .medium)
                .padding(.vertical, .small)
                .allowsHitTesting(false)
        }
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .leading)
    }
    
    @ViewBuilder private var headerRow: some View {
        if isHeaderEmpty == false || (header is EmptyView) == false {
            HStack(spacing: 0) {
                headerTexts
                    .padding(.trailing, .xSmall)

                if isHeaderEmpty == false, idealSize.horizontal != true {
                    Spacer(minLength: 0)
                }

                header
                    .padding(.leading, isHeaderEmpty ? .medium : 0)
                    .padding(.trailing, disclosure == nil ? .medium : 0)
                    .accessibility(.listChoiceValue)
            }
        }
    }
    
    @ViewBuilder private var headerTexts: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .top, spacing: .xSmall) {
                icon
                    .accessibility(.listChoiceIcon)
                
                if isHeaderTextEmpty == false {
                    VStack(alignment: .leading, spacing: .xxxSmall) {
                        title
                            .textFontWeight(.medium)
                            .accessibility(.listChoiceTitle)
                        
                        description
                            .textSize(.small)
                            .textColor(.inkNormal)
                            .accessibility(.listChoiceDescription)
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
                }
            }
            .padding(.leading, .medium)
            .padding(.vertical, verticalPadding)
        }
    }

    @ViewBuilder private var disclosureView: some View {
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
                    .buttonSize(.compact)
            case .checkbox(let isChecked, let state):
                Checkbox(isChecked: .constant(isChecked), state: state)
            case .radio(let isChecked, let state):
                Radio(isChecked: .constant(isChecked), state: state)
            case .icon(let content):
                Orbit.Icon(content)
        }
    }
    
    @ViewBuilder private func disclosureButton(type: ListChoiceDisclosure.ButtonType) -> some View {
        Button(type: type == .add ? .primarySubtle : .criticalSubtle) {
            // No action
        } label: {
            EmptyView()
        } icon: {
            Orbit.Icon(.plus)
                .rotationEffect(.degrees(type == .add ? 0 : 45))
                .animation(.easeOut(duration: 0.2), value: type)
        }
        .accessibility(addTraits: type == .add ? [] : .isSelected)
        .buttonSize(.compact)
        .idealSize()
    }

    @ViewBuilder private var separator: some View {
        if showsSeparator {
            Separator()
        }
    }

    var isEmpty: Bool {
        isHeaderEmpty && header.isEmpty && content.isEmpty && disclosure == .none
    }

    private var isHeaderEmpty: Bool {
        icon.isEmpty && isHeaderTextEmpty
    }

    private var isHeaderTextEmpty: Bool {
        title.isEmpty && description.isEmpty
    }
    
    private var accessibilityTraits: AccessibilityTraits {
        switch disclosure {
            case .none, .disclosure, .button(.add), .buttonLink, .checkbox(false, _), .radio(false, _), .icon:
                .isButton
            case .button(.remove), .checkbox(true, _), .radio(true, _):
                [.isButton, .isSelected]
        }
    }
    
    /// Creates Orbit ``ListChoice`` component with custom content.
    public init(
        disclosure: ListChoiceDisclosure? = .disclosure(),
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ViewBuilder title: () -> Title = { EmptyView() },
        @ViewBuilder description: () -> Description = { EmptyView() },
        @ViewBuilder icon: () -> Icon = { EmptyView() },
        @ViewBuilder header: () -> Header = { EmptyView() }
    ) {
        self.disclosure = disclosure
        self.title = title()
        self.description = description()
        self.action = action
        self.content = content()
        self.icon = icon()
        self.header = header()
    }
}



// MARK: - Convenience Inits
public extension ListChoice where Title == Text, Description == Text, Header == Text, Icon == Orbit.Icon {

    /// Creates Orbit ``ListChoice`` component.
    @_disfavoredOverload
    init(
        _ title: some StringProtocol = String(""),
        description: some StringProtocol = String(""),
        icon: Icon.Symbol? = nil,
        value: some StringProtocol = String(""),
        disclosure: ListChoiceDisclosure? = .disclosure(),
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.init(disclosure: disclosure) {
            action() 
        } content: {
            content()
        } title: {
            Text(title)
        } description: {
            Text(description)
        } icon: {
            Icon(icon)
        } header: {
            Text(value)
        }
    }
    
    /// Creates Orbit ``ListChoice`` component with localizable texts.
    @_semantics("swiftui.init_with_localization")
    init(
        _ title: LocalizedStringKey = "",
        description: LocalizedStringKey = "",
        icon: Icon.Symbol? = nil,
        value: some StringProtocol = String(""),
        disclosure: ListChoiceDisclosure? = .disclosure(),
        tableName: String? = nil,
        bundle: Bundle? = nil,
        titleComment: StaticString? = nil,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.init(disclosure: disclosure) {
            action() 
        } content: {
            content()
        } title: {
            Text(title, tableName: tableName, bundle: bundle)
        } description: {
            Text(description, tableName: tableName, bundle: bundle)
        } icon: {
            Icon(icon)
        } header: {
            Text(value)
        }
    }
}

// MARK: - Types

/// Disclosure used in Orbit ``ListChoice``.
public enum ListChoiceDisclosure: Equatable, Sendable {

    /// Orbit ``ListChoiceDisclosure`` button type.
    public enum ButtonType: Sendable {
        case add
        case remove
    }
    
    /// An iOS-style disclosure indicator.
    case disclosure(Color = .inkNormal)
    /// A non-interactive button.
    case button(type: ButtonType)
    /// A non-interactive ButtonLink.
    case buttonLink(String, type: ButtonLinkType = .primary)
    /// A non-interactive checkbox.
    case checkbox(isChecked: Bool = true, state: CheckboxState = .normal)
    /// A non-interactive radio.
    case radio(isChecked: Bool = true, state: RadioState = .normal)
    /// An icon content.
    case icon(Icon.Symbol)
}

extension HorizontalAlignment {

    struct ListRowSeparatorLeading: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.leading]
        }
    }

    static let listRowSeparatorLeading = Self(ListRowSeparatorLeading.self)
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let listChoice               = Self(rawValue: "orbit.listchoice")
    static let listChoiceTitle          = Self(rawValue: "orbit.listchoice.title")
    static let listChoiceIcon           = Self(rawValue: "orbit.listchoice.icon")
    static let listChoiceDescription    = Self(rawValue: "orbit.listchoice.description")
    static let listChoiceValue          = Self(rawValue: "orbit.listchoice.value")
    static let listChoiceDisclosure     = Self(rawValue: "orbit.listchoice.disclosure")
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
            ListChoice {
                // No Action
            } content: {
                contentPlaceholder
            } title: {
                Text(title)
            } description: {
                Text(description)
            } icon: {
                Icon(.grid)
            } header: {
                headerPlaceholder
            }

            // Empty
            ListChoice(disclosure: .none, action: {})
        }
        .previewDisplayName()
    }

    static var idealSize: some View {
        ListChoice {
            // No action
        } content: {
            intrinsicContentPlaceholder
        } title: {
            Text(title)
        } description: {
            Text(description)
        } icon: {
            Icon(.grid)
        } header: {
            headerPlaceholder
                .fixedSize()
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
            .border(.cloudNormal, width: .hairline)
            .measured()
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var mix: some View {
        Card {
            ListChoice(title, description: "Multiline\ndescription", value: "USD", action: {})
            ListChoice(title, description: description, icon: .airplane, value: value, action: {})
            
            ListChoice {
                // No action
            } content: {
                EmptyView()
            } title: {
                Text(title)
            } description: {
                Text(description)
            } header: {
                badge
            }
            
            ListChoice {
                // No action
            } content: {
                EmptyView()
            } title: {
                Text(title)
            } description: {
                Text(description)
            } icon: {
                Icon(.grid)
            } header: {
                badge
            }
            
            ListChoice {
              // No action  
            } content: {
                intrinsicContentPlaceholder
            } title: {
                Text(title)
            } description: {
                Text(description)
            } icon: {
                Icon(.grid)
            } header: {
                headerPlaceholder
                    .fixedSize()
            }
            
            ListChoice(disclosure: .none) {
                // No action
            } content: {
                contentPlaceholder
            }
            
            ListChoice {
                // No action
            } content: {
                contentPlaceholder
            } title: {
                Text(title)
            } description: {
                Text(description)
            } icon: {
                Icon(.grid)
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
        .cardLayout(.fill)
        .previewDisplayName()
    }
    
    static var buttons: some View {
        Card {
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
            
            ListChoice {
                // No action
            } content: {
                contentPlaceholder
            } title: {
                Text(title)
            } description: {
                Text(description)
            } icon: {
                Icon(.airplane)
            } header: {
                headerPlaceholder
            }
        }
        .cardLayout(.fill)
        .previewDisplayName()
    }

    static var checkbox: some View {
        Card {
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
            ListChoice(disclosure: checkedCheckbox) {
                // No action
            } content: {
                contentPlaceholder
            } title: {
                Text(title)
            } description: {
                Text(description)
            } icon: {
                Icon(.airplane)
            } header: {
                headerPlaceholder
            }
        }
        .cardLayout(.fill)
        .previewDisplayName()
    }

    static var radio: some View {
        Card {
            ListChoice(title, description: description, disclosure: .radio(isChecked: false), action: {})
            ListChoice(title, description: description, disclosure: .radio(isChecked: true), action: {})
            ListChoice(title, description: description, disclosure: .radio(state: .error), action: {})
            ListChoice(title, description: description, disclosure: .radio(), action: {})
                .disabled(true)
            ListChoice(title, icon: .airplane, disclosure: .radio(isChecked: false, state: .error), action: {})
            ListChoice(title, icon: .airplane, disclosure: .radio(isChecked: false), action: {})
                .disabled(true)
            
            ListChoice(disclosure: .radio(isChecked: false)) {
                // No action
            } content: {
                contentPlaceholder
            } title: {
                Text(title)
            } description: {
                Text(description)
            } icon: {
                Icon(.airplane)
            } header: {
                headerPlaceholder
            }
        }
        .cardLayout(.fill)
        .previewDisplayName()
    }

    static var plain: some View {
        Card {
            ListChoice(title, disclosure: .none, action: {})
            ListChoice(title, description: description, disclosure: .none, action: {})
            ListChoice(title, description: "No Separator", disclosure: .none, action: {})
                .showsSeparator(false)
            ListChoice(title, icon: .airplane, disclosure: .none, action: {})
            ListChoice(title, icon: .airplane, disclosure: .none, action: {})
                .iconColor(.blueNormal)
            ListChoice(disclosure: .none) {
                // No action
            } title: {
                Text(title)
            } description: {
                Text(description)
            } icon: {
                CountryFlag("us")
            }
            ListChoice(title, description: description, icon: .grid, value: value, disclosure: .none, action: {})
            ListChoice(disclosure: .none) {
                // No action
            } title: {
                Text(title)
            } description: {
                Text(description)
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
        .cardLayout(.fill)
        .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(spacing: .medium) {
            standalone
            idealSize
        }
    }
}
