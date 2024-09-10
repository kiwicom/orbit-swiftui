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
public struct Textarea<Label: View, Prompt: View>: View, TextFieldBuildable {
    
    @Environment(\.inputFieldBeginEditingAction) private var inputFieldBeginEditingAction
    @Environment(\.inputFieldEndEditingAction) private var inputFieldEndEditingAction
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.sizeCategory) private var sizeCategory

    @State private var isFocused: Bool = false

    @Binding private var value: String
    private let state: InputState

    private let message: Message?
    @Binding private var messageHeight: CGFloat
    @ViewBuilder private let label: Label
    @ViewBuilder private let prompt: Prompt

    // Builder properties (keyboard related)
    var autocapitalizationType: UITextAutocapitalizationType = .none
    var isAutocorrectionDisabled: Bool? = false
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var textContentType: UITextContentType?
    var shouldDeleteBackwardAction: (String) -> Bool = { _ in true }
    
    public var body: some View {
        FieldWrapper(message: message, messageHeight: $messageHeight) {
            InputContent(state: state, message: message, isFocused: isFocused) {
                textView
                    .alignmentGuide(.firstTextBaseline) { dimension in
                        // Required to fix resizing issues when typing
                        dimension[.top]
                    }
            }
        } label: {
            label
        }
    }
    
    @ViewBuilder private var textView: some View {
        TextView(
            value: $value,  
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
        .inputFieldBeginEditingAction {
            isFocused = true
            inputFieldBeginEditingAction()
        }
        .inputFieldEndEditingAction {
            isFocused = false
            inputFieldEndEditingAction()
        }
        .accessibility(children: nil) {
            label
        } value: {
            Text(value)
        } hint: {
            prompt
        }
        .overlay(resolvedPrompt, alignment: .topLeading)
    }
    
    @ViewBuilder private var resolvedPrompt: some View {
        if value.isEmpty {
            prompt
                .textColor(isEnabled ? state.placeholderColor : .cloudDarkActive)
                .padding(.small)
                .allowsHitTesting(false)
                .accessibility(hidden: true)
        }
    }
    
    /// Creates Orbit ``Textarea`` component with custom content.
    ///
    /// - Parameters:
    ///   - message: Optional message below the text field.
    ///   - messageHeight: Binding to the current height of the optional message.
    public init(
        value: Binding<String>,
        state: InputState = .default,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        @ViewBuilder label: () -> Label,
        @ViewBuilder prompt: () -> Prompt = { EmptyView() }
    ) {
        self._value = value
        self.state = state
        self.message = message
        self._messageHeight = messageHeight
        self.label = label()
        self.prompt = prompt()
    }
}

// MARK: - Convenience Inits
public extension Textarea where Label == Text, Prompt == Text {
    
    /// Creates Orbit ``Textarea`` component.
    ///
    /// - Parameters:
    ///   - message: Optional message below the text field.
    ///   - messageHeight: Binding to the current height of the optional message.
    @_disfavoredOverload
    init(
        _ label: some StringProtocol = String(""),
        value: Binding<String>,
        prompt: some StringProtocol = String(""),
        state: InputState = .default,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0)
    ) {
        self.init(
            value: value,
            state: state,
            message: message,
            messageHeight: messageHeight
        ) {
            Text(label)
        } prompt: {
            Text(prompt)
        }
    }
    
    /// Creates Orbit ``Textarea`` component with localizable texts.
    ///
    /// - Parameters:
    ///   - message: Optional message below the text field.
    ///   - messageHeight: Binding to the current height of the optional message.
    @_semantics("swiftui.init_with_localization")
    init(
        _ label: LocalizedStringKey = "",
        value: Binding<String>,
        prompt: LocalizedStringKey = "",
        state: InputState = .default,
        message: Message? = nil,
        messageHeight: Binding<CGFloat> = .constant(0),
        tableName: String? = nil,
        bundle: Bundle? = nil,
        labelComment: StaticString? = nil
    ) {
        self.init(
            value: value,
            state: state,
            message: message,
            messageHeight: messageHeight
        ) {
            Text(label, tableName: tableName, bundle: bundle)
        } prompt: {
            Text(prompt, tableName: tableName, bundle: bundle)
        }
    }
}

// MARK: - Previews
struct TextareaPreviews: PreviewProvider {

    static let prompt = "Enter \(String(repeating: "values ", count: 20))"
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            layout
        }
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        textarea
            .padding(.medium)
            .previewDisplayName()
    }
    
    static var layout: some View {
        VStack(alignment: .leading, spacing: .medium) {
            textarea
            
            StateWrapper("") { $value in
                Textarea(value: $value, prompt: prompt)
                    .frame(height: 100)
            }
            
            HStack(alignment: .top, spacing: .medium) {
                textarea
                textarea
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var textarea: some View {
        StateWrapper(prompt) { $value in
            Textarea("Label", value: $value, prompt: prompt)
                .frame(height: 100)
        }
    }
}
