import SwiftUI

public struct TimelineIndicator: View {

    public static let indicatorDiameter: CGFloat = Icon.Size.large.value

    @Environment(\.accessibilityReduceMotion) private var isReduceMotionEnabled
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.iconColor) private var iconColor

    private let type: TimelineItemType

    @State private var animationLoopTrigger = false

    public var body: some View {
        indicator
            .frame(
                width: TimelineIndicator.indicatorDiameter * sizeCategory.ratio,
                height: TimelineIndicator.indicatorDiameter * sizeCategory.ratio
            )
            .alignmentGuide(.firstTextBaseline) { $0.height * 0.7 }
            .onAppear { 
                guard isReduceMotionEnabled == false else { return }
                
                withAnimation(.easeInOut.repeatForever().speed(0.25)) {
                    animationLoopTrigger = true
                } 
            }
    }

    @ViewBuilder private var indicator: some View {
        switch type {
            case .future, .present(nil):
                icon
            case .present(.warning), .present(.critical), .present(.success):
                Circle()
                    .frame(
                        width: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio,
                        height: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio
                    )
                    .foregroundColor(animationLoopTrigger ? Color.clear : type.color.opacity(0.1))
                    .overlay(icon)
            case .past:
                Circle()
                    .foregroundColor(type.color.opacity(0.1))
                    .frame(width: .xMedium * sizeCategory.ratio, height: .xMedium * sizeCategory.ratio)
                    .overlay(icon)
        }
    }

    @ViewBuilder private var icon: some View {
        switch type {
            case .future:
                Circle()
                    .strokeBorder(iconColor ?? type.color, lineWidth: 2)
                    .background(Circle().fill(.whiteNormal))
                    .frame(width: .small * sizeCategory.ratio, height: .small * sizeCategory.ratio)
            case .present(nil):
                ZStack(alignment: .center) {
                    Circle()
                        .frame(
                            width: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio,
                            height: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio
                        )
                        .foregroundColor((iconColor ?? type.color).opacity(0.1))

                    Circle()
                        .strokeBorder(iconColor ?? type.color, lineWidth: 2)
                        .background(Circle().fill(.whiteNormal))
                        .frame(width: .small * sizeCategory.ratio, height: .small * sizeCategory.ratio)

                    Circle()
                        .frame(width: .xxSmall * sizeCategory.ratio, height: .xxSmall * sizeCategory.ratio)
                        .scaleEffect(animationLoopTrigger ? 0.5 : 1)
                        .foregroundColor(animationLoopTrigger ? Color.clear : iconColor ?? type.color)

                }
            case .present(.warning), .present(.critical), .present(.success), .past:
                Icon(type.icon)
                    .iconSize(.small)
                    .iconColor(iconColor ?? type.color)
                    .background(Circle().fill(.whiteNormal).padding(2))
        }
    }
    
    /// Creates Orbit ``TimelineIndicator`` component.
    public init(type: TimelineItemType = .present) {
        self.type = type
    }
}

// MARK: - Previews
struct TimelineIndicatorPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        HorizontalScroll {
            HStack(spacing: .xxSmall) {
                ForEach(1..<4) { index in
                    VStack(spacing: .medium) {
                        SwiftUI.Button {
                            // No Action
                        } label: {
                            VStack(spacing: .medium) {
                                TimelineIndicator(type: .future)
                                TimelineIndicator(type: .past)
                                TimelineIndicator(type: .present)
                                TimelineIndicator(type: .present(.critical))
                            }
                        }
                    }
                    
                    Separator()
                }
            }
            .padding(.medium)
        }
        .padding()
        .previewDisplayName()
    }
}
