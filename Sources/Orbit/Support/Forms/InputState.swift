import SwiftUI

/// State of Orbit input.
public enum InputState {

    case disabled
    case `default`
    case modified

    public var textColor: Color {
        switch self {
            case .disabled:         return .cloudDarkerActive
            case .default:          return .inkNormal
            case .modified:         return .blueDark
        }
    }
    
    public var placeholderColor: Color {
        switch self {
            case .disabled:             return textColor
            case .default, .modified:   return .inkLighter
        }
    }

    public var textUIColor: UIColor {
        switch self {
            case .disabled:         return .cloudDarkerActive
            case .default:          return .inkNormal
            case .modified:         return .blueDark
        }
    }

    public var placeholderUIColor: UIColor {
        switch self {
            case .disabled:             return textUIColor
            case .default, .modified:   return .inkLighter
        }
    }
}
