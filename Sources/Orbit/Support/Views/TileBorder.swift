import SwiftUI

/// Provides decoration with ``Tile`` appearance.
public struct TileBorder: ViewModifier {

    public enum ShadowSize {
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
    let shadowSize: ShadowSize

    public func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(
                color: shadowColor.opacity(shadowSize == .small ? 0.8 : 0.3),
                radius: shadowSize == .small ? 2 : 1.5, x: 0, y: 2
            )
            .shadow(color: shadowColor.opacity(shadowSize == .small ? 0 : 0.6), radius: 6, x: 0, y: 5)
            .overlay(outerBorder)
            .overlay(verticalBorder, alignment: .top)
            .overlay(verticalBorder, alignment: .bottom)
    }

    @ViewBuilder var verticalBorder: some View {
        if style == .iOS, horizontalSizeClass != .regular {
            borderColor
                .frame(height: status == nil ? BorderWidth.thin : BorderWidth.emphasis)
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
        if status != nil { return .clear }

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
        shadowSize: TileBorder.ShadowSize = .default
    ) -> some View {
        modifier(
            TileBorder(style: style, status: status, backgroundColor: backgroundColor, shadowSize: shadowSize)
        )
    }
}
