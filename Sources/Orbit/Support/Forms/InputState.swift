import SwiftUI

/// State of Orbit input components.
public enum InputState {

    case `default`
    case modified

    public var textColor: Color {
        switch self {
            case .default:          return .inkDark
            case .modified:         return .blueDark
        }
    }
    
    public var placeholderColor: Color {
        .inkLight
    }
}
