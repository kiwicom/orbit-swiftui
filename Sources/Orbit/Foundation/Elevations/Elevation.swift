import SwiftUI

/// Use elevation to bring content closer to users.
///
/// Elevation levels with higher numbers are usually visually closer to the user.
public enum Elevation {
    case level1
    case level2
    case level3
    case level4
    case custom(opacity: Double, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0, padding: CGFloat? = nil)
}

/// A shape to use as a surface on which `elevation` is applied.
public enum ElevationShape {
    /// Elevation effect shape is based on provided content.
    ///
    /// To improve performance, the elevation can be applied on multiple views at once
    /// after setting `isElevationEnabled` to `false` in order to disable the elevation in subviews.
    case content

    // FIXME: Replace `roundedRectangle` with `shape(any Shape,...)`
    /// Elevation effect shape uses a rounded rectangle with specified background.
    /// The shadow effect is prerendered by default for better performance.
    ///
    /// The prerendered option uses more memory.
    case roundedRectangle(borderRadius: CGFloat = BorderRadius.default, isPrerendered: Bool = true)
}

public extension View {

    /// Elevates the view to make it more prominent.
    ///
    /// Effective only in light mode.
    func elevation(
        _ level: Elevation?,
        shadowColor: Color = Color(red: 79 / 255, green: 94 / 255, blue: 113 / 255),
        shape: ElevationShape = .content
    ) -> some View {
        modifier(ElevationModifier(level: level, shadowColor: shadowColor, shape: shape))
    }
}

struct ElevationModifier: ViewModifier {

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.isElevationEnabled) var isElevationEnabled
    let level: Elevation?
    let shadowColor: Color
    let shape: ElevationShape

    func body(content: Content) -> some View {
        if colorScheme != .dark, isElevationEnabled, let level = level {
            switch shape {
                case .content:
                    content
                        .shadow(level: level, shadowColor: shadowColor)
                case .roundedRectangle(let borderRadius, false):
                    content
                        .background(
                            roundedRectangle(borderRadius: borderRadius)
                                .shadow(level: level, shadowColor: shadowColor)
                        )
                case .roundedRectangle(let borderRadius, true):
                    content
                        .padding(prerenderedShadowPadding(for: level))
                        .background(
                            roundedRectangle(borderRadius: borderRadius)
                                .padding(prerenderedShadowPadding(for: level))
                                .prerenderedShadow(level: level, shadowColor: shadowColor)
                                .drawingGroup(colorMode: .extendedLinear)
                        )
                        .padding(-prerenderedShadowPadding(for: level))
            }
        } else {
            content
        }
    }

    @ViewBuilder func roundedRectangle(borderRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: borderRadius)
            // Inset to prevent overlay aliasing issues
            .inset(by: 0.15)
            .fill(Color.whiteDarker)
            // Required for correct rendering of snapshot tests
            .drawingGroup()
    }

    func prerenderedShadowPadding(for level: Elevation) -> CGFloat {
        switch level {
            case .level1:                                       return .small
            case .level2:                                       return .large
            case .level3:                                       return .xLarge
            case .level4:                                       return .xxLarge
            case .custom(_, let radius, _, let y, let padding): return padding ?? (radius + y)
        }
    }
}

private extension View {

    @ViewBuilder func prerenderedShadow(level: Elevation, shadowColor: Color) -> some View {
        switch level {
            case .level1:
                self
                    .shadow(color: shadowColor.opacity(0.22), radius: 1.4, y: 0.6)
                    .shadow(color: shadowColor.opacity(0.09), radius: 2.6, y: 3.6)
            case .level2:
                self
                    .shadow(color: shadowColor.opacity(0.26), radius: 3, y: 2.1)
                    .shadow(color: shadowColor.opacity(0.1), radius: 10, y: 9)
            case .level3:
                self
                    .shadow(color: shadowColor.opacity(0.28), radius: 2.8, y: 2.4)
                    .shadow(color: shadowColor.opacity(0.16), radius: 12, y: 12)
            case .level4:
                self
                    .shadow(color: shadowColor.opacity(0.3), radius: 3.2, y: 2.7)
                    .shadow(color: shadowColor.opacity(0.17), radius: 18, y: 18)
            case .custom(let opacity, let radius, let x, let y, _):
                self
                    .shadow(color: shadowColor.opacity(opacity), radius: radius, x: x, y: y)
        }
    }

