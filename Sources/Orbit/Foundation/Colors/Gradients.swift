import SwiftUI

/// Predefined Orbit gradient styles.
public enum Gradient: Sendable {
    
    case bundleBasic
    case bundleMedium
    case bundleTop
    
    public var background: LinearGradient {
        switch self {
            case .bundleBasic:              return .bundleBasic
            case .bundleMedium:             return .bundleMedium
            case .bundleTop:                return .bundleTop
        }
    }
    
    public var textColor: Color {
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

public extension ShapeStyle where Self == LinearGradient {

    static var bundleBasic: Self {
        .init(
            colors: [.bundleBasicStart, .bundleBasicEnd],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
    
    static var bundleMedium: Self {
        .init(
            colors: [.bundleMediumStart, .bundleMediumEnd],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
    
    static var bundleTop: Self {
        .init(
            colors: [.bundleTopStart, .bundleTopEnd],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
}

public extension Color {

    static let bundleBasicStart: Color = .init(.bundleBasicStart)
    static let bundleBasicEnd: Color = .init(.bundleBasicEnd)
    static let bundleMediumStart: Color = .init(.bundleMediumStart)
    static let bundleMediumEnd: Color = .init(.bundleMediumEnd)
    static let bundleTopStart: Color = .init(.bundleTopStart)
    static let bundleTopEnd: Color = .init(.bundleTopEnd)
}

public extension ShapeStyle where Self == Color {
    
    static var bundleBasicStart: Self { .bundleBasicStart }
    static var bundleBasicEnd: Self { .bundleBasicEnd }
    static var bundleMediumStart: Self { .bundleMediumStart }
    static var bundleMediumEnd: Self { .bundleMediumEnd }
    static var bundleTopStart: Self { .bundleTopStart }
    static var bundleTopEnd: Self { .bundleTopEnd }
}

public extension UIColor {
    
    static let bundleBasicStart = UIColor(red: 0.882, green: 0.243, blue: 0.231, alpha: 1)
    static let bundleBasicEnd = UIColor(red: 0.91, green: 0.494, blue: 0.035, alpha: 1)
    static let bundleMediumStart = UIColor(red: 0.216, green: 0.098, blue: 0.671, alpha: 1)
    static let bundleMediumEnd = UIColor(red: 0.522, green: 0.224, blue: 0.859, alpha: 1)
    static let bundleTopStart = UIColor(red: 0.176, green: 0.176, blue: 0.18, alpha: 1)
    static let bundleTopEnd = UIColor(red: 0.412, green: 0.431, blue: 0.451, alpha: 1)
}
