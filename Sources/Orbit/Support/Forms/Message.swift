import SwiftUI

public enum Message: Equatable, Hashable, CustomStringConvertible {

    case normal(String, icon: Icon.Symbol = .none)
    case help(String, icon: Icon.Symbol = .informationCircle)
    case warning(String, icon: Icon.Symbol = .alert)
    case error(String, icon: Icon.Symbol = .alertCircle)

    public var description: String {
        switch self {
            case .normal(let text, _):      return text
            case .help(let text, _):        return text
            case .warning(let text, _):     return text
            case .error(let text, _):       return text
        }
    }

    public var isEmphasis: Bool {
        switch self {
            case .error, .help, .warning:           return true
            case .normal:                           return false
        }
    }

    public var isError: Bool {
        switch self {
            case .error:                            return true
            case .normal, .help, .warning:          return false
        }
    }

    public var color: Color {
        switch self {
            case .normal:   return .inkNormal
            case .help:     return .blueNormal
            case .warning:  return .orangeNormal
            case .error:    return .redNormal
        }
    }

    public var uiColor: UIColor {
        switch self {
            case .normal:   return .inkNormal
            case .help:     return .blueNormal
            case .warning:  return .orangeNormal
            case .error:    return .redNormal
        }
    }

    public var darkColor: Color {
        switch self {
            case .normal:   return .inkDark
            case .help:     return .blueDark
            case .warning:  return .orangeDark
            case .error:    return .redDark
        }
    }

    public var lightColor: Color {
        switch self {
            case .normal:   return .cloudLight
            case .help:     return .blueLight
            case .warning:  return .orangeLight
            case .error:    return .redLight
        }
    }

    public var icon: Icon.Symbol {
        switch self {
            case .error(_, let icon),
                 .warning(_, let icon),
                 .normal(_, let icon),
                 .help(_, let icon):
                return icon
        }
    }

    public var isEmpty: Bool {
        switch self {
            case .error(let message, let icon),
                 .warning(let message, let icon),
                 .normal(let message, let icon),
                 .help(let message, let icon):
                return message.isEmpty && icon == .none
        }
    }
}
