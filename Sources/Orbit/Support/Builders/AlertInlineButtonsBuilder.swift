import SwiftUI

/// A builder that constructs buttons for the Orbit ``AlertInline`` component.
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
