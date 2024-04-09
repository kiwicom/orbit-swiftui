import SwiftUI
import Orbit

struct StorybookTimeline {

    static var basic: some View {
        Timeline {
            TimelineItem(
                "Booked",
                sublabel: "January 3, 10:43",
                description: "You booked the trip and received e-tickets.", 
                type: .present(.success)
            )
            TimelineItem(
                "Checked in",
                sublabel: "May 3, 8:45",
                description: "You checked in for the trip and received boarding passes",
                type: .present(.success)
            )
            TimelineItem(
                "Board",
                sublabel: "May 4, 8:15",
                description: "Be at your departure gate at least 30 minutes before boarding.",
                type: .present(.warning)
            )

            TimelineItem(type: .present) {
                Heading("Board", style: .title5)
            } sublabel: {
                Text("May 4, 8:15")
            } description: {
                Text("Be at your departure gate at least 30 minutes before boarding.")
            } footer: {
                contentPlaceholder
            }

            TimelineItem(
                "Arrive",
                sublabel: "May 4, 11:49",
                description: "Arrive at your destination",
                type: .future
            )
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            Timeline {
                ForEach(steps) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, description: step.content, type: step.type)
                }
            }

            Timeline {
                ForEach(steps1) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, description: step.content, type: step.type)
                }
            }

            Timeline {
                ForEach(steps2) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, description: step.content, type: step.type)
                }
            }

            Timeline {
                ForEach(steps3) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, description: step.content, type: step.type)
                }
            }

            Timeline {
                ForEach(steps4) { step in
                    TimelineItem(step.label, sublabel: step.sublabel, description: step.content, type: step.type)
                }
            }
        }
        .previewDisplayName()
    }

    static let steps: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, type: .present(.success), content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, content: texts[3].content),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps1: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, type: .present(.success), content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, type: .present(.success), content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, type: .present(.success), content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, type: .present(.success), content: texts[3].content),
        .init(4, texts[4].label, sublabel: texts[4].sublabel, content: texts[4].content),
    ]

    static let steps2: [TimelineItemModel] = [
        .init(0, texts[0].label, sublabel: texts[0].sublabel, type: .present(.success), content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, type: .present(.success), content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, type: .present(.success), content: texts[2].content),
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
        .init(0, texts[0].label, sublabel: texts[0].sublabel, type: .present(.success), content: texts[0].content),
        .init(1, texts[1].label, sublabel: texts[1].sublabel, type: .present(.success), content: texts[1].content),
        .init(2, texts[2].label, sublabel: texts[2].sublabel, type: .present(.success), content: texts[2].content),
        .init(3, texts[3].label, sublabel: texts[3].sublabel, type: .present(.success), content: texts[3].content),
        .init(4, "Non refundable", sublabel: "25th Jun 10:48", type: .present(.critical), content: texts[4].content),
    ]

    static let steps4: [TimelineItemModel] = [
        .init(1, texts[0].label, sublabel: texts[0].sublabel, type: .present(.success), content: texts[0].content),
        .init(2, texts[1].label, sublabel: texts[1].sublabel, type: .present(.success), content: texts[1].content),
        .init(3, texts[2].label, sublabel: texts[2].sublabel, type: .present(.success), content: texts[2].content),
        .init(4, texts[3].label, sublabel: texts[3].sublabel, type: .present(.success), content: texts[3].content),
        .init(5, texts[4].label, sublabel: "25th Jun 10:48", type: .present(.success), content: ""),
    ]
}

extension StorybookTimeline {

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

struct StorybookTimelinePreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookTimeline.basic
            StorybookTimeline.mix
        }
    }
}
