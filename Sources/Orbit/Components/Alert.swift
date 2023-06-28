import SwiftUI

/// Breaks the main user flow to present information.
///
/// There are times when just simple information isn’t enough and the user needs
/// to take additional steps to resolve the problem or get additional details.
///
/// In such cases, provide additional actions for your message.
/// Alerts use special status buttons to match the button color with the alert color.
///
/// Use at most two actions in each Alert: one primary and one subtle.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/alert/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
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

    /// Creates Orbit Alert component.
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

    /// Creates Orbit Alert component with no buttons.
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

    /// Creates Orbit Alert component with custom content and icon.
    init(
        _ title: String = "",
        description: String = "",
        isSubtle: Bool = false,
        @AlertButtonsBuilder buttons: () -> Buttons,
        @ViewBuilder content: () -> Content = { EmptyView() },
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

// MARK: - Types

/// Button style matching Orbit ``Alert`` component.
public struct AlertButtonStyle: PrimitiveButtonStyle {

    @Environment(\.status) private var status
    @Environment(\.isSubtle) private var isSubtle

    private let isPrimary: Bool

    public init(isPrimary: Bool) {
        self.isPrimary = isPrimary
    }

    public func makeBody(configuration: Configuration) -> some View {
        OrbitCustomButtonContent(
            configuration: configuration,
            textActiveColor: textActiveColor,
            horizontalPadding: .small,
            verticalPadding: .xSmall, // = 32 height @ normal size
            cornerRadius: BorderRadius.desktop,
            hapticFeedback: resolvedStatus.defaultHapticFeedback
        ) {
            EmptyView()
        } disclosureIcon: {
            EmptyView()
        } background: {
            background
        } backgroundActive: {
            backgroundActive
        }
        .textFontWeight(.medium)
        .textSize(.small)
        .textColor(textColor)
    }

    var textColor: Color {
        switch (isPrimary, isSubtle) {
            case (true, _):      return .whiteNormal
            case (false, true):  return .inkDark
            case (false, false): return resolvedStatus.darkColor
        }
    }

    var textActiveColor: Color {
        switch (isPrimary, isSubtle) {
            case (true, _):      return .whiteNormal
            case (false, true):  return .inkDarkActive
            case (false, false): return resolvedStatus.darkActiveColor
        }
    }

    @ViewBuilder var background: some View {
        switch (isPrimary, isSubtle) {
            case (true, _):      resolvedStatus.color
            case (false, true):  Color.inkDark.opacity(0.1)
            case (false, false): resolvedStatus.darkColor.opacity(0.12)
        }
    }

    @ViewBuilder var backgroundActive: some View {
        switch (isPrimary, isSubtle) {
            case (true, _):      resolvedStatus.activeColor
            case (false, true):  Color.inkDark.opacity(0.2)
            case (false, false): resolvedStatus.darkColor.opacity(0.24)
        }
    }

    var resolvedStatus: Status {
        status ?? .info
    }
}

struct IsSubtleKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isSubtle: Bool {
        get { self[IsSubtleKey.self] }
        set { self[IsSubtleKey.self] = newValue }
    }
}

/// A builder that constructs buttons for the ``Alert`` component.
@resultBuilder
public enum AlertButtonsBuilder {

    public static func buildBlock(_ empty: EmptyView) -> EmptyView {
        empty
    }

    public static func buildBlock(_ primary: some View) -> some View {
        primary
            .suppressButtonStyle()
            .buttonStyle(AlertButtonStyle(isPrimary: true))
            .buttonSize(.compact)
            .accessibility(.alertButtonPrimary)
    }

    public static func buildBlock(_ primary: some View, _ secondary: some View) -> some View {
        HStack(alignment: .top, spacing: .xSmall) {
            primary
                .suppressButtonStyle()
                .buttonStyle(AlertButtonStyle(isPrimary: true))
                .accessibility(.alertButtonPrimary)

            secondary
                .suppressButtonStyle()
                .buttonStyle(AlertButtonStyle(isPrimary: false))
                .accessibility(.alertButtonSecondary)
        }
    }

    public static func buildOptional<V: View>(_ component: V?) -> V? {
        component
    }

    public static func buildEither<T: View, F: View>(first view: T) -> _ConditionalContent<T, F> {
        .init(content: .trueView(view))
    }

    public static func buildEither<T: View, F: View>(second view: F) -> _ConditionalContent<T, F> {
        .init(content: .falseView(view))
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
            noButtons
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Alert(title, description: description) {
            Button("Primary") {}
            Button("Secondary") {}
        } content: {
            contentPlaceholder
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
                Button("Primary") {}
                Button("Secondary") {}
            } content: {
                contentPlaceholder
                    .frame(height: 30)
                    .clipped()
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
