import SwiftUI

/// A builder that constructs buttons for  ``Dialog`` and ``EmptyState`` components.
///
/// Up to three buttons are supported. The first one is resolved to primary Button with the rest resolved to ButtonLinks.
/// A `status()` modifier can be used to override the button style.
@resultBuilder public enum ButtonStackBuilder {

    public static func buildBlock(_ empty: EmptyView) -> EmptyView {
        empty
    }

    public static func buildBlock(_ primary: some View) -> some View {
        primaryButton(primary)
    }

    @ViewBuilder
    public static func buildBlock(_ primary: some View, _ secondary: some View) -> some View {
        primaryButton(primary)
        secondaryButton(secondary)
    }

    @ViewBuilder
    public static func buildBlock(_ primary: some View, _ secondary: some View, _ tertiary: some View) -> some View {
        primaryButton(primary)
        secondaryButton(secondary)
        tertiaryButton(tertiary)
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

    static func primaryButton(_ content: some View) -> some View {
        content
            .suppressButtonStyle()
            .buttonStyle(OrbitButtonStyle(type: .status(nil)))
            .accessibility(.buttonStackPrimary)
    }

    static func nonPrimaryButton(_ content: some View) -> some View {
        content
            .suppressButtonStyle()
            .buttonStyle(OrbitButtonLinkButtonStyle(type: .status(nil)))
    }

    static func secondaryButton(_ content: some View) -> some View {
        nonPrimaryButton(content)
            .accessibility(.buttonStackSecondary)
    }

    static func tertiaryButton(_ content: some View) -> some View {
        nonPrimaryButton(content)
            .accessibility(.buttonStackTertiary)
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let buttonStackPrimary      = Self(rawValue: "orbit.buttonstack.primary")
    static let buttonStackSecondary    = Self(rawValue: "orbit.buttonstack.secondary")
    static let buttonStackTertiary     = Self(rawValue: "orbit.buttonstack.tertiary")
}
