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
public struct TimelineStep<Header: View, Content: View>: View {

    @Environment(\.sizeCategory) var sizeCategory

    let style: TimelineStepStyle
    let isIconFirstTextLineCentered: Bool
    @ViewBuilder let header: Header
    @ViewBuilder let content: Content

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
            }
        }
        .anchorPreference(key: TimelineStepPreferenceKey.self, value: .bounds) {
            [TimelineStepPreference(bounds: $0, style: style)]
        }
    }

    @ViewBuilder var indicator: some View {
        icon
    }

    @ViewBuilder var icon: some View {
        switch style {
            case .default:
                Circle()
                    .strokeBorder(Color.cloudNormalHover, lineWidth: 2)
                    .frame(width: .small * sizeCategory.ratio, height: .small * sizeCategory.ratio)
                    .background(
                        Circle()
                            .fill(Color.whiteNormal)
                    )
            case .status:
                Icon(style.iconSymbol, size: .large, color: style.color)
                    .background(
                        Circle()
                            .fill(Color.whiteNormal)
                            .padding(.xxSmall + 1)
                    )
        }
    }
}

// MARK: - Inits

public extension TimelineStep where Header == TimelineStepBadgeText {

    /// Creates Orbit TimelineStep component with custom details.
    init(
        _ label: String,
        sublabel: String = "",
        style: TimelineStepStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            style: style,
            isIconFirstTextLineCentered: true,
            header: {
                TimelineStepBadgeText(
                    label: label,
                    sublabel: sublabel,
                    style: style,
                    alignmentComputation: VerticalAlignment.TimelineStepAlignment.computeFirstLineCenter(in:)
                )
            },
            content: content
        )
    }
}

public extension TimelineStep where Content == TimelineStepBottomText {

    /// Creates Orbit TimelineStep component with custom header and text details.
    /// - Parameters:
    ///   - isIconFirstTextLineCentered: center icon and first text line or align with the top
    init(
        style: TimelineStepStyle = .default,
        isIconFirstTextLineCentered: Bool,
        description: String,
        @ViewBuilder header: () -> Header
    ) {
        self.init(style: style, isIconFirstTextLineCentered: isIconFirstTextLineCentered, header: header) {
            TimelineStepBottomText(text: description, style: style)
        }
    }
}

public extension TimelineStep where Header == TimelineStepBadgeText, Content == TimelineStepBottomText {

    /// Creates Orbit TimelineStep component with text details.
    init(_ label: String, sublabel: String = "", style: TimelineStepStyle = .default, description: String) {

        self.init(
            style: style,
            isIconFirstTextLineCentered: true,
            header: {
                TimelineStepBadgeText(
                    label: label,
                    sublabel: sublabel,
                    style: style,
                    alignmentComputation: VerticalAlignment.TimelineStepAlignment.computeFirstLineCenter(in:)
                )
            },
            content: { TimelineStepBottomText(text: description, style: style) }
        )
    }
}

// MARK: - Types

public enum TimelineStepStyle: Equatable {
    case `default`
    case status(Status)

    public static let indicatorDiameter: CGFloat = Icon.Size.large.value

    public var iconSymbol: Icon.Symbol {
        switch self {
            case .default:              return .none
            case .status(.success):     return .checkCircle
            case .status(.warning):     return .alertCircle
            case .status(.critical):    return .closeCircle
            case .status(.info):        return .check
        }
    }

    public var color: Color {
        switch self {
            case .default:              return .cloudNormalHover
            case .status(let status):   return status.color
        }
    }

    public var textColor: UIColor {
        switch self {
            case .default:              return .inkLight
            case .status:               return .inkNormal
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
            style: .status(.success),
            description: "We’ve assigned your request to one of our agents."
        )
        .padding()
    }

    static var snapshots: some View {
        VStack(alignment: .leading) {
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .default,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .status(.success),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .status(.warning),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .status(.critical),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineStep(
                style: .status(.warning),
                isIconFirstTextLineCentered: true,
                header: {
                    VStack {
                        Text(
                            "1 Passenger must check in with the airline for a possible fee",
                            size: .xLarge,
                            color: .custom(TimelineStepStyle.status(.warning).textColor),
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
                            style: .status(.info)
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
                style: .status(.info)
            ) {
                VStack(alignment: .leading) {
                    TimelineStepBottomText(
                        text: "We’ve assigned your request to one of our agents.",
                        style: .status(.info)
                    )

                    Button("Add info")
                        .padding(.leading, .xSmall)
                }
            }
            TimelineStep(
                style: .status(.warning),
                isIconFirstTextLineCentered: true,
                description: "We’ve assigned your request to one of our agents."
            ) {

                VStack {
                    Text(
                        "1 Passenger must check in with the airline for a possible fee",
                        size: .custom(50),
                        color: .custom(TimelineStepStyle.status(.warning).textColor),
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
                style: .status(.warning),
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
