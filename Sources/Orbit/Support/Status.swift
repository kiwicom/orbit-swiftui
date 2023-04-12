import SwiftUI

/// Non-default status of a component.
public enum Status {

    case info
    case success
    case warning
    case critical

    /// Default icon associated with status.
    var icon: Icon.Symbol {
        switch self {
            case .info:         return .none
            case .success:      return .informationCircle
            case .warning:      return .alert
            case .critical:     return .alertCircle
        }
    }

    /// Default color associated with status.
    var color: Color {
        switch self {
            case .info:         return .blueNormal
            case .success:      return .greenNormal
            case .warning:      return .orangeNormal
            case .critical:     return .redNormal
        }
    }

    /// Default light color associated with status.
    var lightColor: Color {
        switch self {
            case .info:         return .blueLight
            case .success:      return .greenLight
            case .warning:      return .orangeLight
            case .critical:     return .redLight
        }
    }

    /// Default text color associated with status.
    var darkColor: Color {
        switch self {
            case .info:         return .blueDark
            case .success:      return .greenDark
            case .warning:      return .orangeDark
            case .critical:     return .redDark
        }
    }
}
