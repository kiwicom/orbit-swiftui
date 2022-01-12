import SwiftUI

/// Provides decoration with ``Tile`` appearance.
public struct TileBorder: ViewModifier {

    public enum Shadow {
        case none
        case `default`
        case small
    }
    
    public enum Style {
        case `default`
        /// A card style that visually matches the iOS plain table section appearance.
        case iOS
    }

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let style: Style?
    let status: Status?
    let backgroundColor: Color?
    let shadow: Shadow

    public func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: shadowColor.opacity(shadowOpacity.primary), radius: shadowRadius.primary, x: 0, y: 2)
            .shadow(color: shadowColor.opacity(shadowOpacity.secondary), radius: shadowRadius.secondary, x: 0, y: 5)
            .overlay(outerBorder)
            .overlay(verticalBorder, alignment: .top)
            .overlay(verticalBorder, alignment: .bottom)
    }

    @ViewBuilder var verticalBorder: some View {
        if style == .iOS, horizontalSizeClass != .regular {
            borderColor
                .frame(height: status == nil ? BorderWidth.hairline : BorderWidth.emphasis)
        }
    }

    @ViewBuilder var outerBorder: some View {
        switch (style, status) {
            case (.default, let status?):
                outerBorderShape
                    .strokeBorder(status.color, lineWidth: borderWidth)
            case (.default, .none):
                outerBorderShape
                    .strokeBorder(outerBorderGradient, lineWidth: borderWidth)
                    .blendMode(.darken)
            default:
                outerBorderShape
                    .strokeBorder(borderColor, lineWidth: borderWidth)
        }
    }

    @ViewBuilder var outerBorderShape: some InsettableShape {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }
    
    var shadowRadius: (primary: CGFloat, secondary: CGFloat) {
        switch shadow {
            case .none:         return (0, 0)
            case .default:      return (1.5, 6)
            case .small:        return (2, 6)
        }
    }
    
    var shadowOpacity: (primary: CGFloat, secondary: CGFloat) {
        switch shadow {
            case .none:         return (0, 0)
            case .default:      return (0.3, 0.6)
            case .small:        return (0.5, 0.2)
        }
    }

    var outerBorderGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [bottomBorderColor, bottomBorderColor.opacity(0.5)]),
            startPoint: .bottom,
            endPoint: .top
        )
    }

    var cornerRadius: CGFloat {
        switch (style, horizontalSizeClass) {
            case (.default, _):     return BorderRadius.default
            case (.iOS, .regular):  return BorderRadius.default
            case (.iOS, _):         return 0
            case (.none, _):        return 0
        }
    }

    var shadowColor: Color {
        switch style {
            case .default:          return .inkNormal.opacity(0.15)
            case .none, .iOS:       return .clear
        }
    }

    var borderWidth: CGFloat {
        switch (style, status, horizontalSizeClass) {
            case (.default, _?, _):         return BorderWidth.emphasis
            case (.iOS, _?, .regular):      return BorderWidth.emphasis
            case (.default, .none, _):      return BorderWidth.thin
            case (.iOS, .none, .regular):   return BorderWidth.thin
            default:                        return 0
        }
    }

    var borderColor: Color {
        switch (style, status, horizontalSizeClass) {
            case (.default, let status?, _):    return status.color
            case (.iOS, let status?, _):        return status.color
            case (.default, .none, _):          return bottomBorderColor
            case (.iOS, .none, .regular):       return .cloudNormalActive
            case (.iOS, .none, _):              return .cloudDarker
            default:                            return .clear
        }
    }

    var bottomBorderColor: Color {
        .cloudDarker.opacity(0.65)
    }
}

public extension View {

    /// Decorates content with a ``Tile`` appearance using specified style.
    ///
    /// - Parameter style: The style to apply. If style is nil, the view doesn’t get decorated.
    func tileBorder(
        style: TileBorder.Style? = .default,
        status: Status? = nil,
        backgroundColor: Color? = nil,
        shadow: TileBorder.Shadow = .default
    ) -> some View {
        modifier(
            TileBorder(style: style, status: status, backgroundColor: backgroundColor, shadow: shadow)
        )
    }
}
