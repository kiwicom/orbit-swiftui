import SwiftUI

/// Shows content placeholder before data is loaded.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/progress-indicators/skeleton/)
public struct Skeleton: View {

    public static let color: Color = .cloudDark
    public static let lightColor: Color = .cloudLight

    @State var color: Color = Self.color

    let preset: Preset
    let borderRadius: CGFloat
    let animated: Bool

    public var body: some View {
        content
            .onAppear {
                guard animated else { return }

                withAnimation(.easeInOut(duration: 1.2).repeatForever()) {
                    color = Self.lightColor
                }
            }
    }

    @ViewBuilder var content: some View {
        switch preset {
            case .atomic(let atomic):
                switch atomic {
                    case .circle:       Circle().fill(shapeStyle)
                    case .rectangle:    roundedRectangle.fill(shapeStyle)
                }
            case .button(let size):
                switch size {
                    case .default:      roundedRectangle.fill(shapeStyle).frame(height: Layout.preferredButtonHeight)
                    case .small:        roundedRectangle.fill(shapeStyle).frame(height: Layout.preferredSmallButtonHeight)
                }
            case .card(let height), .image(let height):
                roundedRectangle.fill(shapeStyle).frame(height: height)
            case .list(let rows, let rowHeight, let spacing):
                VStack(spacing: spacing) {
                    ForEach(0 ..< rows, id: \.self) { _ in
                        HStack(spacing: spacing) {
                            roundedRectangle.fill(shapeStyle).frame(width: rowHeight, height: rowHeight)
                            roundedRectangle.fill(shapeStyle).frame(height: rowHeight)
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

    var shapeStyle: some ShapeStyle {
        color
    }

    var roundedRectangle: RoundedRectangle {
        RoundedRectangle(cornerRadius: borderRadius)
    }

    @ViewBuilder func line(height: CGFloat) -> some View {
        roundedRectangle.fill(shapeStyle).frame(height: height)
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
        case card(height: CGFloat = 200)
        case image(height: CGFloat = 150)
        case list(rows: Int, rowHeight: CGFloat = 20, spacing: CGFloat = .xSmall)
        case text(lines: Int, lineHeight: CGFloat = 20, spacing: CGFloat = .xSmall)
    }
}

// MARK: - Inits
public extension Skeleton {
 
    /// Creates Orbit Skeleton component.
    init(
        _ preset: Preset,
        borderRadius: CGFloat = BorderRadius.desktop,
        animated: Bool = true
    ) {
        self.preset = preset
        self.borderRadius = borderRadius
        self.animated = animated
    }
}

// MARK: - Previews
struct SkeletonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content(animated: false)
            contentAtomic(animated: false)
            livePreview
        }
        .previewLayout(.sizeThatFits)
    }

    static var storybook: some View {
        content(animated: true)
    }

    static var storybookAtomic: some View {
        contentAtomic(animated: true)
    }

    static func contentAtomic(animated: Bool) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            Skeleton(.atomic(.circle), animated: animated)
                .frame(height: 60)
            Skeleton(.atomic(.rectangle), animated: animated)
                .frame(height: 60)
            Skeleton(.atomic(.rectangle), borderRadius: 20, animated: animated)
                .frame(height: 60)
        }
        .padding(.medium)
        .previewDisplayName("Atomic")
    }

    static func content(animated: Bool) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            Skeleton(.list(rows: 3), animated: animated)
            Skeleton(.image(), animated: animated)
            Skeleton(.card(), animated: animated)
            Skeleton(.button(), animated: animated)
            Skeleton(.text(lines: 4), animated: animated)
        }
        .padding(.medium)
    }

    static var livePreview: some View {
        VStack(spacing: .large) {
            Heading("Loading...", style: .title3)
            content(animated: true)
        }
        .padding()
    }
}
