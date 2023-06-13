import SwiftUI

/// Button-like appearance for inputs that share common layout with a prefix and suffix.
/// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
struct InputButtonStyle<Prefix: View, Suffix: View>: ButtonStyle {

    var state: InputState = .default
    var message: Message? = nil
    var isEditing = false
    @ViewBuilder var prefix: Prefix
    @ViewBuilder var suffix: Suffix

    func makeBody(configuration: Configuration) -> some View {
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

}
