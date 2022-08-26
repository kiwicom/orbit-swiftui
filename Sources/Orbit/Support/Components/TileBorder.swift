import SwiftUI

public enum TileBorderStyle {
    case none
    case `default`
    /// A border style that visually matches the iOS plain table section appearance in `compact` width environment.
    case iOS
    /// A border with no elevation.
    case plain
}

/// Provides decoration with ``Tile`` appearance.
public struct TileBorderModifier: ViewModifier {

    static let animation: Animation = .easeIn(duration: 0.15)

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let style: TileBorderStyle
    let isSelected: Bool
    let status: Status?

    public func body(content: Content) -> some View {
        content
            .clipShape(clipShape)
            .compositingGroup()
            .elevation(elevation, shape: .roundedRectangle(borderRadius: cornerRadius))
            .overlay(border.animation(Self.animation, value: isSelected))
    }

    @ViewBuilder var border: some View {
        switch (style, horizontalSizeClass) {
            case (.none, _):
                EmptyView()
            case (.default, _), (.plain, _), (.iOS, .regular):
                clipShape
                    .strokeBorder(borderColor, lineWidth: borderWidth)
                    .blendMode(isSelected ? .normal : .darken)
            case (.iOS, _):
                VStack {
                    compactSeparatorBorder
                    Spacer()
                    compactSeparatorBorder
                }
        }
    }

    @ViewBuilder var compactSeparatorBorder: some View {
        borderColor
            .frame(height: status == nil ? 1 : BorderWidth.emphasis)
    }

    @ViewBuilder var clipShape: some InsettableShape {
        RoundedRectangle(cornerRadius: cornerRadius)
    }

    var isCompact: Bool {
        (style == .iOS) && horizontalSizeClass == .compact
    }

    var cornerRadius: CGFloat {
        switch (style, horizontalSizeClass) {
            case (.default, _):     return BorderRadius.default
            case (.plain, _):       return BorderRadius.default
            case (.iOS, .regular):  return BorderRadius.default
            case (.iOS, _):         return 0
            case (.none, _):        return 0
        }
    }

    var elevation: Elevation? {
        guard status == .none else {
            return nil
        }

        switch style {
            case .default:
                return .level1
            case .none, .plain, .iOS:
                return nil
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

        return showOuterBorder ? .cloudDark : .clear
    }

    var showOuterBorder: Bool {
        switch style {
            case .iOS, .plain:      return true
            case .none, .default:   return false
        }
    }
}

public extension View {

    /// Decorates content with a border similar to ``Tile`` or ``Card`` appearance using specified style.
    func tileBorder(
        _ style: TileBorderStyle = .default,
        isSelected: Bool = false,
        status: Status? = nil
    ) -> some View {
        modifier(
            TileBorderModifier(
                style: style,
                isSelected: isSelected,
                status: status
            )
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
                .tileBorder(.plain)

            content
                .tileBorder(.iOS)

            content
                .tileBorder(.iOS, isSelected: true)

            content
                .background(Color.blueLight)
                .tileBorder()

            content
                .background(Color.blueLight)
                .tileBorder(isSelected: true)

            content
                .background(Color.blueLight)
                .tileBorder(status: .critical)

            content
                .background(Color.blueLight)
                .tileBorder(isSelected: true, status: .critical)

            ListChoice("ListChoice", showSeparator: false)
                .fixedSize()
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
