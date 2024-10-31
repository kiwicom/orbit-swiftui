import SwiftUI

/// Non-default status of Orbit components.
public enum Status: Equatable, Sendable {
    case info
    case success
    case warning
    case critical
}

public extension Status {

    /// Default icon associated with status.
    var icon: Icon.Symbol? {
        switch self {
            case .info:     nil
            case .success:  .informationCircle
            case .warning:  .alert
            case .critical: .alertCircle
        }
    }

    /// Color associated with status.
    var color: Color {
        switch self {
            case .info:     .blueNormal
            case .success:  .greenNormal
            case .warning:  .orangeNormal
            case .critical: .redNormal
        }
    }

    /// Light color associated with status.
    var lightColor: Color {
        switch self {
            case .info:     .blueLight
            case .success:  .greenLight
            case .warning:  .orangeLight
            case .critical: .redLight
        }
    }

    /// Light hover color associated with status.
    var lightHoverColor: Color {
        switch self {
            case .info:     .blueLightHover
            case .success:  .greenLightHover
            case .warning:  .orangeLightHover
            case .critical: .redLightHover
        }
    }

    /// Dark color associated with status.
    var darkColor: Color {
        switch self {
            case .info:     .blueDark
            case .success:  .greenDark
            case .warning:  .orangeDark
            case .critical: .redDark
        }
    }

    /// Dark hover color associated with status.
    var darkHoverColor: Color {
        switch self {
            case .info:     .blueDarkHover
            case .success:  .greenDarkHover
            case .warning:  .orangeDarkHover
            case .critical: .redDarkHover
        }
    }

    /// Active color associated with status.
    var activeColor: Color {
        switch self {
            case .info:     .blueNormalActive
            case .success:  .greenNormalActive
            case .warning:  .orangeNormalActive
            case .critical: .redNormalActive
        }
    }

    /// Dark active color associated with status.
    var darkActiveColor: Color {
        switch self {
            case .info:     .blueDarkActive
            case .success:  .greenDarkActive
            case .warning:  .orangeDarkActive
            case .critical: .redDarkActive
        }
    }

    /// Light active color associated with status.
    var lightActiveColor: Color {
        switch self {
            case .info:     .blueLightActive
            case .success:  .greenLightActive
            case .warning:  .orangeLightActive
            case .critical: .redLightActive
        }
    }

    /// The default haptic feedback associated with status.
    var defaultHapticFeedback: HapticsProvider.HapticFeedbackType {
        switch self {
            case .info, .success: .light(0.5)
            case .warning:        .notification(.warning)
            case .critical:       .notification(.error)
        }
    }
}
