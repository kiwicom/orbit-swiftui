import SwiftUI

/// Non-default status of a component.
public enum Status: Equatable {
    case info
    case success
    case warning
    case critical
}

public extension Status {

    /// Default icon associated with status.
    var icon: Icon.Symbol? {
        switch self {
            case .info:         return nil
            case .success:      return .informationCircle
            case .warning:      return .alert
            case .critical:     return .alertCircle
        }
    }

    /// Color associated with status.
    var color: Color {
        switch self {
            case .info:         return .blueNormal
            case .success:      return .greenNormal
            case .warning:      return .orangeNormal
            case .critical:     return .redNormal
        }
    }

    /// Light color associated with status.
    var lightColor: Color {
        switch self {
            case .info:         return .blueLight
            case .success:      return .greenLight
            case .warning:      return .orangeLight
            case .critical:     return .redLight
        }
    }

    /// Light hover color associated with status.
    var lightHoverColor: Color {
        switch self {
            case .info:         return .blueLightHover
            case .success:      return .greenLightHover
            case .warning:      return .orangeLightHover
            case .critical:     return .redLightHover
        }
    }

    /// Dark color associated with status.
    var darkColor: Color {
        switch self {
            case .info:         return .blueDark
            case .success:      return .greenDark
            case .warning:      return .orangeDark
            case .critical:     return .redDark
        }
    }

    /// Dark hover color associated with status.
    var darkHoverColor: Color {
        switch self {
            case .info:         return .blueDarkHover
            case .success:      return .greenDarkHover
            case .warning:      return .orangeDarkHover
            case .critical:     return .redDarkHover
        }
    }

    /// Active color associated with status.
    var activeColor: Color {
        switch self {
            case .info:         return .blueNormalActive
            case .success:      return .greenNormalActive
            case .warning:      return .orangeNormalActive
            case .critical:     return .redNormalActive
        }
    }

    /// Dark active color associated with status.
    var darkActiveColor: Color {
        switch self {
            case .info:         return .blueDarkActive
            case .success:      return .greenDarkActive
            case .warning:      return .orangeDarkActive
            case .critical:     return .redDarkActive
        }
    }

    /// Light active color associated with status.
    var lightActiveColor: Color {
        switch self {
            case .info:         return .blueLightActive
            case .success:      return .greenLightActive
            case .warning:      return .orangeLightActive
            case .critical:     return .redLightActive
        }
    }
}
