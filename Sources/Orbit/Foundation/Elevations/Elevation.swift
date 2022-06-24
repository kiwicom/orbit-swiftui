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

public extension View {

    /// Elevates the view to make it more prominent.
    func elevation(_ level: Elevation?) -> some View {
        elevation(level, prerender: true)
    }
}

extension View {

    func elevation(_ level: Elevation?, prerender: Bool) -> some View {
        modifier(ElevationModifier(level: level, isPrerendered: prerender))
    }
}

struct ElevationModifier: ViewModifier {

    @Environment(\.isElevationEnabled) var isElevationEnabled
    let level: Elevation?
    let isPrerendered: Bool
    let shadowColor = Color(red: 79 / 255, green: 94 / 255, blue: 113 / 255)

    func body(content: Content) -> some View {
        if isElevationEnabled {
            if isPrerendered {
                content
                    .background(prerenderedShadow(content: content))
            } else {
                liveShadow(content: content)
            }
        } else {
            content
        }
    }

    @ViewBuilder func prerenderedShadow(content: Content) -> some View {
        switch level {
            case .level1:
                content
                    .shadow(color: shadowColor.opacity(0.32), radius: 2.4, y: 1.9)
                    .padding(.small)
                    .drawingGroup(colorMode: .extendedLinear)
            case .level2:
                content
                    .shadow(color: shadowColor.opacity(0.26), radius: 3, y: 2.1)
                    .shadow(color: shadowColor.opacity(0.1), radius: 10, y: 9)
                    .padding(.large)
                    .drawingGroup(colorMode: .extendedLinear)
            case .level3:
                content
                    .shadow(color: shadowColor.opacity(0.28), radius: 2.8, y: 2.4)
                    .shadow(color: shadowColor.opacity(0.16), radius: 12, y: 12)
                    .padding(.xLarge)
                    .drawingGroup(colorMode: .extendedLinear)
            case .level4:
                content
                    .shadow(color: shadowColor.opacity(0.3), radius: 3.2, y: 2.7)
                    .shadow(color: shadowColor.opacity(0.17), radius: 18, y: 18)
                    .padding(.xxLarge)
                    .drawingGroup(colorMode: .extendedLinear)
            case .custom(let opacity, let radius, let x, let y, let padding):
                content
                    .shadow(color: shadowColor.opacity(opacity), radius: radius, x: x, y: y)
                    .padding(padding ?? (radius + y))
                    .drawingGroup(colorMode: .extendedLinear)
            case nil:
                content
        }
    }

    @ViewBuilder func liveShadow(content: Content) -> some View {
        switch level {
            case .level1:
                content
                    .shadow(color: shadowColor.opacity(0.12), radius: 1, y: 1)
                    .shadow(color: shadowColor.opacity(0.11), radius: 2, y: 2)
                    .shadow(color: shadowColor.opacity(0.10), radius: 4, y: 4)
            case .level2:
                content
                    .shadow(color: shadowColor.opacity(0.12), radius: 2, y: 2)
                    .shadow(color: shadowColor.opacity(0.11), radius: 4, y: 4)
                    .shadow(color: shadowColor.opacity(0.10), radius: 8, y: 8)
            case .level3:
                content
                    .shadow(color: shadowColor.opacity(0.12), radius: 2, y: 2)
                    .shadow(color: shadowColor.opacity(0.11), radius: 4, y: 4)
                    .shadow(color: shadowColor.opacity(0.10), radius: 8, y: 8)
                    .shadow(color: shadowColor.opacity(0.06), radius: 16, y: 16)
            case .level4:
                content
                    .shadow(color: shadowColor.opacity(0.12), radius: 2, y: 2)
                    .shadow(color: shadowColor.opacity(0.11), radius: 4, y: 4)
                    .shadow(color: shadowColor.opacity(0.10), radius: 8, y: 8)
                    .shadow(color: shadowColor.opacity(0.09), radius: 16, y: 16)
                    .shadow(color: shadowColor.opacity(0.06), radius: 32, y: 32)
            case .custom(let opacity, let radius, let x, let y, _):
                content
                    .shadow(color: shadowColor.opacity(opacity), radius: radius, x: x, y: y)
            case nil:
                content
        }
    }
}

struct ElevationPreviews: PreviewProvider {

    static var previews: some View {
        prerendered
            .previewLayout(.sizeThatFits)
        snapshot
            .previewLayout(.sizeThatFits)
        compositingGroup
            .previewLayout(.sizeThatFits)
    }

    static var snapshot: some View {
        PreviewWrapper {
            live
        }
    }

    static var prerendered: some View {
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
        .fixedSize()
        .previewDisplayName("Prerendered")
    }

    static var live: some View {
        HStack(spacing: 90) {
            squircle("Level 4")
                .elevation(.level4, prerender: false)
            squircle("Level 3")
                .elevation(.level3, prerender: false)
            squircle("Level 2")
                .elevation(.level2, prerender: false)
            squircle("Level 1")
                .elevation(.level1, prerender: false)
        }
        .padding(40)
        .fixedSize()
        .previewDisplayName("Live")
    }

    @ViewBuilder static var compositingGroup: some View {
        ZStack {
            squircle("Level 3")
                .elevation(.level3)
                .offset(x: -20, y: -20)
            squircle("Level 3")
                .elevation(.level3)
                .offset(x: 20, y: 20)
        }
        .padding(80)
        .background(Gradient.bundleTop.background.opacity(0.05))
        .environment(\.isElevationEnabled, false)
        .compositingGroup()
        .elevation(.level3)
        .previewDisplayName("With Compositing Group")

        ZStack {
            squircle("Level 3")
                .elevation(.level3)
                .offset(x: -20, y: -20)
            squircle("Level 3")
                .elevation(.level3)
                .offset(x: 20, y: 20)
        }
        .padding(80)
        .background(Gradient.bundleTop.background.opacity(0.05))
        .previewDisplayName("Without Compositing Group (Default)")
    }

    static func squircle(_ title: String) -> some View {
        Heading(title, style: .title1)
            .frame(width: 240, height: 260)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: BorderRadius.large))
    }
}
