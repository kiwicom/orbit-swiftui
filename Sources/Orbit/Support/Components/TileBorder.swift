import SwiftUI

public enum TileBorderStyle {
    case none
    case `default`
    /// A border style that visually matches the iOS plain table section appearance.
    case iOS
}

/// Provides decoration with ``Tile`` appearance.
public struct TileBorderModifier: ViewModifier {

    static let animation: Animation = .easeIn(duration: 0.15)

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let style: TileBorderStyle
    let isSelected: Bool
    let status: Status?
    let backgroundColor: Color?
    let isPressed: Bool

    public func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .clipShape(clipShape)
            .compositingGroup()
            .elevation(elevation)
            .animation(Self.animation, value: isPressed)
            .overlay(border.animation(Self.animation, value: isSelected))
    }

    @ViewBuilder var border: some View {
        switch style {
            case .none:
                EmptyView()
            case .default:
                clipShape
                    .strokeBorder(borderColor, lineWidth: borderWidth)
                    .blendMode(isSelected ? .normal : .darken)
            case .iOS:
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
            case (.iOS, .regular):  return BorderRadius.default
            case (.iOS, _):         return 0
            case (.none, _):        return 0
        }
    }

    var elevation: Elevation? {
        guard style == .default, status == .none, isPressed == false else {
            return nil
        }

        return .level1
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
        style == .iOS
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
        backgroundColor: Color? = .whiteNormal,
        isPressed: Bool = false
    ) -> some View {
        modifier(
            TileBorderModifier(
                style: style,
                isSelected: isSelected,
                status: status,
                backgroundColor: backgroundColor,
                isPressed: isPressed
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
                .tileBorder(style: .iOS)

            content
                .tileBorder(style: .iOS, isSelected: true)

            content
                .tileBorder(backgroundColor: .blueLight)

            content
                .tileBorder(isSelected: true, backgroundColor: .blueLight)

            content
                .tileBorder(status: .critical, backgroundColor: .blueLight)

            content
                .tileBorder(isSelected: true, status: .critical, backgroundColor: .blueLight)

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
