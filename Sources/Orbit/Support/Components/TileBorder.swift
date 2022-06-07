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
            .overlay(
                outerBorder
                    .animation(.easeIn(duration: 0.1), value: isSelected)
            )
            .overlay(compactSeparatorBorder, alignment: .top)
            .overlay(compactSeparatorBorder, alignment: .bottom)
    }

    @ViewBuilder var compactSeparatorBorder: some View {
        if isCompact {
            borderColor
                .frame(height: status == nil ? 1 : BorderWidth.emphasis)
                .animation(.easeIn(duration: 0.1), value: isSelected)
        }
    }

    @ViewBuilder var outerBorder: some View {
        if isCompact == false, style != .none {
            outerBorderShape
                .strokeBorder(borderColor, lineWidth: borderWidth)
                .blendMode(isSelected ? .normal : .darken)
        }
    }

    @ViewBuilder var outerBorderShape: some InsettableShape {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    var isCompact: Bool {
        (style == .iOS) && horizontalSizeClass == .compact
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

        if status != nil {
            return BorderWidth.emphasis
        }
        
        return 1
    }

    var borderColor: Color {
        if let status = status {
            return status.color
        }

        if isSelected {
            return .blueNormal
        }

        return .cloudDark
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
            content
                .tileBorder()

            content
                .tileBorder(backgroundColor: .whiteNormal)

            content
                .tileBorder(style: .iOS, backgroundColor: .whiteNormal)

            content
                .tileBorder(backgroundColor: .whiteNormal, shadow: .default)

            content
                .tileBorder(backgroundColor: .blueLight, shadow: .small)

            content
                .tileBorder(isSelected: true, backgroundColor: .blueLight, shadow: .small)

            content
                .tileBorder(status: .critical, backgroundColor: .blueLight, shadow: .small)

            content
                .tileBorder(isSelected: true, status: .critical, backgroundColor: .blueLight, shadow: .small)

            ListChoice("ListChoice")
                .tileBorder()
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var content: some View {
        Text("Content")
            .padding(.medium)
    }
}
