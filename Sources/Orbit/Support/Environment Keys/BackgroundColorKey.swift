import SwiftUI

/// Stores background default and active color used for Orbit components that contain background, such as `Card` or `Tile`.
public struct BackgroundColor {
    
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

struct BackgroundColorKey: EnvironmentKey {
    static let defaultValue: BackgroundColor? = nil
}

public extension EnvironmentValues {

    /// A background color stored in a view’s environment, used for Orbit components that contain background, such as `Card` or `Tile`.
    var backgroundColor: BackgroundColor? {
        get { self[BackgroundColorKey.self] }
        set { self[BackgroundColorKey.self] = newValue }
    }
}

public extension View {

    /// Set the separate inactive and active background colors for any supported Orbit component within the view hierarchy.
    ///
    /// - Parameters:
    ///   - color: A color or a gradient that will be used in supported touchable Orbit components such as `Tile` as inactive and active background style.
    ///   Pass `nil` to ignore environment value and to allow the system or the container to provide its own background style.
    func backgroundColor(_ color: BackgroundColor?) -> some View {
        environment(\.backgroundColor, color)
    }
    
    /// Set separate inactive and active background colors for any supported Orbit component within the view hierarchy.
    ///
    /// - Parameters:
    ///   - shape: A color or a gradient that will be used in supported Orbit components such as `Card` or `Badge` as a background style.
    ///   - active: A color or a gradient that will be used in supported touchable Orbit components such as `Tile` as an active (pressed) background style.
    func backgroundColor(_ shape: any ShapeStyle, active: any ShapeStyle) -> some View {
        backgroundColor(.init(inactive: shape, active: shape))
    }
    
    /// Set the background color for any supported Orbit component within the view hierarchy.
    ///
    /// - Parameters:
    ///   - shape: A color or a gradient that will be used in supported Orbit components such as `Card` or `Badge` as a background style.
    func backgroundColor(_ shape: any ShapeStyle) -> some View {
        backgroundColor(shape, active: shape)
    }
    

}
