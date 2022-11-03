import SwiftUI
import Orbit

struct StorybookTimeline {

    static var basic: some View {
        Timeline {
            TimelineItem(
                "Booked",
                sublabel: "January 3, 10:43",
                style: .current(.success),
                description: "You booked the trip and received e-tickets."
            )
            TimelineItem(
                "Checked in",
                sublabel: "May 3, 8:45",
                style: .current(.success),
                description: "You checked in for the trip and received boarding passes"
            )
            TimelineItem(
                "Board",
                sublabel: "May 4, 8:15",
                style: .current(.warning),
                description: "Be at your departure gate at least 30 minutes before boarding."
            )
            TimelineItem(
                "Board",
                sublabel: "May 4, 8:15",
                style: .current(.critical),
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

    static var mix: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            Timeline {
                ForEach(steps) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, style: step.style, description: step.content)
                }
            }

            Timeline {
                ForEach(steps1) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, style: step.style, description: step.content)
                }
            }

            Timeline {
                ForEach(steps2) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, style: step.style, description: step.content)
                }
            }

            Timeline {
                ForEach(steps3) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, style: step.style, description: step.content)
                }
            }

            Timeline {
                ForEach(steps4) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, style: step.style, description: step.content)
                }
            }
        }
    }

    static let steps: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, style: .current(.success), content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, content: texts[3].content),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps1: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, style: .current(.success), content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, style: .current(.success), content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, style: .current(.success), content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, style: .current(.success), content: texts[3].content),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps2: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, style: .current(.success), content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, style: .current(.success), content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, style: .current(.success), content: texts[2].content),
        .init(
            3,
            "Action required",
            sublabel: texts[3].sublabel,
            style: .current(.warning),
            content: "The carrier has sent us a refund. There might be more depending on their policy."
        ),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps3: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, style: .current(.success), content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, style: .current(.success), content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, style: .current(.success), content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, style: .current(.success), content: texts[3].content),
        .init(4, "Non refundable", sublabel: "25th Jun 10:48", style: .current(.critical), content: texts[4].content),
    ]

    static let steps4: [TimelineItemModel] = [
        .init(1, texts[0].label, sublabel: texts[0].sublabel, style: .current(.success), content: texts[0].content),
        .init(2, texts[1].label, sublabel: texts[1].sublabel, style: .current(.success), content: texts[1].content),
        .init(3, texts[2].label, sublabel: texts[2].sublabel, style: .current(.success), content: texts[2].content),
        .init(4, texts[3].label, sublabel: texts[3].sublabel, style: .current(.success), content: texts[3].content),
        .init(5, texts[4].label, sublabel: "25th Jun 10:48", style: .current(.success), content: ""),
    ]
}

extension StorybookTimeline {

    struct TimelineItemModel: Identifiable {
        let id: Int
        let label: String
        var sublabel = ""
        var style: TimelineItemStyle = .future
        let content: String

        init(_ id: Int, _ label: String, sublabel: String = "", style: TimelineItemStyle = .future, content: String) {
            self.id = id
            self.label = label
            self.sublabel = sublabel
            self.style = style
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

struct StorybookTimelinePreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookTimeline.basic
            StorybookTimeline.mix
        }
    }
}
