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
                    ForEach(0 ..< lines, id: \.self) { _ in
                        roundedRectangle.fill(shapeStyle).frame(height: lineHeight)
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
            atomicCircle
            atomicRectangle
            atomicRectangleCustom
            button
            card
            image
            list
            text
            livePreview
        }
        .previewLayout(.sizeThatFits)
    }

    static var atomicCircle: some View {
        Skeleton(.atomic(.circle), animated: false)
            .frame(height: 60)
            .padding()
    }

    static var atomicRectangle: some View {
        Skeleton(.atomic(.rectangle), animated: false)
            .frame(height: 60)
            .padding()
    }

    static var atomicRectangleCustom: some View {
        Skeleton(.atomic(.rectangle), borderRadius: 20, animated: false)
            .frame(height: 60)
            .padding()
    }

    static var button: some View {
        Skeleton(.button(), animated: false)
            .padding()
    }

    static var card: some View {
        Skeleton(.card(), animated: false)
            .padding()
    }

    static var image: some View {
        Skeleton(.image(), animated: false)
            .padding()
    }

    static var list: some View {
        Skeleton(.list(rows: 5), animated: false)
            .padding()
    }

    static var text: some View {
        Skeleton(.text(lines: 5), animated: false)
            .padding()
    }

    static var livePreview: some View {
        VStack(spacing: .medium) {
            Heading("Loading...", style: .title3)
            Skeleton(.text(lines: 5))
            Skeleton(.image())
            Skeleton(.list(rows: 3))
            Skeleton(.button())
        }
        .padding()
    }
}
