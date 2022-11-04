import SwiftUI

public extension VerticalAlignment {

    enum TimelineItemAlignment : AlignmentID {
        public static func defaultValue(in dimensions: ViewDimensions) -> CGFloat {
            return dimensions[VerticalAlignment.top]
        }

        public static func computeFirstLineCenter(in dimensions: ViewDimensions) -> CGFloat {
            (dimensions.height - (dimensions[.lastTextBaseline] - dimensions[.firstTextBaseline])) / 2
        }
    }

    static let timelineItemAlignment = VerticalAlignment(TimelineItemAlignment.self)
}

/// One item of a Timeline.
///
/// - Related components
///   - ``Timeline``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/progress-indicators/timeline/)
public struct TimelineItem<Footer: View>: View {

    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.horizontalSizeClass) var horisontalSizeClass
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    let label: String
    let sublabel: String
    let description: String
    let style: TimelineItemStyle
    @ViewBuilder let footer: Footer

    var hasHeaderContent: Bool {
        label.isEmpty == false || sublabel.isEmpty == false
    }

    var hasDescription: Bool {
        description.isEmpty == false
    }

    var animation: Animation {
        Animation.easeInOut.repeatForever().speed(0.25)
    }

    @State var animationLoopTrigger = false

    public var body: some View {
        HStack(alignment: .timelineItemAlignment, spacing: .small) {
            Color.clear
                .frame(
                    width: TimelineItemStyle.indicatorDiameter * sizeCategory.ratio,
                    height: TimelineItemStyle.indicatorDiameter * sizeCategory.ratio
                )
                .overlay(indicator)
                .alignmentGuide(.timelineItemAlignment) {
                    if label.isEmpty == false || sublabel.isEmpty == false || description.isEmpty == false {
                        return $0.height / 2.0
                    } else {
                        return 0
                    }
                }
            
            VStack(alignment: .leading, spacing: .xSmall) {
                if hasHeaderContent {
                    headerWithAccessibilitySizeSupport
                        .alignmentGuide(
                            .timelineItemAlignment,
                            computeValue: VerticalAlignment.TimelineItemAlignment.computeFirstLineCenter(in:)
                        )
                }

                if hasDescription, !hasHeaderContent {
                    descriptionText
                        .alignmentGuide(
                            .timelineItemAlignment,
                            computeValue: VerticalAlignment.TimelineItemAlignment.computeFirstLineCenter(in:)
                        )
                } else {
                    descriptionText
                }

                footer
            }
        }
        .anchorPreference(key: TimelineItemPreferenceKey.self, value: .bounds) {
            [TimelineItemPreference(bounds: $0, style: style)]
        }
        .onAppear { animationLoopTrigger = !reduceMotion }
    }

    @ViewBuilder var headerWithAccessibilitySizeSupport: some View {
        if horisontalSizeClass == .compact && sizeCategory.isAccessibilitySize {
            VStack(alignment: .leading, spacing: .xSmall) {
                header
            }
        } else {
            HStack(spacing: .xSmall) {
                header
            }
        }
    }

    @ViewBuilder var header: some View {
        Heading(label, style: .title5, color: .custom(style.textColor))

        Text(sublabel, size: .small, color: .custom(style.textColor))
            .padding(.leading, sizeCategory.isAccessibilitySize ? .xSmall : 0)
    }

    @ViewBuilder var descriptionText: some View {
        Text(description, size: .normal, color: .custom(style.textColor))
    }

    @ViewBuilder var indicator: some View {
        switch style {
            case .future, .current(.info):
                icon
            case .current(.warning), .current(.critical), .current(.success):
                Circle()
                    .frame(
                        width: (.xMedium) * sizeCategory.ratio,
                        height: (.xMedium) * sizeCategory.ratio
                    )
                    .foregroundColor(animationLoopTrigger ? Color.clear : style.color.opacity(0.1))
                    .animation(animation, value: animationLoopTrigger)
                    .overlay(icon)
            case .past:
                Circle()
                    .foregroundColor(style.color.opacity(0.1))
                    .frame(width: .xMedium * sizeCategory.ratio, height: .xMedium * sizeCategory.ratio)
                    .overlay(icon)
            }
    }

    @ViewBuilder var icon: some View {
        switch style {
            case .future:
                Circle()
                    .strokeBorder(style.color, lineWidth: 2)
                    .background(Circle().fill(Color.whiteNormal))
                    .frame(width: .small * sizeCategory.ratio, height: .small * sizeCategory.ratio)
            case .current(.info):
                ZStack(alignment: .center) {
                    Circle()
                        .frame(
                            width: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio,
                            height: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio
                        )
                        .animation(animation, value: animationLoopTrigger)
                        .foregroundColor(style.color.opacity(0.1))

                    Circle()
                        .strokeBorder(style.color, lineWidth: 2)
                        .background(Circle().fill(Color.whiteNormal))
                        .frame(width: .small * sizeCategory.ratio, height: .small * sizeCategory.ratio)

                    Circle()
                        .frame(width: .xxSmall * sizeCategory.ratio, height: .xxSmall * sizeCategory.ratio)
                        .scaleEffect(animationLoopTrigger ? .init(width: 0.5, height: 0.5) : .init(width: 1, height: 1))
                        .foregroundColor(animationLoopTrigger ? Color.clear : style.color)
                        .animation(animation, value: animationLoopTrigger)

                }
        case .current(.warning), .current(.critical), .current(.success), .past:
                Icon(style.iconSymbol, size: .small, color: style.color)
                    .background(Circle().fill(Color.whiteNormal).padding(2))
        }
    }
}