    @ViewBuilder func shadow(level: Elevation, shadowColor: Color) -> some View {
        switch level {
            case .level1:
                self
                    .shadow(color: shadowColor.opacity(0.12), radius: 1, y: 0.5)
                    .shadow(color: shadowColor.opacity(0.11), radius: 2, y: 2)
                    .shadow(color: shadowColor.opacity(0.10), radius: 4, y: 4)
            case .level2:
                self
                    .shadow(color: shadowColor.opacity(0.12), radius: 2, y: 1)
                    .shadow(color: shadowColor.opacity(0.11), radius: 4, y: 4)
                    .shadow(color: shadowColor.opacity(0.10), radius: 8, y: 8)
            case .level3:
                self
                    .shadow(color: shadowColor.opacity(0.12), radius: 2, y: 1)
                    .shadow(color: shadowColor.opacity(0.11), radius: 4, y: 4)
                    .shadow(color: shadowColor.opacity(0.10), radius: 8, y: 8)
                    .shadow(color: shadowColor.opacity(0.06), radius: 16, y: 16)
            case .level4:
                self
                    .shadow(color: shadowColor.opacity(0.12), radius: 2, y: 1)
                    .shadow(color: shadowColor.opacity(0.11), radius: 4, y: 4)
                    .shadow(color: shadowColor.opacity(0.10), radius: 8, y: 8)
                    .shadow(color: shadowColor.opacity(0.09), radius: 16, y: 16)
                    .shadow(color: shadowColor.opacity(0.06), radius: 32, y: 32)
            case .custom(let opacity, let radius, let x, let y, _):
                self
                    .shadow(color: shadowColor.opacity(opacity), radius: radius, x: x, y: y)
        }
    }
}

struct ElevationPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            prerendered
            realtime
            compositingGroup
        }
        .previewLayout(.sizeThatFits)
    }

    static var snapshot: some View {
        realtime
    }

    static var prerendered: some View {
        HStack(spacing: 90) {
            squircle("Level 4")
                .elevation(.level4, shape: .roundedRectangle(borderRadius: 12))
            squircle("Level 3")
                .elevation(.level3, shape: .roundedRectangle(borderRadius: 12))
            squircle("Level 2")
                .elevation(.level2, shape: .roundedRectangle(borderRadius: 12))
            squircle("Level 1")
                .elevation(.level1, shape: .roundedRectangle(borderRadius: 12))
        }
        .padding(40)
        .previewDisplayName("Prerendered (Rounded Rectangle)")
    }

    static var realtime: some View {
        HStack(spacing: 90) {
            squircle("Level 4")
                .elevation(.level4)
            squircle("Level 3")
                .elevation(.level3)
            squircle("Level 2")
                .elevation(.level2)
            squircle("Level 1")
                .elevation(.level1)
        }
        .padding(40)
        .previewDisplayName("Content")
    }

    @ViewBuilder static var compositingGroup: some View {
        ZStack {
            squircle(" ")
                .offset(x: -20, y: -20)
            squircle("Content")
                .offset(x: 20, y: 20)
        }
        .padding(80)
        .background(Gradient.bundleTop.background.opacity(0.05))
        .environment(\.isElevationEnabled, false)
        .compositingGroup()
        .elevation(.level3)
        .previewDisplayName("With Compositing Group")

        HStack(spacing: 120) {
            ZStack {
                squircle(" ")
                    .elevation(.level3)
                    .offset(x: -20, y: -20)
                squircle("Content")
                    .elevation(.level3)
                    .offset(x: 20, y: 20)
            }

            ZStack {
                squircle(" ")
                    .elevation(.level3, shape: .roundedRectangle(borderRadius: 12))
                    .offset(x: -20, y: -20)
                squircle("Rounded\nRectangle")
                    .elevation(.level3, shape: .roundedRectangle(borderRadius: 12))
                    .offset(x: 20, y: 20)
            }
        }
        .padding(80)
        .background(Gradient.bundleTop.background.opacity(0.05))
        .previewDisplayName("Without Compositing Group (Default)")
    }

    static func squircle(_ title: String) -> some View {
        Heading(title, style: .title1)
            .frame(width: 260, height: 272)
            .background(Color.whiteDarker)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
