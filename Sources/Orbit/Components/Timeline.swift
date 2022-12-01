import SwiftUI

/// Shows progress on a process over time.
///
/// - Related components
///   - ``TimelineItem``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/progress-indicators/timeline/)
public struct Timeline<Content: View>: View {

    @Environment(\.sizeCategory) var sizeCategory
    @ViewBuilder let content: Content

    public var body: some View {
        if isEmpty == false {
            VStack(alignment: .leading, spacing: Self.spacing) {
                content
            }
            .backgroundPreferenceValue(TimelineItemPreferenceKey.self) { preferences in
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        ForEach(preferences.indices.dropFirst(), id: \.self) { index in
                            TimelineLine(
                                height: progressLineHeight(for: index - 1, in: preferences, geometry: geometry),
                                startPointType: preferences[index - 1].type,
                                endPointType: preferences[index].type
                            )
                            .offset(x: TimelineIndicator.indicatorDiameter * sizeCategory.ratio / 2)
                        }
                    }
                    .padding(.top, TimelineIndicator.indicatorDiameter * sizeCategory.ratio / 2)
                }
            }
        }
    }

    var isEmpty: Bool {
        content is EmptyView
    }

    func progressLineHeight(
        for index: Int,
        in preferences: TimelineItemPreferenceKey.Value,
        geometry: GeometryProxy
    ) -> CGFloat {
        guard preferences.indices.contains(index) else { return 0 }

        return geometry[preferences[index].bounds].height + Self.spacing
    }

    /// Creates Orbit TimelineItem component.
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
            mix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Timeline {
            TimelineItem(
                "Booked",
                sublabel: "January 3, 10:43",
                type: .past,
                description: "You booked the trip and received e-tickets."
            )
            TimelineItem(
                "Checked in",
                sublabel: "May 3, 8:45",
                type: .past,
                description: "You checked in for the trip and received boarding passes"
            )
            TimelineItem(
                "Board",
                sublabel: "May 4, 8:15",
                type: .past,
                description: "Be at your departure gate at least 30 minutes before boarding."
            )
            TimelineItem(
                "Board",
                sublabel: "May 4, 8:15",
                type: .past,
                description: "Be at your departure gate at least 30 minutes before boarding."
            )
            TimelineItem(
                "Board",
                sublabel: "May 4, 8:15",
                type: .present(),
                description: "Be at your departure gate at least 30 minutes before boarding."
            ) {
                contentPlaceholder
            }

            TimelineItem(
                "Arrive",
                sublabel: "May 4, 11:49",
                description: "Arrive at your destination"
            )
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            Timeline {
                ForEach(steps) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, type: step.type, description: step.content)
                }
            }

            Timeline {
                ForEach(steps1) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, type: step.type, description: step.content)
                }
            }

            Timeline {
                ForEach(steps2) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, type: step.type, description: step.content)
                }
            }

            Timeline {
                ForEach(steps3) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, type: step.type, description: step.content)
                }
            }

            Timeline {
                ForEach(steps4) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, type: step.type, description: step.content)
                }
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        standalone
            .padding(.medium)
    }

    static let steps: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, type: .present(), content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, content: texts[3].content),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps1: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, type: .past, content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, type: .past, content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, type: .past, content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, type: .present(), content: texts[3].content),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps2: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, type: .past, content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, type: .past, content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, type: .past, content: texts[2].content),
        .init(
            3,
            "Action required",
            sublabel: texts[3].sublabel,
            type: .present(.warning),
            content: "The carrier has sent us a refund. There might be more depending on their policy."
        ),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps3: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, type: .past, content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, type: .past, content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, type: .past, content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, type: .past, content: texts[3].content),
        .init(4, "Non refundable", sublabel: "25th Jun 10:48", type: .present(.critical), content: texts[4].content),
    ]

    static let steps4: [TimelineItemModel] = [
        .init(1, texts[0].label, sublabel: texts[0].sublabel, type: .past, content: texts[0].content),
        .init(2, texts[1].label, sublabel: texts[1].sublabel, type: .past, content: texts[1].content),
        .init(3, texts[2].label, sublabel: texts[2].sublabel, type: .past, content: texts[2].content),
        .init(4, texts[3].label, sublabel: texts[3].sublabel, type: .past, content: texts[3].content),
        .init(5, texts[4].label, sublabel: "25th Jun 10:48", type: .present(.success), content: ""),
    ]
}

extension TimelinePreviews {

    struct TimelineItemModel: Identifiable {
        let id: Int
        let label: String
        var sublabel = ""
        var type: TimelineItemType = .future
        let content: String

        init(_ id: Int, _ label: String, sublabel: String = "", type: TimelineItemType = .future, content: String) {
            self.id = id
            self.label = label
            self.sublabel = sublabel
            self.type = type
            self.content = content
        }
    }

    struct TimelineItemTextModel {
        let label: String
        var sublabel = ""
        let content: String
    }

    static let texts: [TimelineItemTextModel] = [
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
