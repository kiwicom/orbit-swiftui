import SwiftUI

public extension VerticalAlignment {

    enum TimelineStepAlignment : AlignmentID {
        public static func defaultValue(in dimensions: ViewDimensions) -> CGFloat {
            return dimensions[VerticalAlignment.top]
        }

        public static func computeFirstLineCenter(in dimensions: ViewDimensions) -> CGFloat {
            (dimensions.height - (dimensions[.lastTextBaseline] - dimensions[.firstTextBaseline])) / 2
        }
    }

    static let timelineStepAlignment = VerticalAlignment(TimelineStepAlignment.self)
}

/// One item of a Timeline.
///
/// - Related components
///   - ``Timeline``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/progress-indicators/timeline/)
public struct TimelineStep<Footer: View>: View {

    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.horizontalSizeClass) var horisontalSizeClass
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    let animationSpeed: CGFloat = 0.25

    let label: String
    let sublabel: String
    let description: String
    let style: TimelineStepStyle
    @ViewBuilder let footer: Footer

    var hasHeaderContent: Bool {
        label.isEmpty == false || sublabel.isEmpty == false
    }

    var hasDescription: Bool {
        description.isEmpty == false
    }

    @State var animationLoopTrigger = false

    public var body: some View {
        HStack(alignment: .timelineStepAlignment, spacing: .small) {
            Color.clear
                .frame(
                    width: TimelineStepStyle.indicatorDiameter * sizeCategory.ratio,
                    height: TimelineStepStyle.indicatorDiameter * sizeCategory.ratio
                )
                .overlay(indicator)
                .alignmentGuide(.timelineStepAlignment) {
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
                            .timelineStepAlignment,
                            computeValue: VerticalAlignment.TimelineStepAlignment.computeFirstLineCenter(in:)
                        )
                }

                if hasDescription, !hasHeaderContent {
                    descriptionText
                        .alignmentGuide(
                            .timelineStepAlignment,
                            computeValue: VerticalAlignment.TimelineStepAlignment.computeFirstLineCenter(in:)
                        )
                } else {
                    descriptionText
                }

                footer
            }
        }
        .anchorPreference(key: TimelineStepPreferenceKey.self, value: .bounds) {
            [TimelineStepPreference(bounds: $0, style: style)]
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
        Heading(label, style: .title5, color: .custom(Color(style.textColor)))

        Text(sublabel, size: .small, color: .custom(style.textColor))
            .padding(.leading, sizeCategory.isAccessibilitySize ? .xSmall : 0)
    }

    @ViewBuilder var descriptionText: some View {
        Text(description, size: .normal, color: .custom(style.textColor))
    }

    @ViewBuilder var indicator: some View {
        switch style {
            case .inactive, .currentNormal:
                icon
            case .currentWarning, .currentCritical:
                Circle()
                    .frame(
                        width: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio,
                        height: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio
                    )
                    .foregroundColor(animationLoopTrigger ? Color.clear : style.color.opacity(0.1))
                    .animation(Animation.easeInOut.repeatForever().speed(animationSpeed))
                    .overlay(icon)
            case .pastSuccess, .pastWarning, .pastCritical:
                Circle()
                    .foregroundColor(style.color.opacity(0.1))
                    .frame(width: .xMedium * sizeCategory.ratio, height: .xMedium * sizeCategory.ratio)
                    .overlay(icon)
            }
    }

    @ViewBuilder var icon: some View {
        switch style {
            case .inactive:
                Circle()
                    .strokeBorder(style.color, lineWidth: 2)
                    .background(Circle().fill(Color.whiteNormal))
                    .frame(width: .small * sizeCategory.ratio, height: .small * sizeCategory.ratio)
            case .currentNormal:
                ZStack {
                    Circle()
                        .frame(
                            width: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio,
                            height: (animationLoopTrigger ? .medium : .xMedium) * sizeCategory.ratio
                        )
                        .animation(Animation.easeInOut.repeatForever().speed(animationSpeed))
                        .foregroundColor(style.color.opacity(0.1))

                    Circle()
                        .strokeBorder(style.color, lineWidth: 2)
                        .background(Circle().fill(Color.whiteNormal))
                        .frame(width: .small * sizeCategory.ratio, height: .small * sizeCategory.ratio)

                    Circle()
                        .frame(width: .xxSmall * sizeCategory.ratio, height: .xxSmall * sizeCategory.ratio)
                        .scaleEffect(animationLoopTrigger ? .init(width: 0.5, height: 0.5) : .init(width: 1, height: 1))
                        .foregroundColor(animationLoopTrigger ? Color.clear : style.color)
                        .animation(Animation.easeInOut.repeatForever().speed(animationSpeed))

                }
            case .currentWarning, .currentCritical, .pastSuccess, .pastWarning, .pastCritical:
                Icon(style.iconSymbol, size: .small, color: style.color)
                    .background(Circle().fill(Color.whiteNormal).padding(2))
        }
    }
}

// MARK: - Inits

public extension TimelineStep {

