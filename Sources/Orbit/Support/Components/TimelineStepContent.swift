import SwiftUI

public struct TimelineStepBadgeText: View {

    @Environment(\.horizontalSizeClass) var horisontalSizeClass
    @Environment(\.sizeCategory) var sizeCategory

    let label: String
    let sublabel: String
    let style: TimelineStepStyle
    let alignmentComputation: (ViewDimensions) -> CGFloat
    
    public var body: some View {
        if horisontalSizeClass == .compact && sizeCategory.isAccessibilitySize {
            VStack(alignment: .leading, spacing: .xSmall) {
                content
            }
        } else {
            HStack(spacing: .xSmall) {
                content
            }
        }
    }

    @ViewBuilder var content: some View {
        Heading(label, style: .title5, color: .custom(Color(style.textColor)))
            .alignmentGuide(.timelineStepAlignment, computeValue: alignmentComputation)

        Text(sublabel, size: .small, color: .custom(style.textColor))
            .padding(.leading, sizeCategory.isAccessibilitySize ? .xSmall : 0)
    }
}

public struct TimelineStepBottomText: View {
    let text: String
    let style: TimelineStepStyle

    public var body: some View {
        Text(text, size: .normal, color: .custom(style.textColor))
    }
}
