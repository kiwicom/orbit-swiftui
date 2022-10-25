import SwiftUI

/// Shows content placeholder before data is loaded.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/progress-indicators/skeleton/)
public struct Skeleton: View {

    public static let color: Color = .cloudNormal
    public static let lightColor: Color = .cloudLight

    @State var color: Color = Self.color

    let preset: Preset
    let borderRadius: CGFloat
    let animation: Animation

    public var body: some View {
        content
            .onAppear {
                // https://developer.apple.com/forums/thread/670836
                DispatchQueue.main.async {
                    withAnimation(animation.value?.repeatForever()) {
                        color = Self.lightColor
                    }
                }
            }
    }

    @ViewBuilder var content: some View {
        switch preset {
            case .atomic(let atomic):
                switch atomic {
                    case .circle:       Circle().fill(color)
                    case .rectangle:    roundedRectangle.fill(color)
                }
            case .button(let size):
                switch size {
                    case .default:      roundedRectangle.fill(color).frame(height: .xxLarge)
                    case .small:        roundedRectangle.fill(color).frame(height: .xLarge)
                }
            case .card(let height), .image(let height):
                roundedRectangle.fill(color).frame(height: height)
            case .list(let rows, let rowHeight, let spacing):
                VStack(spacing: spacing) {
                    ForEach(0 ..< rows, id: \.self) { _ in
                        HStack(spacing: spacing) {
                            roundedRectangle.fill(color).frame(width: rowHeight, height: rowHeight)
                            roundedRectangle.fill(color).frame(height: rowHeight)
                        }
                    }
                }
            case .text(let lines, let lineHeight, let spacing):
                VStack(spacing: spacing) {
                    ForEach(0 ..< lines, id: \.self) { index in
                        if index == lines - 1 {
                            Color.clear.frame(height: lineHeight)
                                .overlay(
                                    GeometryReader { geometry in
                                        line(height: lineHeight)
                                            .frame(width: geometry.size.width * 0.7)
                                    }
                                )
                        } else {
                            line(height: lineHeight)
                        }
                    }
                }
        }
    }

    var roundedRectangle: RoundedRectangle {
        RoundedRectangle(cornerRadius: borderRadius)
    }

    @ViewBuilder func line(height: CGFloat) -> some View {
        roundedRectangle.fill(color).frame(height: height)
    }
}

// MARK: - Types
extension Skeleton {
    
    public enum Preset {

        public enum Atomic {
            case circle
            case rectangle
        }

        case atomic(Atomic)
        case button(_ size: Button.Size = .default)
        case card(height: CGFloat? = nil)
        case image(height: CGFloat? = nil)
        case list(rows: Int, rowHeight: CGFloat = 20, spacing: CGFloat = .xSmall)
        case text(lines: Int, lineHeight: CGFloat = 20, spacing: CGFloat = .xSmall)
    }

    public enum Animation {
        case none
        case `default`
        case custom(SwiftUI.Animation)

        var value: SwiftUI.Animation? {
            switch self {
                case .none:                     return nil
                case .default:                  return .easeInOut(duration: 1.2)
                case .custom(let animation):    return animation
            }
        }
    }
}

// MARK: - Inits
public extension Skeleton {
 
    /// Creates Orbit Skeleton component.
    init(
        _ preset: Preset,
        borderRadius: CGFloat = BorderRadius.desktop,
        animation: Animation = .default
    ) {
        self.preset = preset
        self.borderRadius = borderRadius
        self.animation = animation
    }
}

// MARK: - Previews
struct SkeletonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content(animation: .none)
            contentAtomic(animation: .none)
            Skeleton(.card(), borderRadius: BorderRadius.large, animation: .none)
                .frame(height: 100)
            Skeleton(.image(), borderRadius: BorderRadius.large, animation: .none)
                .frame(height: 100)
            livePreview
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var storybook: some View {
        content()
    }

    static var storybookAtomic: some View {
        contentAtomic()
    }

    static var snapshot: some View {
        content(animation: .none)
            .padding(.medium)
    }

    static func contentAtomic(animation: Skeleton.Animation = .default) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            Skeleton(.atomic(.circle), animation: animation)
                .frame(height: 60)
            Skeleton(.atomic(.rectangle), animation: animation)
                .frame(height: 60)
            Skeleton(.atomic(.rectangle), borderRadius: 20, animation: animation)
                .frame(height: 60)
        }
        .previewDisplayName("Atomic")
    }

    static func content(animation: Skeleton.Animation = .default) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            Skeleton(.list(rows: 3), animation: animation)
            Skeleton(.image(height: 150), animation: animation)
            Skeleton(.card(height: 200), animation: animation)
            Skeleton(.button(), animation: animation)
            Skeleton(.text(lines: 4), animation: animation)
        }
    }

    static var livePreview: some View {
        VStack(spacing: .large) {
            Heading("Loading...", style: .title3)
            content()
        }
    }
}
