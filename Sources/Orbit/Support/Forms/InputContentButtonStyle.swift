import SwiftUI

/// Button-like appearance for inputs that share common layout with a prefix and suffix.
/// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
public struct InputContentButtonStyle<Prefix: View, Suffix: View>: ButtonStyle {

    private let state: InputState
    private let message: Message?
    private let isEditing: Bool
    @ViewBuilder private let prefix: Prefix
    @ViewBuilder private let suffix: Suffix

    public func makeBody(configuration: Configuration) -> some View {
        InputContent(
            state: state,
            message: message,
            isPressed: configuration.isPressed,
            isEditing: isEditing
        ) {
            configuration.label
        } prefix: {
            prefix
        } suffix: {
            suffix
        }
    }

    public init(
        state: InputState = .default,
        message: Message? = nil,
        isEditing: Bool = false,
        @ViewBuilder prefix: () -> Prefix = { EmptyView() },
        @ViewBuilder suffix: () -> Suffix = { EmptyView() }
    ) {
        self.state = state
        self.message = message
        self.isEditing = isEditing
        self.prefix = prefix()
        self.suffix = suffix()
    }
}
