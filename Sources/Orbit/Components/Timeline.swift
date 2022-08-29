import SwiftUI

/// Shows progress on a process over time.
///
/// - Related components
///   - ``TimelineStep``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/progress-indicators/timeline/)
public struct Timeline<Content: View>: View {

    @ViewBuilder let content: Content

    public var body: some View {
        if isEmpty == false {
            VStack(alignment: .leading, spacing: Self.spacing) {
                content
            }
            .backgroundPreferenceValue(TimelineStepPreferenceKey.self) { preferences in
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        ForEach(preferences.indices.dropFirst(), id: \.self) { index in
                            preferences[index].style.color
                                .frame(width: 2)
                                .frame(
                                    width: TimelineStepStyle.indicatorDiameter,
                                    height: progressLineHeight(for: index - 1, in: preferences, geometry: geometry)
                                )
                        }
                    }
                    .padding(.top, TimelineStepStyle.indicatorDiameter / 2)
                }
            }
        }
    }

    var isEmpty: Bool {
        content is EmptyView
    }

    func progressLineHeight(
        for index: Int,
        in preferences: TimelineStepPreferenceKey.Value,
        geometry: GeometryProxy
    ) -> CGFloat {
        guard preferences.indices.contains(index) else { return 0 }

        return geometry[preferences[index].bounds].height + Self.spacing
    }

    /// Creates Orbit TimelineStep component.
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

// MARK: - Constants
public extension Timeline {

    static var spacing: CGFloat { .large }
}

// MARK: - Previews
struct TimelinePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            storybookMix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Timeline {
            TimelineStep(
                "Booked",
                sublabel: "January 3, 10:43",
                style: .status(.success),
                description: "You booked the trip and received e-tickets."
            )
            TimelineStep(
                "Checked in",
                sublabel: "May 3, 8:45",
                style: .status(.success),
                description: "You checked in for the trip and received boarding passes"
            )
            TimelineStep(
                "Board",
                sublabel: "May 4, 8:15",
                style: .status(.warning),
                description: "Be at your departure gate at least 30 minutes before boarding."
            )
            TimelineStep(
                "Board",
                sublabel: "May 4, 8:15",
                style: .status(.critical),
                description: "Be at your departure gate at least 30 minutes before boarding."
            )
            contentPlaceholder
                .padding(.leading, .xLarge)
                .anchorPreference(key: TimelineStepPreferenceKey.self, value: .bounds) {
                    [TimelineStepPreference(bounds: $0, style: .default)]
                }
            TimelineStep(
                "Arrive",
                sublabel: "May 4, 11:49",
                description: "Arrive at your destination"
            )
        }
    }

    static var storybook: some View {
        standalone
    }

    static var storybookMix: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            Timeline {
                ForEach(steps) { step in
                    TimelineStep(step.label, sublabel: step.sublabel, style: step.style, description: step.content)
                }
            }

            Timeline {
                ForEach(steps1) { step in
                    TimelineStep(step.label, sublabel: step.sublabel, style: step.style, description: step.content)
                }
            }

            Timeline {
                ForEach(steps2) { step in
                    TimelineStep(step.label, sublabel: step.sublabel, style: step.style, description: step.content)
                }
            }

            Timeline {
                ForEach(steps3) { step in
                    TimelineStep(step.label, sublabel: step.sublabel, style: step.style, description: step.content)
                }
            }

            Timeline {
                ForEach(steps4) { step in
                    TimelineStep(step.label, sublabel: step.sublabel, style: step.style, description: step.content)
                }
            }
        }
    }

    static var snapshot: some View {
        storybook
            .padding(.medium)
    }

    static let steps: [TimelineStepModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, style: .status(.success), content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, content: texts[3].content),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps1: [TimelineStepModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, style: .status(.success), content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, style: .status(.success), content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, style: .status(.success), content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, style: .status(.success), content: texts[3].content),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps2: [TimelineStepModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, style: .status(.success), content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, style: .status(.success), content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, style: .status(.success), content: texts[2].content),
        .init(
            3,
            "Action required",
            sublabel: texts[3].sublabel,
            style: .status(.warning),
            content: "The carrier has sent us a refund. There might be more depending on their policy."
        ),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps3: [TimelineStepModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, style: .status(.success), content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, style: .status(.success), content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, style: .status(.success), content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, style: .status(.success), content: texts[3].content),
        .init(4, "Non refundable", sublabel: "25th Jun 10:48", style: .status(.critical), content: texts[4].content),
    ]

    static let steps4: [TimelineStepModel] = [
        .init(1, texts[0].label, sublabel: texts[0].sublabel, style: .status(.success), content: texts[0].content),
        .init(2, texts[1].label, sublabel: texts[1].sublabel, style: .status(.success), content: texts[1].content),
        .init(3, texts[2].label, sublabel: texts[2].sublabel, style: .status(.success), content: texts[2].content),
        .init(4, texts[3].label, sublabel: texts[3].sublabel, style: .status(.success), content: texts[3].content),
        .init(5, texts[4].label, sublabel: "25th Jun 10:48", style: .status(.success), content: ""),
    ]
}

extension TimelinePreviews {

    struct TimelineStepModel: Identifiable {
        let id: Int
        let label: String
        var sublabel = ""
        var style: TimelineStepStyle = .default
        let content: String

        init(_ id: Int, _ label: String, sublabel: String = "", style: TimelineStepStyle = .default, content: String) {
            self.id = id
            self.label = label
            self.sublabel = sublabel
            self.style = style
            self.content = content
        }
    }

    struct TimelineStepTextModel {
        let label: String
        var sublabel = ""
        let content: String
    }

    static let texts: [TimelineStepTextModel] = [
        .init(
            label: "Requested",
            sublabel: "3rd May 14:04",
            content: "We’ve received your request and will assign it to one of our agents."
        ),
        .init(
            label: "In progress",
            sublabel: "4th May 18:24",
            content: "We’ll review your request and apply for any available refund from the carrier(s)."
        ),
        .init(
            label: "Waiting for the carrier",
            sublabel: "4th May 18:24",
            content: "We’ve applied for a refund from the carrier(s)."
        ),
        .init(
            label: "Carrier is refunding",
            sublabel: "16th Jun 08:42",
            content: "The carrier(s) is processing your refund request. We’ll contact them again if necessary."
        ),
        .init(
            label: "Refunded",
            content: "We’ll forward you all refunds from the carrier(s) after we receive it."
        ),
    ]
}

struct TimelineDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")
            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        TimelinePreviews.standalone
    }
}
