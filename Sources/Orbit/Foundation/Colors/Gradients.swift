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
            case .bundleTop:                return .inkDark
        }
    }

    public var startColor: Color {
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
}

public extension LinearGradient {

    static var bundleBasic: LinearGradient {
        .init(
            colors: [.bundleBasicStart, .bundleBasicEnd],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
    
    static var bundleMedium: LinearGradient {
        .init(
            colors: [.bundleMediumStart, .bundleMediumEnd],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
    
    static var bundleTop: LinearGradient {
        .init(
            colors: [.bundleTopStart, .bundleTopEnd],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
}

public extension Color {
    
    static var bundleBasicStart = Color(UIColor.bundleBasicStart)
    static var bundleBasicEnd = Color(UIColor.bundleBasicEnd)
    static var bundleMediumStart = Color(UIColor.bundleMediumStart)
    static var bundleMediumEnd = Color(UIColor.bundleMediumEnd)
    static var bundleTopStart = Color(UIColor.bundleTopStart)
    static var bundleTopEnd = Color(UIColor.bundleTopEnd)
}

public extension UIColor {
    
    static var bundleBasicStart = UIColor(red: 0.882, green: 0.243, blue: 0.231, alpha: 1)
    static var bundleBasicEnd = UIColor(red: 0.91, green: 0.494, blue: 0.035, alpha: 1)
    static var bundleMediumStart = UIColor(red: 0.216, green: 0.098, blue: 0.671, alpha: 1)
    static var bundleMediumEnd = UIColor(red: 0.522, green: 0.224, blue: 0.859, alpha: 1)
    static var bundleTopStart = UIColor(red: 0.176, green: 0.176, blue: 0.18, alpha: 1)
    static var bundleTopEnd = UIColor(red: 0.412, green: 0.431, blue: 0.451, alpha: 1)
}
