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
public struct Alert<Content: View, Icon: View, Buttons: View>: View {

    private let title: String
    private let description: String
    private let isSubtle: Bool
    @ViewBuilder private let buttons: Buttons
    @ViewBuilder private let content: Content
    @ViewBuilder private let icon: Icon

    public var body: some View {
        AlertContent(title: title, description: description, isInline: false) {
            content
        } icon: {
            icon
        } buttons: {
            buttons
        }
        .environment(\.isSubtle, isSubtle)
    }
}

public extension Alert {

    /// Creates Orbit ``Alert`` component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol? = nil,
        isSubtle: Bool = false,
        @AlertButtonsBuilder buttons: () -> Buttons
    ) where Content == EmptyView, Icon == Orbit.Icon {
        self.init(title: title, description: description, isSubtle: isSubtle) {
            buttons()
        } content: {
            EmptyView()
        } icon: {
            Icon(icon)
        }
    }

    /// Creates Orbit ``Alert`` component with no buttons.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol? = nil,
        isSubtle: Bool = false
    ) where Content == EmptyView, Icon == Orbit.Icon, Buttons == EmptyView {
        self.init(title: title, description: description, isSubtle: isSubtle) {
            EmptyView()
        } content: {
            EmptyView()
        } icon: {
            Icon(icon)
        }
    }

    /// Creates Orbit ``Alert`` component with custom content and icon.
    init(
        _ title: String = "",
        description: String = "",
        isSubtle: Bool = false,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @AlertButtonsBuilder buttons: () -> Buttons,
        @ViewBuilder icon: () -> Icon = { EmptyView() }
    ) {
        self.init(title: title, description: description, isSubtle: isSubtle) {
            buttons()
        } content: {
            content()
        } icon: {
            icon()
        }
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
        Alert(title, description: description) {
            contentPlaceholder
        } buttons: {
            Button("Primary") {}
            Button("Secondary") {}
        } icon: {
            Icon(.informationCircle)
        }
        .status(.info)
        .previewDisplayName()
    }

    static var mixed: some View {
        VStack(alignment: .leading, spacing: .large) {
            Alert(
                "Alert with\n<u>multiline</u> title",
                description: "Alert <strong>multiline</strong> description\nwith <applink1>link</applink1>"
            ) {
                contentPlaceholder
                    .frame(height: 30)
                    .clipped()
            } buttons: {
                Button("Primary") {}
                Button("Secondary") {}
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
        .status(.warning)
        .buttonPriority(.secondary)
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
