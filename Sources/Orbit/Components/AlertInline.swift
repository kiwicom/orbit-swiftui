import SwiftUI

/// Breaks the main user flow to present information.
///
/// There are times when just simple information isn’t enough and the user needs
/// to take additional steps to resolve the problem or get additional details.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/alert/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct AlertInline<Icon: View, Button: View>: View {

    private let title: String
    private let isSubtle: Bool
    @ViewBuilder private let button: Button
    @ViewBuilder private let icon: Icon

    public var body: some View {
        AlertContent(title: title, isInline: true) {
            EmptyView()
        } icon: {
            icon
        } buttons: {
            button
        }
        .environment(\.isSubtle, isSubtle)
    }
}

public extension AlertInline {

    /// Creates Orbit AlertInline component.
    init(
        _ title: String = "",
        icon: Icon.Symbol? = nil,
        isSubtle: Bool = false,
        @AlertInlineButtonsBuilder button: () -> Button = { EmptyView() }
    ) where Icon == Orbit.Icon {
        self.init(title, isSubtle: isSubtle, button: button) {
            Icon(icon)
        }
    }

    /// Creates Orbit AlertInline component with custom content and icon.
    init(
        _ title: String = "",
        isSubtle: Bool = false,
        @AlertInlineButtonsBuilder button: () -> Button,
        @ViewBuilder icon: () -> Icon
    ) {
        self.title = title
        self.isSubtle = isSubtle
        self.button = button()
        self.icon = icon()
    }
}

// MARK: - Types
struct AlertInlineButtonStyle: PrimitiveButtonStyle {

    @Environment(\.status) private var status

    func makeBody(configuration: Configuration) -> some View {
        OrbitCustomButtonContent(
            configuration: configuration,
            textActiveColor: resolvedStatus.darkHoverColor,
            horizontalPadding: 0,
            verticalPadding: 6, // = 32 height @ normal size
            horizontalBackgroundPadding: .xSmall,
            verticalBackgroundPadding: .xxxSmall,
            hapticFeedback: resolvedStatus.defaultHapticFeedback
        ) {
            EmptyView()
        } disclosureIcon: {
            EmptyView()
        } background: {
            Color.clear
        } backgroundActive: {
            resolvedStatus.color.opacity(0.24)
        }
        .textFontWeight(.medium)
        .textColor(resolvedStatus.darkColor)
        .idealSize()
    }

    var resolvedStatus: Status {
        status ?? .info
    }
}

/// A builder that constructs buttons for the ``AlertInline`` component.
@resultBuilder
public enum AlertInlineButtonsBuilder {

    public static func buildBlock(_ emptyView: EmptyView) -> EmptyView {
        emptyView
    }

    public static func buildBlock(_ button: some View) -> some View {
        button
            .suppressButtonStyle()
            .buttonStyle(AlertInlineButtonStyle())
            .padding(.trailing, .small)
            .accessibility(.alertButtonPrimary)
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
        AlertInline("Alert", icon: .grid) {
            Button("Primary") {}
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
