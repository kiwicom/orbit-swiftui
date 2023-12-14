import SwiftUI
import UIKit

/// Orbit input component that offers multiline text input. 
/// A counterpart of the native `SwiftUI.TextField` component with `vertical` axis specified.
///
/// The ``Textarea`` is created with an optional label and a binding to a string value.
/// 
/// ```swift
/// Textarea("Label", value: $text, prompt: "Description")
///     .focused($isDescriptionFocused)
///     .inputFieldReturnAction {
///         // Action after the value is submitted
///     }
///     .frame(height: 200)
/// ```
/// 
/// The component uses a custom ``TextView`` component (implemented using `UITextView`) that represents the native `TextField`.
///
/// ### Layout
///
/// The component expands horizontally and vertically. It would be typically further constrained by a `frame` modifier in vertical axis.
/// 
/// - Note: [Orbit definition](https://orbit.kiwi/components/input/textarea/)
public struct Textarea: View, TextFieldBuildable {
    
    // TODO: scrollview yes: TextEditor, no: TextField.lineLimit
    
    @Environment(\.inputFieldBeginEditingAction) private var inputFieldBeginEditingAction
    @Environment(\.inputFieldEndEditingAction) private var inputFieldEndEditingAction
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.lineLimit) private var lineLimit
    @Environment(\.sizeCategory) private var sizeCategory

    @State private var isFocused: Bool = false
    @State private var calculatedHeight: CGFloat = 10
    
    private let label: String
    @Binding private var value: String
    private let prompt: String
    private let state: InputState

    private let message: Message?
    @Binding private var messageHeight: CGFloat

    // Builder properties (keyboard related)
    var autocapitalizationType: UITextAutocapitalizationType = .none
    var isAutocorrectionDisabled: Bool? = false
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var textContentType: UITextContentType?
    var shouldDeleteBackwardAction: (String) -> Bool = { _ in true }
    
    public var body: some View {
        FieldWrapper(label, message: message, messageHeight: $messageHeight) {
            InputContent(state: state, message: message, isFocused: isFocused) {
                textView
                    .alignmentGuide(.firstTextBaseline) { dimension in
                        // Required to fix resizing issues when typing
                        dimension[.top]
                    }
            }
        }
    }
    
    @ViewBuilder private var textView: some View {
        TextView(
            value: $value, 
            calculatedHeight: $calculatedHeight, 
            prompt: prompt,
            isScrollable: lineLimit == nil,
            insets: .init(
                top: .small, 
                left: .small, 
                bottom: .small, 
                right: .small
            )
        )
        .returnKeyType(returnKeyType)
        .autocorrectionDisabled(isAutocorrectionDisabled)
        .keyboardType(keyboardType)
        .textContentType(textContentType)
        .autocapitalization(autocapitalizationType)
        .shouldDeleteBackwardAction(shouldDeleteBackwardAction)
        .accessibility(label: .init(label))
        .inputFieldBeginEditingAction {
            isFocused = true
            inputFieldBeginEditingAction()
        }
        .inputFieldEndEditingAction {
            isFocused = false
            inputFieldEndEditingAction()
        }
        .frame(height: calculatedHeight)
    } 
}

// MARK: - Inits
public extension Textarea {
    
    /// Creates Orbit ``Textarea`` component.
    ///
    /// - Parameters:
    ///   - message: Optional message below the text field.
    ///   - messageHeight: Binding to the current height of the optional message.
    init(
        _ label: String = "",
        value: Binding<String>,
        prompt: String = "",
        state: InputState = .default,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0)
    ) {
        self.label = label
        self._value = value
        self.prompt = prompt
        self.state = state
        self.message = message
        self._messageHeight = messageHeight
    }
}

// MARK: - Previews
struct TextareaPreviews: PreviewProvider {

    static let prompt = "Enter \(String(repeating: "values ", count: 20))"
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            lineLimit
            layout
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        textarea
            .frame(height: 160)
            .padding(.medium)
            .previewDisplayName()
    }
    
    static var lineLimit: some View {
        VStack(alignment: .leading, spacing: .medium) {
            textarea
                .lineLimit(1)
            
            textarea
                .lineLimit(2)
            
            textarea
                .lineLimit(10)
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var layout: some View {
        VStack(alignment: .leading, spacing: .medium) {
            textarea
                .frame(height: 100)
            
            StateWrapper("") { $value in
                Textarea(value: $value, prompt: prompt)
                    .frame(height: 100)
            }
            
            HStack(alignment: .top, spacing: .medium) {
                textarea
                    .frame(height: 100)
                textarea
                    .frame(height: 100)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var textarea: some View {
        StateWrapper(prompt) { $value in
            Textarea("Label", value: $value, prompt: prompt)
        }
    }
}
