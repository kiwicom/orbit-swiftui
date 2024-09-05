import SwiftUI

/// Orbit component that breaks the main user flow to present information.
///
/// An ``Alert`` consists of a title, description, icon, optional custom content and at most two actions.
///
/// ```swift
/// Alert("Alert") {
///     Button("Primary") { /* Tap action */ }
///     Button("Secondary") { /* Tap action */ }
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
/// Alert("Alert", description: "Please check your <applink1>visa</applink1>")
///     .status(.warning)
/// ```
///
/// The default button priority can be overridden by ``buttonPriority(_:)`` modifier:
///
/// ```swift
/// Alert("Alert") {
///     content
/// } buttons: {
///     Button("Secondary Only") {
///         // Tap action 
///     }
///     .buttonPriority(.secondary)
/// }
/// ```
///
/// For compact variant, use ``AlertInline`` component.
///
/// ### Layout
///
/// Component expands horizontally unless prevented by native `fixedSize()` or ``idealSize()`` modifier.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/alert/)
public struct Alert<Icon: View, Title: View, Description: View, Buttons: View>: View {

    private let isSubtle: Bool
    @ViewBuilder private let icon: Icon
    @ViewBuilder private let title: Title
    @ViewBuilder private let description: Description
    @ViewBuilder private let buttons: Buttons

    public var body: some View {
        AlertContent(isInline: false) {
            buttons
        } title: {
            title
        } description: {
            description
        } icon: {
            icon
        }
        .environment(\.isSubtle, isSubtle)
    }
    
    /// Creates Orbit ``Alert`` component with custom content.
    public init(
        isSubtle: Bool = false,
        @AlertButtonsBuilder buttons: () -> Buttons,
        @ViewBuilder title: () -> Title = { EmptyView() },
        @ViewBuilder description: () -> Description = { EmptyView() },
        @ViewBuilder icon: () -> Icon = { EmptyView() }
    ) {
        self.isSubtle = isSubtle
        self.icon = icon()
        self.title = title()
        self.description = description()
        self.buttons = buttons()
    }
}

// MARK: - Convenience Inits
public extension Alert where Title == Heading, Description == Text, Icon == Orbit.Icon {

    /// Creates Orbit ``Alert`` component.
    @_disfavoredOverload
    init(
        _ title: some StringProtocol = String(""),
        description: some StringProtocol = String(""),
        icon: Icon.Symbol? = nil,
        isSubtle: Bool = false,
        @AlertButtonsBuilder buttons: () -> Buttons = { EmptyView() }
    ) {
        self.isSubtle = isSubtle
        self.icon = Icon(icon)
        self.title = Heading(title, style: .title5)
        self.description = Text(description)
        self.buttons = buttons()
    }
    
    /// Creates Orbit ``Alert`` component with localizable texts.
    @_semantics("swiftui.init_with_localization")
    init(
        _ title: LocalizedStringKey = "",
        description: LocalizedStringKey = "",
        icon: Icon.Symbol? = nil,
        isSubtle: Bool = false,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        titleComment: StaticString? = nil,
        @AlertButtonsBuilder buttons: () -> Buttons = { EmptyView() }
    ) {
        self.isSubtle = isSubtle
        self.icon = Icon(icon)
        self.title = Heading(title, style: .title5, tableName: tableName, bundle: bundle)
        self.description = Text(description, tableName: tableName, bundle: bundle)
        self.buttons = buttons()
    }
}

// MARK: - Previews
struct AlertPreviews: PreviewProvider {

    static let title = "Title"
    static let description = """
        The main description message of this Alert component should be placed here. If you need to use TextLink \
        in this component, please do it by using <a href="..">Normal Underline text style</a>.

        Description message can be <strong>formatted</strong>, but if more <ref>customizaton</ref> is needed a custom \
        description content can be provided instead.
        """

