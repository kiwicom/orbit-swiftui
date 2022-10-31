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
public struct TimelineStep<Header: View, Content: View, Footer: View>: View {

    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    let animationSpeed: CGFloat = 0.25

    let style: TimelineStepStyle
    let isIconFirstTextLineCentered: Bool
    @ViewBuilder let header: Header
    @ViewBuilder let content: Content
    @ViewBuilder let footer: Footer

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
                    isIconFirstTextLineCentered
                        ? $0.height / 2.0
                        : VerticalAlignment.TimelineStepAlignment.defaultValue(in: $0)
                }
            
            VStack(alignment: .leading, spacing: .xSmall) {
                header
                content
                footer
            }
        }
        .anchorPreference(key: TimelineStepPreferenceKey.self, value: .bounds) {
            [TimelineStepPreference(bounds: $0, style: style)]
        }
        .onAppear { animationLoopTrigger = !reduceMotion }
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

public extension TimelineStep where Header == TimelineStepHeadingText {

    /// Creates Orbit TimelineStep component with custom details.
    init(
        _ label: String,
        sublabel: String = "",
        style: TimelineStepStyle = .inactive,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {
        self.init(
            style: style,
            isIconFirstTextLineCentered: true,
            header: {
                TimelineStepHeadingText(
                    label: label,
                    sublabel: sublabel,
                    style: style,
                    alignmentComputation: VerticalAlignment.TimelineStepAlignment.computeFirstLineCenter(in:)
                )
            },
            content: content,
            footer: footer
        )
    }
}

public extension TimelineStep where Content == TimelineStepBottomText {

    /// Creates Orbit TimelineStep component with custom header and text details.
    /// - Parameters:
    ///   - isIconFirstTextLineCentered: center icon and first text line or align with the top
    init(
        style: TimelineStepStyle = .inactive,
        isIconFirstTextLineCentered: Bool,
        description: String,
        @ViewBuilder header: () -> Header,
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {
        self.init(style: style, isIconFirstTextLineCentered: isIconFirstTextLineCentered, header: header) {
            TimelineStepBottomText(text: description, style: style)
        } footer: {
            footer()
        }
    }
}

public extension TimelineStep where Header == TimelineStepHeadingText, Content == TimelineStepBottomText {

    /// Creates Orbit TimelineStep component with text details.
    init(
        _ label: String,
        sublabel: String = "",
        style: TimelineStepStyle = .inactive,
        description: String,
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {

        self.init(
            style: style,
            isIconFirstTextLineCentered: true,
            header: {
                TimelineStepHeadingText(
                    label: label,
                    sublabel: sublabel,
                    style: style,
                    alignmentComputation: VerticalAlignment.TimelineStepAlignment.computeFirstLineCenter(in:)
                )
            },
            content: { TimelineStepBottomText(text: description, style: style) },
            footer: { footer() }
        )
    }
}


public extension TimelineStep {
    /// Creates Orbit TimelineStep component with custom a header content and footer.
    /// - Parameters:
    ///   - isIconFirstTextLineCentered: center icon and first text line or align with the top
    init(
        style: TimelineStepStyle = .inactive,
        isIconFirstTextLineCentered: Bool,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {
        self.style = style
        self.isIconFirstTextLineCentered = isIconFirstTextLineCentered
        self.header = header()
        self.content = content()
        self.footer = footer()
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
                style: .currentWarning,
                isIconFirstTextLineCentered: true,
                header: {
                    VStack {
                        Text(
                            "1 Passenger must check in with the airline for a possible fee",
                            size: .xLarge,
                            color: .custom(TimelineStepStyle.pastWarning.textColor),
                            weight: .bold
                        )
                        .padding(.leading, .xSmall)
                        .alignmentGuide(
                            .timelineStepAlignment,
                            computeValue: VerticalAlignment.TimelineStepAlignment.computeFirstLineCenter(in:)
                        )
                    }
                },
                content: {
                    VStack(alignment: .leading) {
                        TimelineStepBottomText(
                            text: "We’ve assigned your request to one of our agents.",
                            style: .inactive
                        )
                        Button("Check in")
                            .padding(.leading, .xSmall)
                    }
                }
            )
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
                style: .inactive
            ) {
                VStack(alignment: .leading) {
                    TimelineStepBottomText(
                        text: "We’ve assigned your request to one of our agents.",
                        style: .inactive
                    )

                    Button("Add info")
                        .padding(.leading, .xSmall)
                }
            }
            TimelineStep(
                style: .currentWarning,
                isIconFirstTextLineCentered: true,
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
                    .alignmentGuide(
                        .timelineStepAlignment,
                        computeValue: VerticalAlignment.TimelineStepAlignment.computeFirstLineCenter(in:)
                    )
                }
            }
            TimelineStep(
                style: .currentWarning,
                isIconFirstTextLineCentered: true,
                description: "We’ve assigned your request to one of our agents."
            ) {
                Circle()
                    .fill(.red)
                    .frame(width: 50, height: 50)
                    .alignmentGuide(
                        .timelineStepAlignment,
                        computeValue: VerticalAlignment.TimelineStepAlignment.computeFirstLineCenter(in:)
                    )
            }
        }
        .padding()
        .previewDisplayName("Custom Header and Content")
    }
}
