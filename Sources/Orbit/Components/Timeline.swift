import SwiftUI

/// Shows progress on a process over time.
///
/// - Related components
///   - ``TimelineItem``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/progress-indicators/timeline/)
public struct Timeline<Content: View>: View {

    @Environment(\.sizeCategory) var sizeCategory
    var selectedIndex: Int
    var currentStatus: TimelineItemType.Status?
    @ViewBuilder let content: Content

    @State var timelineConfiguration: TimelineConfigurationKey.Value = [:]

    public var body: some View {
        if isEmpty == false {
            VStack(alignment: .leading, spacing: Self.spacing) {
                content
                    .environment(\.timelineConfiguration, timelineConfiguration)
            }
            .onPreferenceChange(TimelineItemPreferenceKey.self, perform: onTimelineItemPreferenceUpdate)
            .backgroundPreferenceValue(TimelineItemPreferenceKey.self) { preferences in
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        ForEach(preferences.indices.dropFirst(), id: \.self) { index in
                            TimelineLine(
                                height: progressLineHeight(for: index - 1, in: preferences, geometry: geometry),
                                startPointType: timelineConfiguration[preferences[index - 1].hashValue] ?? .future,
                                endPointType: timelineConfiguration[preferences[index].hashValue] ?? .future
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

    func onTimelineItemPreferenceUpdate(_ preferences: TimelineItemPreferenceKey.Value) {
        for (index, preference) in preferences.enumerated() {
            if index < selectedIndex {
                timelineConfiguration[preference.hashValue] = .past
            } else if index == selectedIndex {
                timelineConfiguration[preference.hashValue] = .present(currentStatus)
            } else {
                timelineConfiguration[preference.hashValue ] = .future
            }
        }
    }

    /// Creates Orbit TimelineItem component.
    public init(
        selectedIndex: Int,
        currentStatus: TimelineItemType.Status? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.selectedIndex = selectedIndex
        self.currentStatus = currentStatus
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
        Timeline(selectedIndex: 3) {
            TimelineItem(
                "Booked",
                sublabel: "January 3, 10:43",
                description: "You booked the trip and received e-tickets."
            )
            TimelineItem(
                "Checked in",
                sublabel: "May 3, 8:45",
                description: "You checked in for the trip and received boarding passes"
            )
            TimelineItem(
                "Board",
                sublabel: "May 4, 8:15",
                description: "Be at your departure gate at least 30 minutes before boarding."
            )
            TimelineItem(
                "Board",
                sublabel: "May 4, 8:16",
                description: "Be at your departure gate at least 30 minutes before boarding."
            )
            TimelineItem(
                "Board",
                sublabel: "May 4, 8:17",
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
    }

    static var storybook: some View {
        standalone
    }

    static var storybookMix: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            Timeline(selectedIndex: 3) {
                ForEach(steps) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, description: step.content)
                }
            }

            Timeline(selectedIndex: 3) {
                ForEach(steps1) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, description: step.content)
                }
            }

            Timeline(selectedIndex: 3) {
                ForEach(steps2) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, description: step.content)
                }
            }

            Timeline(selectedIndex: 3) {
                ForEach(steps3) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, description: step.content)
                }
            }

            Timeline(selectedIndex: 3) {
                ForEach(steps4) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, description: step.content)
                }
            }
        }
    }

    static var snapshot: some View {
        storybook
            .padding(.medium)
    }

    static let steps: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, content: texts[3].content),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps1: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, content: texts[3].content),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps2: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, content: texts[2].content),
        .init(
            3,
            "Action required",
            sublabel: texts[3].sublabel,
            content: "The carrier has sent us a refund. There might be more depending on their policy."
        ),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps3: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, content: texts[3].content),
        .init(4, "Non refundable", sublabel: "25th Jun 10:48", content: texts[4].content),
    ]

    static let steps4: [TimelineItemModel] = [
        .init(1, texts[0].label, sublabel: texts[0].sublabel, content: texts[0].content),
        .init(2, texts[1].label, sublabel: texts[1].sublabel, content: texts[1].content),
        .init(3, texts[2].label, sublabel: texts[2].sublabel, content: texts[2].content),
        .init(4, texts[3].label, sublabel: texts[3].sublabel, content: texts[3].content),
        .init(5, texts[4].label, sublabel: "25th Jun 10:48", content: ""),
    ]
}

extension TimelinePreviews {

    struct TimelineItemModel: Identifiable {
        let id: Int
        let label: String
        var sublabel = ""
        let content: String

        init(_ id: Int, _ label: String, sublabel: String = "", content: String) {
            self.id = id
            self.label = label
            self.sublabel = sublabel
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
