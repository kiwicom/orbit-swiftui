import SwiftUI

/// Defines Orbit gradient styles.
public enum Gradient {
    case bundleBasic
    case bundleMedium
    case bundleTop
    
    @ViewBuilder public var background: some View {
        switch self {
            case .bundleBasic:              LinearGradient.bundleBasic
            case .bundleMedium:             LinearGradient.bundleMedium
            case .bundleTop:                LinearGradient.bundleTop
        }
    }
    
    public var color: Color {
        switch self {
            case .bundleBasic:              return .bundleBasic
            case .bundleMedium:             return .bundleMedium
            case .bundleTop:                return .inkNormal
        }
    }
    
    public var uiColor: UIColor {
        switch self {
            case .bundleBasic:              return .bundleBasic
            case .bundleMedium:             return .bundleMedium
            case .bundleTop:                return .inkNormal
        }
    }
    
    public var startColor: Color {
        switch self {
            case .bundleBasic:              return .bundleBasicStart
            case .bundleMedium:             return .bundleMediumStart
            case .bundleTop:                return .bundleTopStart
        }
    }
    
    public var startUiColor: UIColor {
        switch self {
            case .bundleBasic:              return .bundleBasicStart
            case .bundleMedium:             return .bundleMediumStart
            case .bundleTop:                return .bundleTopStart
        }
    }
    
    public var endColor: Color {
        switch self {
            case .bundleBasic:              return .bundleBasicEnd
            case .bundleMedium:             return .bundleMediumEnd
            case .bundleTop:                return .bundleTopEnd
        }
    }
    
    public var endUiColor: UIColor {
        switch self {
            case .bundleBasic:              return .bundleBasicEnd
            case .bundleMedium:             return .bundleMediumEnd
            case .bundleTop:                return .bundleTopEnd
        }
    }
}

public extension LinearGradient {

    static let bundleBasic = LinearGradient(
        colors: [.bundleBasicStart, .bundleBasicEnd], startPoint: .bottomLeading, endPoint: .topTrailing
    )
    
    static let bundleMedium = LinearGradient(
        colors: [.bundleMediumStart, .bundleMediumEnd], startPoint: .bottomLeading, endPoint: .topTrailing
    )
    
    static let bundleTop = LinearGradient(
        colors: [.bundleTopStart, .bundleTopEnd], startPoint: .bottomLeading, endPoint: .topTrailing
    )
}

public extension Color {
    
    static let bundleBasicStart = Color(red: 0.882, green: 0.243, blue: 0.231)
    static let bundleBasicEnd = Color(red: 0.91, green: 0.494, blue: 0.035)
    static let bundleMediumStart = Color(red: 0.216, green: 0.098, blue: 0.671)
    static let bundleMediumEnd = Color(red: 0.522, green: 0.224, blue: 0.859)
    static let bundleTopStart = Color(red: 0.176, green: 0.176, blue: 0.18)
    static let bundleTopEnd = Color(red: 0.412, green: 0.431, blue: 0.451)
}

public extension UIColor {
    
    static let bundleBasicStart = UIColor(red: 0.882, green: 0.243, blue: 0.231, alpha: 1)
    static let bundleBasicEnd = UIColor(red: 0.91, green: 0.494, blue: 0.035, alpha: 1)
    static let bundleMediumStart = UIColor(red: 0.216, green: 0.098, blue: 0.671, alpha: 1)
    static let bundleMediumEnd = UIColor(red: 0.522, green: 0.224, blue: 0.859, alpha: 1)
    static let bundleTopStart = UIColor(red: 0.176, green: 0.176, blue: 0.18, alpha: 1)
    static let bundleTopEnd = UIColor(red: 0.412, green: 0.431, blue: 0.451, alpha: 1)
}