    /// Creates Orbit TimelineStep component with text details.
    init(
        _ label: String = "",
        sublabel: String = "",
        style: TimelineStepStyle = .inactive,
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

public extension TimelineStep where Footer == EmptyView {

    /// Creates Orbit TimelineStep component with text details.
    init(
        _ label: String,
        sublabel: String = "",
        style: TimelineStepStyle = .inactive,
        description: String = ""
    ) {

        self.label = label
        self.sublabel = sublabel
        self.style = style
        self.description = description
        self.footer = EmptyView()
    }
}

// MARK: - Types

public enum TimelineStepStyle: Equatable {
    case inactive
    case currentNormal
    case currentWarning
    case currentCritical
    case pastSuccess
    case pastWarning
    case pastCritical

    public static let indicatorDiameter: CGFloat = Icon.Size.large.value

    public var iconSymbol: Icon.Symbol {
        switch self {
            case .inactive:           return .none
            case .currentNormal:      return .none
            case .currentWarning:     return .alertCircle
            case .currentCritical:    return .closeCircle
            case .pastSuccess:        return .checkCircle
            case .pastWarning:        return .alertCircle
            case .pastCritical:       return .closeCircle
        }
    }

    public var color: Color {
        switch self {
            case .inactive:           return .cloudNormalHover
            case .currentNormal:      return Status.success.color
            case .currentWarning:     return Status.warning.color
            case .currentCritical:    return Status.critical.color
            case .pastSuccess:        return Status.success.color
            case .pastWarning:        return Status.warning.color
            case .pastCritical:       return Status.critical.color
        }
    }

    public var isCurrentStep: Bool {
        switch self {
            case .currentNormal, .currentWarning, .currentCritical:
                return true
            case .inactive, .pastSuccess, .pastWarning, .pastCritical:
                return false
        }
    }

    public var textColor: UIColor {
        isCurrentStep ? .inkDark : .inkLight
    }

    public var isLineDashed: Bool {
        switch self {
            case .inactive:
                return true
            case .currentNormal, .currentWarning, .currentCritical, .pastSuccess, .pastWarning, .pastCritical:
                return false
        }
    }
}

public struct TimelineStepPreferenceKey: SwiftUI.PreferenceKey {

    public typealias Value = [TimelineStepPreference]

    public static var defaultValue: Value = []

    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

public struct TimelineStepPreference {

    let bounds: Anchor<CGRect>
    let style: TimelineStepStyle

    public init(bounds: Anchor<CGRect>, style: TimelineStepStyle) {
        self.bounds = bounds
        self.style = style
    }
}

// MARK: - Previews
struct TimelineStepPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshots
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        TimelineStep(
            "Requested",
            sublabel: "3rd May 14:04",
            style: .pastSuccess,
            description: "We’ve assigned your request to one of our agents."
        )
        .padding()
    }

    static var snapshots: some View {
        VStack(alignment: .leading) {
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .inactive,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .currentNormal,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .currentWarning,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .currentCritical,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .pastCritical,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineStep(
                "",
                style: .currentWarning
            ) {
                VStack {
                    Text(
                        "1 Passenger must check in with the airline for a possible fee",
                        size: .xLarge,
                        color: .custom(TimelineStepStyle.pastWarning.textColor),
                        weight: .bold
                    )
                    .alignmentGuide(
                        .timelineStepAlignment,
                        computeValue: VerticalAlignment.TimelineStepAlignment.computeFirstLineCenter(in:)
                    )
                }

                TimelineStepBottomText(
                    text: "We’ve assigned your request to one of our agents.",
                    style: .inactive
                )

                Button("Check in")
                    .padding(.leading, .xSmall)
            }
        }
        .padding()
        .previewDisplayName("Snapshots")
    }
}

struct TimelineStepDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standaloneSmall
            standaloneLarge
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var standaloneSmall: some View {
        TimelineStepPreviews.standalone
            .environment(\.sizeCategory, .extraSmall)
            .previewDisplayName("Dynamic type — extraSmall")
    }

    @ViewBuilder static var standaloneLarge: some View {
        TimelineStepPreviews.standalone
            .environment(\.sizeCategory, .accessibilityExtraLarge)
            .previewDisplayName("Dynamic type — extra large")
            .previewLayout(.sizeThatFits)
    }
}

struct TimelineStepCustomContentPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            customContent
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var customContent: some View {
        VStack(alignment: .leading) {
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .inactive,
                description: "We’ve assigned your request to one of our agents."
            ) {
                Button("Add info")
            }

            TimelineStep(
                style: .currentWarning,
                description: "We’ve assigned your request to one of our agents."
            ) {

                VStack {
                    Text(
                        "1 Passenger must check in with the airline for a possible fee",
                        size: .custom(50),
                        color: .custom(TimelineStepStyle.currentWarning.textColor),
                        weight: .bold
                    )
                    .padding(.leading, .xSmall)
                }
            }
            TimelineStep(
                style: .currentWarning,
                description: "We’ve assigned your request to one of our agents."
            ) {
                Circle()
                    .fill(.red)
                    .frame(width: 50, height: 50)
            }

            TimelineStep(
                style: .currentWarning
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