// MARK: - Inits

public extension TimelineItem {

    /// Creates Orbit TimelineItem component with text details.
    init(
        _ label: String = "",
        sublabel: String = "",
        style: TimelineItemStyle = .future,
        description: String = "",
        @ViewBuilder footer: () -> Footer
    ) {

        self.label = label
        self.sublabel = sublabel
        self.style = style
        self.description = description
        self.footer = footer()
    }
}

public extension TimelineItem where Footer == EmptyView {

    /// Creates Orbit TimelineItem component with text details.
    init(
        _ label: String,
        sublabel: String = "",
        style: TimelineItemStyle = .future,
        description: String = ""
    ) {
        self.init(label, sublabel: sublabel, style: style, description: description, footer: { EmptyView() })
    }
}

// MARK: - Types

public enum TimelineItemStyle: Equatable {
    case past
    case current(Status)
    case future

    public static let indicatorDiameter: CGFloat = Icon.Size.large.value

    public var iconSymbol: Icon.Symbol {
        switch self {
            case .past:                  return .checkCircle
            case .current(.critical):    return .closeCircle
            case .current(.warning):     return .alertCircle
            case .current(.success):     return .checkCircle
            case .current(.info):        return .none
            case .future:                return .none
        }
    }

    public var color: Color {
        switch self {
            case .past:                  return Status.success.color
            case .current(.critical):    return Status.critical.color
            case .current(.warning):     return Status.warning.color
            case .current(.success):     return Status.success.color
            case .current(.info):        return Status.success.color
            case .future:                return .cloudNormalHover
        }
    }

    public var isCurrentStep: Bool {
        switch self {
            case .current:
                return true
            case .past, .future:
                return false
        }
    }

    public var textColor: UIColor {
        isCurrentStep ? .inkDark : .inkLight
    }

    public var isLineDashed: Bool {
        switch self {
            case .future:
                return true
            case .past, .current:
                return false
        }
    }
}

public struct TimelineItemPreferenceKey: SwiftUI.PreferenceKey {

    public typealias Value = [TimelineItemPreference]

    public static var defaultValue: Value = []

    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

public struct TimelineItemPreference {

    let bounds: Anchor<CGRect>
    let style: TimelineItemStyle

    public init(bounds: Anchor<CGRect>, style: TimelineItemStyle) {
        self.bounds = bounds
        self.style = style
    }
}

// MARK: - Previews
struct TimelineItemPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshots
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        TimelineItem(
            "Requested",
            sublabel: "3rd May 14:04",
            style: .past,
            description: "We’ve assigned your request to one of our agents."
        )
        .padding()
    }

    static var snapshots: some View {
        VStack(alignment: .leading) {
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .future,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .current(.info),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .current(.warning),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .current(.critical),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .past,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "",
                style: .current(.warning)
            ) {
                VStack {
                    Text(
                        "1 Passenger must check in with the airline for a possible fee",
                        size: .xLarge,
                        color: .custom(TimelineItemStyle.past.textColor),
                        weight: .bold
                    )
                }

                Button("Check in")
            }
        }
        .padding()
        .previewDisplayName("Snapshots")
    }
}

struct TimelineItemCustomContentPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            customContent
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var customContent: some View {
        VStack(alignment: .leading) {
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .future,
                description: "We’ve assigned your request to one of our agents."
            ) {
                Button("Add info")
            }

            TimelineItem(
                style: .current(.warning),
                description: "We’ve assigned your request to one of our agents."
            ) {

                VStack {
                    Text(
                        "1 Passenger must check in with the airline for a possible fee",
                        size: .custom(50),
                        color: .custom(TimelineItemStyle.current(.warning).textColor),
                        weight: .bold
                    )
                    .padding(.leading, .xSmall)
                }
            }
            TimelineItem(
                style: .current(.warning),
                description: "We’ve assigned your request to one of our agents."
            ) {
                Circle()
                    .fill(.red)
                    .frame(width: 50, height: 50)
            }

            TimelineItem(
                style: .current(.warning)
            ) {
                Circle()
                    .fill(.red)
                    .frame(width: 50, height: 50)
            }
        }
        .padding()
        .previewDisplayName("Custom Header and Content")
    }
}
