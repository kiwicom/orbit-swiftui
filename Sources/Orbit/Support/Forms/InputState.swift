import SwiftUI

/// State of Orbit input components.
public enum InputState: Sendable {

    case `default`
    case modified

    public var textColor: Color {
        switch self {
            case .default:  .inkDark
            case .modified: .blueDark
        }
    }
    
    public var placeholderColor: Color {
        .inkLight
    }
}
