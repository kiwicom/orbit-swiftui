import SwiftUI

/// State of Orbit input.
public enum InputState {

    case `default`
    case modified

    public var textColor: Color {
        Color(textUIColor)
    }
    
    public var placeholderColor: Color {
        .inkLight
    }

    public var textUIColor: UIColor {
        switch self {
            case .default:          return .inkDark
            case .modified:         return .blueDark
        }
    }
}