    static var previews: some View {
        PreviewWrapper {
            standalone
            mixed

            Group {
                basic
                basicNoIcon
                suppressed
                suppressedNoIcon
            }

            primaryButtonOnly
            secondaryButtonOnly
            noButtons
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Alert(title, description: description, icon: .informationCircle) {
            Button("Primary") {}
            Button("Secondary") {}
        }
        .status(.info)
        .previewDisplayName()
    }

    static var mixed: some View {
        VStack(alignment: .leading, spacing: .large) {
            Alert {
                Button("Primary") {}
                Button("Secondary") {}
            } title: {
                Heading("Alert with\n<u>multiline</u> title", style: .title5)
            } description: {
                VStack(alignment: .leading, spacing: .small) {
                    Text("Alert <strong>multiline</strong> description\nwith <applink1>link</applink1>")
                    contentPlaceholder
                }
            } icon: {
                Icon(.grid)
            }

            Group {
                Alert("Alert title") {
                    Button("Primary") {}
                }
                Alert(description: "Alert description") {
                    Button("Primary") {}
                }
                Alert("Alert title")
                Alert(description: "Alert description")
            }

            Group {
                Alert("Alert with no button", icon: .informationCircle)
                Alert("Alert with no button")
                    .idealSize()
            }
            .status(.success)
        }
        .previewDisplayName()
    }

    static var basic: some View {
        alerts(showIcons: true, isSuppressed: false)
            .previewDisplayName()
    }

    static var basicNoIcon: some View {
        alerts(showIcons: false, isSuppressed: false)
            .previewDisplayName()
    }

    static var suppressed: some View {
        alerts(showIcons: true, isSuppressed: true)
            .previewDisplayName()
    }

    static var suppressedNoIcon: some View {
        alerts(showIcons: false, isSuppressed: true)
            .previewDisplayName()
    }

    static func alert(_ title: String, status: Status, icon: Icon.Symbol?, isSuppressed: Bool) -> some View {
        Alert(title, description: description, icon: icon, isSubtle: isSuppressed) {
            Button("Primary") {}
            Button("Secondary") {}
        }
        .status(status)
    }

    static func alerts(showIcons: Bool, isSuppressed: Bool) -> some View {
        VStack(spacing: .medium) {
            alert("Informational message", status: .info, icon: showIcons ? .informationCircle : nil, isSuppressed: isSuppressed)
            alert("Success message", status: .success, icon: showIcons ? .checkCircle : .none, isSuppressed: isSuppressed)
            alert("Warning message", status: .warning, icon: showIcons ? .alertCircle : .none, isSuppressed: isSuppressed)
            alert("Critical message", status: .critical, icon: showIcons ? .alertCircle : .none, isSuppressed: isSuppressed)
        }
    }

    static var primaryButtonOnly: some View {
        VStack(spacing: .medium) {
            Alert(title, description: description, icon: .informationCircle) {
                Button("Primary") {}
            }
            Alert(description: description, icon: .informationCircle) {
                Button("Primary") {}
            }
            Alert(title, description: description) {
                Button("Primary") {}
            }
            Alert(description: description) {
                Button("Primary") {}
            }
            Alert( title, icon: .informationCircle) {
                Button("Primary") {}
            }
            Alert(title) {
                Button("Primary") {}
            }
            Alert(icon: .informationCircle) {
                Button("Primary") {}
            }
            Alert {
                Button("Primary") {}
            }
            Alert("Intrinsic width") {
                Button("Primary") {}
            }
            .idealSize(horizontal: true, vertical: false)
        }
        .previewDisplayName()
    }

    static var secondaryButtonOnly: some View {
        VStack(spacing: .medium) {
            Alert(title, description: description, icon: .informationCircle) {
                Button("Secondary") {}
                    .buttonPriority(.secondary)
            }
            Alert(description: description, icon: .informationCircle) {
                Button("Secondary") {}
                    .buttonPriority(.secondary)
            }
            Alert(title, description: description) {
                Button("Secondary") {}
                    .buttonPriority(.secondary)
            }
            Alert(description: description) {
                Button("Secondary") {}
                    .buttonPriority(.secondary)
            }
            Alert( title, icon: .informationCircle) {
                Button("Secondary") {}
                    .buttonPriority(.secondary)
            }
            Alert(title) {
                Button("Secondary") {}
                    .buttonPriority(.secondary)
            }
            Alert(icon: .informationCircle) {
                Button("Secondary") {}
                    .buttonPriority(.secondary)
            }
            Alert {
                Button("Secondary") {}
                    .buttonPriority(.secondary)
            }
            Alert("Intrinsic width") {
                Button("Secondary") {}
                    .buttonPriority(.secondary)
            }
            .idealSize(horizontal: true, vertical: false)
        }
        .status(.warning)
        .previewDisplayName()
    }
    
    static var noButtons: some View {
        VStack(spacing: .medium) {
            Alert(title, description: description, icon: .informationCircle)
            Alert(title, description: description)
            Alert(title) {
                contentPlaceholder
            }
            Alert {
                contentPlaceholder
            } title: {
                EmptyView()
            }
            Alert(title, icon: .informationCircle)
            Alert(icon: .informationCircle)
            Alert(title)
            Alert()
            Alert("Intrinsic width")
                .idealSize(horizontal: true, vertical: false)
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        mixed
            .padding(.medium)
    }
}
