import SwiftUI

/// Stores background shapes used for Orbit components that render their own background, such as `Card` or `Tile`.
public struct BackgroundShape {
    
    public let inactive: any ShapeStyle
    public let active: any ShapeStyle
    
    @ViewBuilder public var inactiveView: some View {
        switch inactive {
            case let color as Color:            color
            case let color as LinearGradient:   color
            case let color as RadialGradient:   color
            default:                            EmptyView()
        }
    }
    
    @ViewBuilder public var activeView: some View {
        switch active {
            case let color as Color:            color
            case let color as LinearGradient:   color
            case let color as RadialGradient:   color
            default:                            EmptyView()
        }
    }
}

struct BackgroundShapeKey: EnvironmentKey {
    static let defaultValue: BackgroundShape? = nil
}

public extension EnvironmentValues {

    /// An optional background shape style stored in a view’s environment, used for Orbit components that contain background, such as `Card` or `Tile`.
    ///
    /// This is an Orbit counterpart to the native `backgroundStyle` environment key available in iOS 16.
    var backgroundShape: BackgroundShape? {
        get { self[BackgroundShapeKey.self] }
        set { self[BackgroundShapeKey.self] = newValue }
    }
}

public extension View {

    /// Set the inactive and active background shape styles for supported Orbit components within the view hierarchy.
    ///
    /// To restore the default background style, set the `backgroundShape` environment value to nil using the environment(_:_:) modifer.
    ///
    /// - Parameters:
    ///   - shape: A `Color` or a `LinearGradient` that will be used in supported Orbit components such as `Card` or `Badge` as a background style.
    ///   - shape: A `Color` or a `LinearGradient` that will be used in supported touchable Orbit components such as `Tile` as inactive and active background style.
    func backgroundStyle(_ shape: any ShapeStyle, active: any ShapeStyle) -> some View {
        environment(\.backgroundShape, .init(inactive: shape, active: active))
    }
    
    /// Set the background shape style for supported Orbit components within the view hierarchy.
    ///
    /// To restore the default background style, set the `backgroundShape` environment value to nil using the environment(_:_:) modifer.
    ///
    /// - Parameters:
    ///   - shape: A `Color` or a `LinearGradient` that will be used in supported Orbit components such as `Card` or `Badge` as a background style.
    func backgroundStyle(_ shape: any ShapeStyle) -> some View {
        backgroundStyle(shape, active: shape)
    }
}
