import SwiftUI

/// Orbit input component that displays a selectable row as a choice in a group of similar items.
///
/// A ``ListChoice`` consists of a title, description, icon, disclosure and content.
///
/// ```swift
/// ListChoice("Profile", icon: .user) {
///     // Tap action
/// } content: {
///     // Content
/// }
/// ``` 
/// 
/// A secondary header content can be provided using `String` value:
/// 
/// ```swift
/// ListChoice(title, description: description, value: value) {
///     // Tap action
/// }
/// ```   
/// 
/// or using a custom content:
/// 
/// ```swift
/// ListChoice(title, description: description, icon: .user) {
///     // Tap action
/// } content: {
///     // Custom content
/// } header: {
///     // Header trailing content
/// }
/// ```  
///
/// ### Customizing appearance
///
/// The title and icon colors can be modified by ``textColor(_:)`` and ``iconColor(_:)`` modifiers.
/// The icon size can be modified by ``iconSize(custom:)`` modifier.
/// 
/// The default background can be overridden by ``backgroundStyle(_:)-9odue`` modifier.
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
/// Before the action is triggered, a haptic feedback is fired via ``HapticsProvider/sendHapticFeedback(_:)``.
///
/// ### Layout
///
/// Component expands horizontally unless prevented by the native `fixedSize()` or ``idealSize()`` modifier.
///
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/listchoice/)
public struct ListChoice<Header: View, Icon: View, Content: View>: View, PotentiallyEmptyView {

    private let verticalPadding: CGFloat = .small // = 45 height @ normal size

    @Environment(\.idealSize) private var idealSize
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let title: String
    private let description: String
    private let value: String
    private let disclosure: ListChoiceDisclosure?
    private let showSeparator: Bool
    private let action: () -> Void
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
            .accessibilityElement(children: .ignore)
            .accessibility(label: .init(title))
            .accessibility(value: .init(value))
            .accessibility(hint: .init(description))
            .accessibility(addTraits: .isButton)
            .accessibility(addTraits: accessibilityTraitsToAdd)
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
                        Text(title)
                            .fontWeight(.medium)
                            .accessibility(.listChoiceTitle)
                        
                        Text(description)
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
                Checkbox(state: state, isChecked: .constant(isChecked))
            case .radio(let isChecked, let state):
                Radio(state: state, isChecked: .constant(isChecked))
            case .icon(let content):
                Orbit.Icon(content)
        }
    }
    
    @ViewBuilder private func disclosureButton(type: ListChoiceDisclosure.ButtonType) -> some View {
        Button(type: type == .add ? .primarySubtle : .criticalSubtle) {
            // No action
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
        if showSeparator {
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
    
    private var accessibilityTraitsToAdd: AccessibilityTraits {
        switch disclosure {
            case .none, .disclosure, .button(.add), .buttonLink, .checkbox(false, _), .radio(false, _), .icon:
                return []
            case .button(.remove), .checkbox(true, _), .radio(true, _):
                return .isSelected
        }
    }
}

// MARK: - Inits
public extension ListChoice {

    /// Creates Orbit ``ListChoice`` component with custom content.
    init(
        _ title: String = "",
        description: String = "",
        value: String = "",
        disclosure: ListChoiceDisclosure? = .disclosure(),
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
    
    /// Creates Orbit ``ListChoice`` component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol? = nil,
        disclosure: ListChoiceDisclosure? = .disclosure(),
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

    /// Creates Orbit ``ListChoice`` component with a text value as a header.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol? = nil,
        value: String,
        disclosure: ListChoiceDisclosure? = .disclosure(),
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

/// Disclosure used in Orbit ``ListChoice``.
public enum ListChoiceDisclosure: Equatable {

    /// Orbit ``ListChoiceDisclosure`` button type.
    public enum ButtonType {
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
    case checkbox(isChecked: Bool = true, state: Checkbox.State = .normal)
    /// A non-interactive radio.
    case radio(isChecked: Bool = true, state: Radio.State = .normal)
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
        Card(contentPadding: 0) {
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
                headerPlaceholder
                    .fixedSize()
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
        Card(contentPadding: 0) {
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
        Card(contentPadding: 0) {
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
        Card(contentPadding: 0) {
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
        Card(contentPadding: 0) {
            ListChoice(title, disclosure: .none, action: {})
            ListChoice(title, description: description, disclosure: .none, action: {})
            ListChoice(title, description: "No Separator", disclosure: .none, showSeparator: false, action: {})
            ListChoice(title, icon: .airplane, disclosure: .none, action: {})
            ListChoice(title, icon: .airplane, disclosure: .none, action: {})
                .iconColor(.blueNormal)
            ListChoice(title, description: description, disclosure: .none) {
                // No action
            } icon: {
                CountryFlag("us")
            }
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
