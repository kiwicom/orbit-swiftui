import SwiftUI

/// A builder that constructs buttons for the ``Alert`` component.
@resultBuilder
public enum AlertButtonsBuilder {

    public static func buildBlock(_ empty: EmptyView) -> EmptyView {
        empty
    }

    public static func buildBlock(_ primary: some View) -> some View {
        primary
            .suppressButtonStyle()
            .buttonStyle(AlertButtonStyle())
            .buttonSize(.compact)
            .accessibility(.alertButtonPrimary)
    }

    public static func buildBlock(_ primary: some View, _ secondary: some View) -> some View {
        HStack(alignment: .top, spacing: .xSmall) {
            primary
                .accessibility(.alertButtonPrimary)

            secondary
                .accessibility(.alertButtonSecondary)
                .buttonPriority(.secondary)
        }
        .suppressButtonStyle()
        .buttonStyle(AlertButtonStyle())
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

// MARK: - Identifiers
public extension AccessibilityID {
    static let alertButtonPrimary   = Self(rawValue: "orbit.alert.button.primary")
    static let alertButtonSecondary = Self(rawValue: "orbit.alert.button.secondary")
}
