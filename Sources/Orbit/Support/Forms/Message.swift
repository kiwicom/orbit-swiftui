import SwiftUI

/// Orbit informational message used in forms.
public enum Message: Equatable, Hashable, CustomStringConvertible, Sendable {

    case normal(String, icon: Icon.Symbol? = nil)
    case help(String, icon: Icon.Symbol? = .informationCircle)
    case warning(String, icon: Icon.Symbol? = .alert)
    case error(String, icon: Icon.Symbol? = .alertCircle)

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
            case .error, .help, .warning:   return true
            case .normal:                   return false
        }
    }

    public var isError: Bool {
        switch self {
            case .error:                    return true
            case .normal, .help, .warning:  return false
        }
    }

    public var status: Status? {
        switch self {
            case .normal:   return nil
            case .help:     return .info
            case .warning:  return .warning
            case .error:    return .critical
        }
    }

    public var color: Color {
        status?.color ?? .inkNormal
    }

    public var darkColor: Color {
        status?.darkColor ?? .inkDark
    }

    public var lightColor: Color {
        status?.lightColor ?? .cloudLight
    }

    public var icon: Icon.Symbol? {
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
