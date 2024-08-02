import SwiftUI

/// Predefined Orbit border styles for ``Tile``-like components.
public enum TileBorderStyle {
    case `default`
    /// A border style that visually matches the iOS plain table section appearance in `compact` width environment.
    case iOS
    /// A border with no elevation.
    case plain
}

/// Provides decoration using Orbit ``Tile`` appearance.
public struct TileBorderModifier: ViewModifier {

    static let animation: Animation = .easeIn(duration: 0.15)

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.status) private var status

    private let style: TileBorderStyle?
    private let isSelected: Bool

    public func body(content: Content) -> some View {
        content
            .clipShape(clipShape)
            .compositingGroup()
            .elevation(elevation, shape: .roundedRectangle(borderRadius: cornerRadius))
            .overlay(border.animation(Self.animation, value: isSelected))
    }

    @ViewBuilder private var border: some View {
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

    @ViewBuilder private var compactSeparatorBorder: some View {
        borderColor
            .frame(height: status == nil ? 1 : BorderWidth.active)
    }

    @ViewBuilder private var clipShape: some InsettableShape {
        RoundedRectangle(cornerRadius: cornerRadius)
    }

    private var isCompact: Bool {
        (style == .iOS) && horizontalSizeClass == .compact
    }

    private var cornerRadius: CGFloat {
        switch (style, horizontalSizeClass) {
            case (.default, _):     return BorderRadius.default
            case (.plain, _):       return BorderRadius.default
            case (.iOS, .regular):  return BorderRadius.default
            case (.iOS, _):         return 0
            case (.none, _):        return 0
        }
    }

    private var elevation: Elevation? {
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

    private var borderWidth: CGFloat {
        isSelected || status != nil
            ? BorderWidth.active
            : 1
    }

    private var borderColor: Color {
        if let status = status {
            return status.color
        }

        if isSelected {
            return .blueNormal
        }

        return showOuterBorder ? .cloudNormal : .clear
    }

    private var showOuterBorder: Bool {
        switch style {
            case .iOS, .plain:      return true
            case .none, .default:   return false
        }
    }
    
    /// Creates Orbit ``TileBorderModifier``.
    public init(style: TileBorderStyle?, isSelected: Bool) {
        self.style = style
        self.isSelected = isSelected
    }
}

public extension View {

    /// Decorates content with Orbit border similar to ``Tile`` or ``Card`` appearance using specified style.
    func tileBorder(
        _ style: TileBorderStyle? = .default,
        isSelected: Bool = false
    ) -> some View {
        modifier(
            TileBorderModifier(
                style: style,
                isSelected: isSelected
            )
        )
    }
}

// MARK: - Previews
struct TileBorderModifierPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            VStack(spacing: .medium) {
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
            }
                
            Group {
                content
                    .background(Color.blueLight)
                    .tileBorder()

                content
                    .background(Color.blueLight)
                    .tileBorder(isSelected: true)
            }
            .status(.critical)

            ListChoice("ListChoice", action: {})
                .showsSeparator(false)
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
