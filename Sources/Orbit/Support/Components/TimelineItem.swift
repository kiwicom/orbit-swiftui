import SwiftUI

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
    let type: TimelineItemType
    @ViewBuilder let footer: Footer

    @State var animationLoopTrigger = false

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {

            indicator
                .frame(
                    width: TimelineItemType.indicatorDiameter * sizeCategory.ratio,
                    height: TimelineItemType.indicatorDiameter * sizeCategory.ratio
                )
                .alignmentGuide(.firstTextBaseline){ dimensions in
                    iconContentBaselineOffset(height: dimensions.height)
                }
            
            VStack(alignment: .leading, spacing: .xSmall) {
                if hasHeaderContent {
                    headerWithAccessibilitySizeSupport
                }

                if hasDescription, !hasHeaderContent {
                    descriptionText
                } else {
                    descriptionText
                }

                footer
            }
        }
        .anchorPreference(key: TimelineItemPreferenceKey.self, value: .bounds) {
            [TimelineItemPreference(bounds: $0, type: type)]
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
        Heading(label, style: .title5, color: .custom(type.textColor))

        Text(sublabel, size: .small, color: .custom(type.textColor))
            .padding(.leading, sizeCategory.isAccessibilitySize ? .xSmall : 0)
    }

    @ViewBuilder var descriptionText: some View {
        Text(description, size: .normal, color: .custom(type.textColor))
    }

    @ViewBuilder var indicator: some View {
        switch type {
            case .future, .current(.info):
                icon
            case .current(.warning), .current(.critical), .current(.success):
                Circle()
                    .frame(
                        width: (.xMedium) * sizeCategory.ratio,
                        height: (.xMedium) * sizeCategory.ratio
                    )
                    .foregroundColor(animationLoopTrigger ? Color.clear : type.color.opacity(0.1))
                    .animation(animation, value: animationLoopTrigger)
                    .overlay(icon)
            case .past:
                Circle()
                    .foregroundColor(type.color.opacity(0.1))
                    .frame(width: .xMedium * sizeCategory.ratio, height: .xMedium * sizeCategory.ratio)
                    .overlay(icon)
            }
    }

    @ViewBuilder var icon: some View {
        switch type {
            case .future:
                Circle()
                    .strokeBorder(type.color, lineWidth: 2)
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
                        .foregroundColor(type.color.opacity(0.1))

                    Circle()
                        .strokeBorder(type.color, lineWidth: 2)
                        .background(Circle().fill(Color.whiteNormal))
                        .frame(width: .small * sizeCategory.ratio, height: .small * sizeCategory.ratio)

                    Circle()
                        .frame(width: .xxSmall * sizeCategory.ratio, height: .xxSmall * sizeCategory.ratio)
                        .scaleEffect(animationLoopTrigger ? .init(width: 0.5, height: 0.5) : .init(width: 1, height: 1))
                        .foregroundColor(animationLoopTrigger ? Color.clear : type.color)
                        .animation(animation, value: animationLoopTrigger)

                }
        case .current(.warning), .current(.critical), .current(.success), .past:
                Icon(type.iconSymbol, size: .small, color: type.color)
                    .background(Circle().fill(Color.whiteNormal).padding(2))
        }
    }

    var hasHeaderContent: Bool {
        label.isEmpty == false || sublabel.isEmpty == false
    }

    var hasDescription: Bool {
        description.isEmpty == false
    }

    var animation: Animation {
        Animation.easeInOut.repeatForever().speed(0.25)
    }

    func iconContentBaselineOffset(height: CGFloat) -> CGFloat {
        Icon.Size.small.textBaselineAlignmentGuide(sizeCategory: sizeCategory, height: height)
    }
}

// MARK: - Inits

public extension TimelineItem {

    /// Creates Orbit TimelineItem component with text details.
    init(
        _ label: String = "",
        sublabel: String = "",
        type: TimelineItemType = .future,
        description: String = "",
        @ViewBuilder footer: () -> Footer
    ) {

        self.label = label
        self.sublabel = sublabel
        self.type = type
        self.description = description
        self.footer = footer()
    }
}

public extension TimelineItem where Footer == EmptyView {

    /// Creates Orbit TimelineItem component with text details.
    init(
        _ label: String,
        sublabel: String = "",
        type: TimelineItemType = .future,
        description: String = ""
    ) {
        self.init(label, sublabel: sublabel, type: type, description: description, footer: { EmptyView() })
    }
}

// MARK: - Types

public enum TimelineItemType: Equatable {
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

struct TimelineItemPreferenceKey: SwiftUI.PreferenceKey {

    typealias Value = [TimelineItemPreference]

    static var defaultValue: Value = []

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

struct TimelineItemPreference {

    let bounds: Anchor<CGRect>
    let type: TimelineItemType
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
            type: .past,
            description: "We’ve assigned your request to one of our agents."
        )
        .padding()
    }

    static var snapshots: some View {
        VStack(alignment: .leading) {
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .future,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .current(.info),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .current(.warning),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .current(.critical),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .past,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "",
                type: .current(.warning)
            ) {
                VStack {
                    Text(
                        "1 Passenger must check in with the airline for a possible fee",
                        size: .xLarge,
                        color: .custom(TimelineItemType.past.textColor),
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
                type: .future,
                description: "We’ve assigned your request to one of our agents."
            ) {
                Button("Add info")
            }

            TimelineItem(
                type: .current(.warning),
                description: "We’ve assigned your request to one of our agents."
            ) {

                VStack {
                    Text(
                        "1 Passenger must check in with the airline for a possible fee",
                        size: .custom(50),
                        color: .custom(TimelineItemType.current(.warning).textColor),
                        weight: .bold
                    )
                    .padding(.leading, .xSmall)
                }
            }
            TimelineItem(
                type: .current(.warning),
                description: "We’ve assigned your request to one of our agents."
            ) {
                Circle()
                    .fill(.red)
                    .frame(width: 50, height: 50)
            }

            TimelineItem(
                type: .current(.warning)
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
