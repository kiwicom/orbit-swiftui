import SwiftUI

/// Button style for Orbit ``InputField`` and similar input components that share common layout with a prefix and suffix.
public struct InputContentButtonStyle<Prefix: View, Suffix: View>: ButtonStyle {

    private let state: InputState
    private let label: String
    private let message: Message?
    private let isFocused: Bool
    private let isPlaceholder: Bool
    @ViewBuilder private let prefix: Prefix
    @ViewBuilder private let suffix: Suffix

    public func makeBody(configuration: Configuration) -> some View {
        InputContent(
            state: state,
            label: label,
            message: message,
            isPressed: configuration.isPressed,
            isFocused: isFocused,
            isPlaceholder: isPlaceholder
        ) {
            configuration.label
        } prefix: {
            prefix
        } suffix: {
            suffix
        }
    }

    /// Create button style for Orbit ``InputField`` and similar input components.
    public init(
        state: InputState = .default,
        label: String = "",
        message: Message? = nil,
        isFocused: Bool = false,
        isPlaceholder: Bool = false,
        @ViewBuilder prefix: () -> Prefix = { EmptyView() },
        @ViewBuilder suffix: () -> Suffix = { EmptyView() }
    ) {
        self.state = state
        self.label = label
        self.message = message
        self.isFocused = isFocused
        self.isPlaceholder = isPlaceholder
        self.prefix = prefix()
        self.suffix = suffix()
    }
}
