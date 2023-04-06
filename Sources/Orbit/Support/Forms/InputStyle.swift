import SwiftUI

/// Button-like appearance for inputs that share common layout with a prefix and suffix.
/// Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
struct InputStyle: ButtonStyle {

    var prefix: Icon.Content?
    var suffix: Icon.Content?
    let prefixAccessibilityID: AccessibilityID
    let suffixAccessibilityID: AccessibilityID
    var state: InputState = .default
    var message: Message? = nil
    var isEditing = false

    func makeBody(configuration: Configuration) -> some View {
        InputContent(
            prefix: prefix,
            suffix: suffix,
            prefixAccessibilityID: prefixAccessibilityID,
            suffixAccessibilityID: suffixAccessibilityID,
            state: state,
            message: message,
            isPressed: configuration.isPressed,
            isEditing: isEditing
        ) {
            configuration.label
        }
    }

}
