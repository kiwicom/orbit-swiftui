import SwiftUI

/// Button style for Orbit input components that share common layout with a prefix and suffix.
public struct InputContentButtonStyle<Label: View, Prefix: View, Suffix: View>: ButtonStyle {

    private let state: InputState
    private let message: Message?
    private let isFocused: Bool
    @ViewBuilder private let label: Label
    @ViewBuilder private let prefix: Prefix
    @ViewBuilder private let suffix: Suffix

    public func makeBody(configuration: Configuration) -> some View {
        InputContent(
            state: state,
            message: message,
            isPressed: configuration.isPressed,
            isFocused: isFocused
        ) {
            configuration.label
        } label: {
            label
        } prefix: {
            prefix
        } suffix: {
            suffix
        }
    }

    /// Create button style for Orbit input components.
    public init(
        state: InputState = .default,
        message: Message? = nil,
        isFocused: Bool = false,
        @ViewBuilder label: () -> Label = { EmptyView() },
        @ViewBuilder prefix: () -> Prefix = { EmptyView() },
        @ViewBuilder suffix: () -> Suffix = { EmptyView() }
    ) {
        self.state = state
        self.message = message
        self.isFocused = isFocused
        self.label = label()
        self.prefix = prefix()
        self.suffix = suffix()
    }
}
