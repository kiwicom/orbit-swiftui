import SwiftUI

/// Button style for Orbit input components that share common layout with a prefix and suffix.
public struct InputContentButtonStyle<Prefix: View, Suffix: View>: ButtonStyle {

    private let state: InputState
    private let label: String
    private let message: Message?
    private let isFocused: Bool
    @ViewBuilder private let prefix: Prefix
    @ViewBuilder private let suffix: Suffix

    public func makeBody(configuration: Configuration) -> some View {
        InputContent(
            state: state,
            label: label,
            message: message,
            isPressed: configuration.isPressed,
            isFocused: isFocused
        ) {
            configuration.label
        } prefix: {
            prefix
        } suffix: {
            suffix
        }
    }

    /// Create button style for Orbit input components.
    public init(
        state: InputState = .default,
        label: String = "",
        message: Message? = nil,
        isFocused: Bool = false,
        @ViewBuilder prefix: () -> Prefix = { EmptyView() },
        @ViewBuilder suffix: () -> Suffix = { EmptyView() }
    ) {
        self.state = state
        self.label = label
        self.message = message
        self.isFocused = isFocused
        self.prefix = prefix()
        self.suffix = suffix()
    }
}
