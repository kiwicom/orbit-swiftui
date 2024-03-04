import SwiftUI

/// Orbit component that breaks the main user flow to present information.
///
/// An ``AlertInline`` (an inline variant of ``Alert``) consists of a title, icon and a single action.
///
/// ```swift
/// AlertInline("Alert") {
///     Button("Primary") {
///         // Tap action 
///     }
/// }
/// ```
///
/// ### Customizing appearance
///
/// The title and icon colors can be modified by ``textColor(_:)`` and ``iconColor(_:)`` modifiers.
/// The icon size can be modified by ``iconSize(custom:)`` modifier.
///
/// A default ``Status/info`` status can be modified by ``status(_:)`` modifier:
///
/// ```swift
/// AlertInline("Alert") {
///     Button("Primary") {
///         // Tap action 
///     }
/// }
/// .status(.warning)
/// ```
/// 
/// ### Layout
///
/// Component expands horizontally unless prevented by native `fixedSize()` or ``idealSize()`` modifier.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/alert/)
public struct AlertInline<Icon: View, Title: View, Button: View>: View {

    private let isSubtle: Bool
    @ViewBuilder private let icon: Icon
    @ViewBuilder private let title: Title
    @ViewBuilder private let button: Button

    public var body: some View {
        AlertContent(isInline: true) {
            button
        } title: {
            title
        } description: {
            EmptyView()
        } icon: {
            icon
        }
        .environment(\.isSubtle, isSubtle)
    }
    
    /// Creates Orbit ``AlertInline`` component with custom content.
    public init(
        isSubtle: Bool = false,
        @AlertInlineButtonsBuilder button: () -> Button,
        @ViewBuilder title: () -> Title = { EmptyView() },
        @ViewBuilder icon: () -> Icon = { EmptyView() }
    ) {
        self.isSubtle = isSubtle
        self.icon = icon()
        self.title = title()
        self.button = button()
    }
}

// MARK: - Convenience Inits
public extension AlertInline where Title == Heading, Icon == Orbit.Icon {

    /// Creates Orbit ``AlertInline`` component.
    @_disfavoredOverload
    init(
        _ title: some StringProtocol = String(""),
        icon: Icon.Symbol? = nil,
        isSubtle: Bool = false,
        @AlertInlineButtonsBuilder button: () -> Button = { EmptyView() }
    ) {
        self.init(isSubtle: isSubtle, button: button) {
            Heading(title, style: .title5)
        } icon: {
            Icon(icon)            
        }
    }
    
    /// Creates Orbit ``AlertInline`` component with localizable title.
    @_semantics("swiftui.init_with_localization")
    init(
        _ title: LocalizedStringKey,
        icon: Icon.Symbol? = nil,
        isSubtle: Bool = false,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil,
        @AlertInlineButtonsBuilder button: () -> Button = { EmptyView() }
    ) {
        self.init(isSubtle: isSubtle, button: button) {
            Heading(title, style: .title5, tableName: tableName, bundle: bundle)
        } icon: {
            Icon(icon)            
        }
    }
}

// MARK: - Previews
struct AlertInlinePreviews: PreviewProvider {

    static let title = "Title"

    static var previews: some View {
        PreviewWrapper {
            standalone
            mixed
            basic
            noIcon
            suppressed
            suppressedNoIcon
            noButtons
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            AlertInline("Alert", icon: .grid) {
                Button("Primary") {}
            }
            
            // EmptyView
            AlertInline("", icon: nil)
                .border(.redNormal)
        }
        .previewDisplayName()
    }

    static var mixed: some View {
        VStack(alignment: .leading, spacing: .large) {
            AlertInline("Alert with\n<u>multiline</u> title", icon: .grid) {
                Button("Primary") {}
            }

            AlertInline("Alert title") {
                Button("Primary") {}
            }

            AlertInline("Alert title")

            Group {
                Alert("Alert with no button", icon: .informationCircle)
                Alert("Alert with no button")
                    .idealSize()
            }
            .status(.success)

            Group {
                AlertInline("Alert", icon: .grid) {
                    Button("Primary") {}
                }
                AlertInline("Alert") {
                    Button("Primary") {}
                }
            }
            .status(.warning)

            AlertInline("Alert") {
                Button("Primary") {}
            }
            .idealSize()
            .status(.critical)

            AlertInline("Inline alert with very very very very very very very very very very very long and <u>multiline</u> title", icon: .grid) {
                Button("Primary") {}
            }
            .status(.warning)
        }
        .previewDisplayName()
    }

    static var basic: some View {
        alerts(showIcon: true, isSuppressed: false)
            .previewDisplayName()
    }

    static var noIcon: some View {
        alerts(showIcon: false, isSuppressed: false)
            .previewDisplayName()
    }

    static var suppressed: some View {
        alerts(showIcon: true, isSuppressed: true)
            .previewDisplayName()
    }

    static var suppressedNoIcon: some View {
        alerts(showIcon: false, isSuppressed: true)
            .previewDisplayName()
    }

    static var noButtons: some View {
        VStack(spacing: .medium) {
            AlertInline(title, icon: .informationCircle)
            AlertInline(icon: .informationCircle)
            AlertInline(title, icon: .none)
            AlertInline()
            AlertInline("Intrinsic width")
                .idealSize(horizontal: true, vertical: false)
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        mixed
            .padding(.medium)
    }

    static func alerts(showIcon: Bool, isSuppressed: Bool) -> some View {
        VStack(spacing: .medium) {
            AlertInline("Informational message", icon: showIcon ? .informationCircle : .none, isSubtle: isSuppressed) {
                Button("Primary") {}
            }

            AlertInline("Success message", icon: showIcon ? .checkCircle : .none, isSubtle: isSuppressed) {
                Button("Primary") {}
            }
            .status(.success)

            AlertInline("Warning message", icon: showIcon ? .alertCircle : .none, isSubtle: isSuppressed) {
                Button("Primary") {}
            }
            .status(.warning)

            AlertInline("Critical message", icon: showIcon ? .alertCircle : .none, isSubtle: isSuppressed) {
                Button("Primary") {}
            }
            .status(.critical)
        }
    }
}
