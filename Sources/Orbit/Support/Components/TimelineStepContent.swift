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
        Badge(label, style: badgeStyle)
            .alignmentGuide(.timelineStepAlignment, computeValue: alignmentComputation)
        Text(sublabel, size: .small)
            .padding(.leading, sizeCategory.isAccessibilitySize ? .xSmall : 0)
    }

    var badgeStyle: Badge.Style {
        switch style {
            case .default:              return .neutral
            case .status(let status):   return .status(status, inverted: false)
        }
    }
}

public struct TimelineStepBottomText: View {
    let text: String
    let style: TimelineStepStyle

    public var body: some View {
        Text(text, size: .normal, color: .custom(style.textColor))
            .padding(.leading, .xSmall)
    }
}
