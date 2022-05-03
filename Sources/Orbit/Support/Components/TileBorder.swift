import SwiftUI

public enum TileBorderStyle {
    case none
    case `default`
    /// A border style that visually matches the iOS plain table section appearance.
    case iOS
}

/// Provides decoration with ``Tile`` appearance.
public struct TileBorderModifier: ViewModifier {

    public enum Shadow {
        case none
        case `default`
        case small
    }

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let style: TileBorderStyle
    let isSelected: Bool
    let status: Status?
    let backgroundColor: Color?
    let shadow: Shadow

    public func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: shadowColor.opacity(shadowOpacity.primary), radius: shadowRadius.primary, x: 0, y: 0.75)
            .shadow(color: shadowColor.opacity(shadowOpacity.secondary), radius: shadowRadius.secondary, x: 0, y: 5)
            .overlay(outerBorder.animation(.easeIn(duration: 0.1), value: isSelected))
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
            case (.none, _):
                EmptyView()
            case (.default, let status?):
                outerBorderShape
                    .strokeBorder(status.color, lineWidth: borderWidth)
            case (.default, .none):
                if isSelected {
                    outerBorderShape
                        .strokeBorder(Color.blueNormal, lineWidth: borderWidth)
                } else {
                    outerBorderShape
                        .stroke(borderColor, lineWidth: borderWidth)
                        .blendMode(.darken)
                }
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
            case .default:      return (0.3, 0.5)
            case .small:        return (0.5, 0.2)
        }
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
        if status != .none {
            return .clear
        }
        
        switch style {
            case .default:          return .inkNormal.opacity(0.15)
            case .none, .iOS:       return .clear
        }
    }

    var borderWidth: CGFloat {
        if isSelected {
            return BorderWidth.selection
        }
        
        switch (style, status, horizontalSizeClass) {
            case (.default, _?, _):         return BorderWidth.emphasis
            case (.iOS, _?, .regular):      return BorderWidth.emphasis
            case (.default, .none, _):      return BorderWidth.hairline
            case (.iOS, .none, .regular):   return BorderWidth.hairline
            default:                        return 0
        }
    }

    var borderColor: Color {
        switch (style, status, horizontalSizeClass) {
            case (.default, let status?, _):    return status.color
            case (.iOS, let status?, _):        return status.color
            case (.default, .none, _):          return .cloudDark
            case (.iOS, .none, .regular):       return .cloudNormalActive
            case (.iOS, .none, _):              return .cloudDarker
            default:                            return .clear
        }
    }
}

public extension View {

    /// Decorates content with a ``Tile`` appearance using specified style.
    ///
    /// - Parameter style: The style to apply. If style is nil, the view doesn’t get decorated.
    func tileBorder(
        style: TileBorderStyle = .default,
        isSelected: Bool = false,
        status: Status? = nil,
        backgroundColor: Color? = nil,
        shadow: TileBorderModifier.Shadow = .default
    ) -> some View {
        modifier(
            TileBorderModifier(style: style, isSelected: isSelected, status: status, backgroundColor: backgroundColor, shadow: shadow)
        )
    }
}

// MARK: - Previews
struct TileBorderModifierPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            Text("Content")
                .padding()
                .tileBorder()
                .padding()

            Text("Content")
                .padding()
                .tileBorder(backgroundColor: .whiteNormal)
                .padding()

            Text("Content")
                .padding()
                .tileBorder(style: .iOS, backgroundColor: .whiteNormal)
                .padding()

            Text("Content")
                .padding()
                .tileBorder(backgroundColor: .whiteNormal, shadow: .default)
                .padding()

            Text("Content")
                .padding()
                .tileBorder(isSelected: true, backgroundColor: .blueLight, shadow: .small)
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
