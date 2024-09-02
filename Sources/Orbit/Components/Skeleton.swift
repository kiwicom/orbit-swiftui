import SwiftUI

/// Orbit component that displays placeholder before data is loaded.
/// A counterpart of the native `redacted()` modifier.
/// 
/// A ``Skeleton`` is defined by a shape that mimics the shape and size of loaded content.
///
/// ```swift
/// Skeleton(.button)
/// Skeleton(.image)
/// Skeleton(.atomic(.rectangle), animation: animation)
///     .frame(height: 60)
/// ```
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/progress-indicators/skeleton/)
public struct Skeleton: View {
    
    public static let color: Color = .cloudNormal
    public static let lightColor: Color = .cloudLight
    
    @State private var color: Color = Self.color
    
    private let preset: Preset
    private let borderRadius: CGFloat
    private let animation: Animation?
    
    public var body: some View {
        content
            .onAppear {
                // https://developer.apple.com/forums/thread/670836
                DispatchQueue.main.async {
                    withAnimation(animation?.value.repeatForever()) {
                        color = Self.lightColor
                    }
                }
            }
    }
    
    @ViewBuilder private var content: some View {
        switch preset {
            case .atomic(let atomic):
                switch atomic {
                    case .circle:       Circle().fill(color)
                    case .rectangle:    roundedRectangle.fill(color)
                }
            case .button(let size):
                switch size {
                    case .regular:      roundedRectangle.fill(color).frame(height: .xxLarge)
                    case .compact:      roundedRectangle.fill(color).frame(height: .xLarge)
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
    
    @ViewBuilder private func line(height: CGFloat) -> some View {
        roundedRectangle.fill(color).frame(height: height)
    }
    
    private var roundedRectangle: RoundedRectangle {
        RoundedRectangle(cornerRadius: borderRadius)
    }
    
    /// Creates Orbit ``Skeleton`` component.
    public init(
        _ preset: Preset,
        borderRadius: CGFloat = BorderRadius.desktop,
        animation: Animation? = .default
    ) {
        self.preset = preset
        self.borderRadius = borderRadius
        self.animation = animation
    }
}

// MARK: - Types
extension Skeleton {
    
    /// Orbit ``Skeleton`` shape and size preset.
    public enum Preset {
        
        public enum Atomic {
            case circle
            case rectangle
        }
        
        case atomic(Atomic)
        case button(_ size: ButtonSize = .regular)
        case card(height: CGFloat? = nil)
        case image(height: CGFloat? = nil)
        case list(rows: Int, rowHeight: CGFloat = 20, spacing: CGFloat = .xSmall)
        case text(lines: Int, lineHeight: CGFloat = 20, spacing: CGFloat = .xSmall)
        
        public static let button: Self = .button()
        public static let card: Self = .card()
        public static let image: Self = .image()
    }
    
    /// Orbit ``Skeleton`` animation.
    public enum Animation {
        case `default`
        case custom(SwiftUI.Animation)
        
        var value: SwiftUI.Animation {
            switch self {
                case .default:                  return .easeInOut(duration: 1.2)
                case .custom(let animation):    return animation
            }
        }
    }
}

// MARK: - Previews
struct SkeletonPreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            content(animation: nil)
            contentAtomic(animation: .none)
            Skeleton(.card, borderRadius: BorderRadius.large, animation: .none)
                .frame(height: 100)
            Skeleton(.image, borderRadius: BorderRadius.large, animation: .none)
                .frame(height: 100)
            livePreview
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
    
    static var snapshot: some View {
        content(animation: nil)
            .padding(.medium)
    }
    
    static func contentAtomic(animation: Skeleton.Animation? = .default) -> some View {
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
    
    static func content(animation: Skeleton.Animation? = .default) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            Skeleton(.list(rows: 3), animation: animation)
            Skeleton(.image(height: 150), animation: animation)
            Skeleton(.card(height: 200), animation: animation)
            Skeleton(.button, animation: animation)
            Skeleton(.text(lines: 4), animation: animation)
        }
    }
    
    static var livePreview: some View {
        VStack(spacing: .large) {
            Heading("Loading...", style: .title3)
            content()
        }
        .previewDisplayName()
    }
}
