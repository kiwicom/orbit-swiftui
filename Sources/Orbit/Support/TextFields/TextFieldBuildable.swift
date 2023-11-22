import SwiftUI

// Modifiers that shadow the SwiftUI modifiers need to have the exact signature
// in order to prefer the method of TextFieldBuildable over the generic View version

protocol TextFieldBuildable {

    var autocapitalizationType: UITextAutocapitalizationType { get set }
    var isAutocorrectionDisabled: Bool? { get set }
    var keyboardType: UIKeyboardType { get set }
    var returnKeyType: UIReturnKeyType { get set }
    var shouldDeleteBackwardAction: (String) -> Bool { get set }
    var textContentType: UITextContentType? { get set }
}

extension TextFieldBuildable {

    func set<V>(_ keypath: WritableKeyPath<Self, V>, to value: V) -> Self {
        var copy = self
        copy[keyPath: keypath] = value
        return copy
    }
}

public extension TextField {

    /// Returns a modified Orbit TextField with provided auto-capitalization type.
    func autocapitalization(_ style: UITextAutocapitalizationType) -> Self {
        set(\.autocapitalizationType, to: style)
    }

    /// Returns a modified Orbit TextField with provided autocorrection type.
    func autocorrectionDisabled(_ disable: Bool? = true) -> Self {
        set(\.isAutocorrectionDisabled, to: disable)
    }

    /// Returns a modified Orbit TextField with provided keyboard type.
    func keyboardType(_ type: UIKeyboardType) -> Self {
        set(\.keyboardType, to: type)
    }

    /// Returns a modified Orbit TextField with provided keyboard return type.
    func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        set(\.returnKeyType, to: returnKeyType)
    }

    /// Returns a modified Orbit TextField with provided handler of delete backward event.
    func shouldDeleteBackwardAction(_ action: @escaping (String) -> Bool) -> Self {
        set(\.shouldDeleteBackwardAction, to: action)
    }
    
    /// Returns a modified Orbit TextField with provided content type.
    func textContentType(_ textContentType: UITextContentType?) -> Self {
        set(\.textContentType, to: textContentType)
    }
}

public extension InputField {

    /// Returns a modified Orbit InputField with provided auto-capitalization type.
    func autocapitalization(_ style: UITextAutocapitalizationType) -> Self {
        set(\.autocapitalizationType, to: style)
    }

    /// Returns a modified Orbit InputField with provided autocorrection type.
    func autocorrectionDisabled(_ disable: Bool? = true) -> Self {
        set(\.isAutocorrectionDisabled, to: disable)
    }

    /// Returns a modified Orbit InputField with provided keyboard type.
    func keyboardType(_ type: UIKeyboardType) -> Self {
        set(\.keyboardType, to: type)
    }

    /// Returns a modified Orbit InputField with provided keyboard return type.
    func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        set(\.returnKeyType, to: returnKeyType)
    }

    /// Returns a modified Orbit InputField with provided handler of delete backward event.
    func shouldDeleteBackwardAction(_ action: @escaping (String) -> Bool) -> Self {
        set(\.shouldDeleteBackwardAction, to: action)
    }
    
    /// Returns a modified Orbit InputField with provided content type.
    func textContentType(_ textContentType: UITextContentType?) -> Self {
        set(\.textContentType, to: textContentType)
    }
}

public extension Textarea {

    /// Returns a modified Orbit Textarea with provided auto-capitalization type.
    func autocapitalization(_ style: UITextAutocapitalizationType) -> Self {
        set(\.autocapitalizationType, to: style)
    }

    /// Returns a modified Orbit Textarea with provided autocorrection type.
    func autocorrectionDisabled(_ disable: Bool? = true) -> Self {
        set(\.isAutocorrectionDisabled, to: disable)
    }

    /// Returns a modified Orbit Textarea with provided keyboard type.
    func keyboardType(_ type: UIKeyboardType) -> Self {
        set(\.keyboardType, to: type)
    }

    /// Returns a modified Orbit Textarea with provided keyboard return type.
    func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        set(\.returnKeyType, to: returnKeyType)
    }

    /// Returns a modified Orbit Textarea with provided handler of delete backward event.
    func shouldDeleteBackwardAction(_ action: @escaping (String) -> Bool) -> Self {
        set(\.shouldDeleteBackwardAction, to: action)
    }
    
    /// Returns a modified Orbit Textarea with provided content type.
    func textContentType(_ textContentType: UITextContentType?) -> Self {
        set(\.textContentType, to: textContentType)
    }
}

public extension TextView {

    /// Returns a modified Orbit TextView with provided auto-capitalization type.
    func autocapitalization(_ style: UITextAutocapitalizationType) -> Self {
        set(\.autocapitalizationType, to: style)
    }

    /// Returns a modified Orbit TextView with provided autocorrection type.
    func autocorrectionDisabled(_ disable: Bool? = true) -> Self {
        set(\.isAutocorrectionDisabled, to: disable)
    }

    /// Returns a modified Orbit TextView with provided keyboard type.
    func keyboardType(_ type: UIKeyboardType) -> Self {
        set(\.keyboardType, to: type)
    }

    /// Returns a modified Orbit TextView with provided keyboard return type.
    func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        set(\.returnKeyType, to: returnKeyType)
    }

    /// Returns a modified Orbit TextView with provided handler of delete backward event.
    func shouldDeleteBackwardAction(_ action: @escaping (String) -> Bool) -> Self {
        set(\.shouldDeleteBackwardAction, to: action)
    }
    
    /// Returns a modified Orbit TextView with provided content type.
    func textContentType(_ textContentType: UITextContentType?) -> Self {
        set(\.textContentType, to: textContentType)
    }
}

