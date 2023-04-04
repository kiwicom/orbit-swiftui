import SwiftUI

/// One item of a Timeline.
///
/// - Related components
///   - ``Timeline``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/progress-indicators/timeline/)
public struct TimelineItem<Footer: View>: View {

    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let label: String
    let sublabel: String
    let description: String
    let type: TimelineItemType
    @ViewBuilder let footer: Footer

    public var body: some View {
        HStack(alignment: alignment, spacing: .small) {
            TimelineIndicator(type: type)
            
            VStack(alignment: .leading, spacing: .xxSmall) {
                header
                    .foregroundColor(type.textColor)

                Text(description, size: .normal)
                    .foregroundColor(type.textColor)

                footer
            }
        }
        .anchorPreference(key: TimelineItemPreferenceKey.self, value: .bounds) {
            [TimelineItemPreference(bounds: $0, type: type)]
        }
    }

    @ViewBuilder var header: some View {
        if horizontalSizeClass == .compact && sizeCategory.isAccessibilitySize {
            VStack(alignment: .leading, spacing: .xSmall) {
                headerContent
            }
        } else {
            HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                headerContent
            }
        }
    }

    @ViewBuilder var headerContent: some View {
        Heading(label, style: .title5)
            .foregroundColor(nil)
        Text(sublabel, size: .small)
            .foregroundColor(nil)
    }

    var alignment: VerticalAlignment {
        hasHeaderContent || hasDescription ? .firstTextBaseline : .top
    }

    var hasHeaderContent: Bool {
        label.isEmpty == false || sublabel.isEmpty == false
    }

    var hasDescription: Bool {
        description.isEmpty == false
    }
}

// MARK: - Inits

public extension TimelineItem {

    /// Creates Orbit TimelineItem component with text details and optional custom content at the bottom.
    init(
        _ label: String = "",
        sublabel: String = "",
        type: TimelineItemType = .future,
        description: String = "",
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {

        self.label = label
        self.sublabel = sublabel
        self.type = type
        self.description = description
        self.footer = footer()
    }
}

// MARK: - Types

public enum TimelineItemType: Equatable {

    public enum Status {
        case success
        case warning
        case critical
    }

    case past
    case present(Status? = nil)
    case future

    public var iconSymbol: Icon.Symbol {
        switch self {
            case .past:                  return .checkCircle
            case .present(.critical):    return .closeCircle
            case .present(.warning):     return .alertCircle
            case .present(.success):     return .checkCircle
            case .present:               return .none
            case .future:                return .none
        }
    }

    public var color: Color {
        switch self {
            case .past:                  return Orbit.Status.success.color
            case .present(.critical):    return Orbit.Status.critical.color
            case .present(.warning):     return Orbit.Status.warning.color
            case .present(.success):     return Orbit.Status.success.color
            case .present:               return Orbit.Status.success.color
            case .future:                return .cloudNormalHover
        }
    }

    public var isCurrentStep: Bool {
        switch self {
            case .present:
                return true
            case .past, .future:
                return false
        }
    }

    public var textColor: Color {
        isCurrentStep ? .inkDark : .inkLight
    }

    public var isLineDashed: Bool {
        switch self {
            case .future:
                return true
            case .past, .present:
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
        .previewDisplayName()
    }

    static var snapshots: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .future,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .present(),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .present(.warning),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .present(.critical),
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                type: .past,
                description: "We’ve assigned your request to one of our agents."
            )
            TimelineItem(
                type: .present(.warning)
            ) {
                contentPlaceholder
            }
        }
        .padding()
        .previewDisplayName()
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
                Button("Add info", action: {})
            }

            TimelineItem(
                type: .present(.warning),
                description: "We’ve assigned your request to one of our agents."
            ) {

                VStack {
                    Text(
                        "1 Passenger must check in with the airline for a possible fee",
                        size: .custom(50)
                    )
                    .foregroundColor(TimelineItemType.present(.warning).color)
                    .bold()
                    .padding(.leading, .xSmall)
                }
            }
            TimelineItem(
                type: .present(.warning),
                description: "We’ve assigned your request to one of our agents."
            ) {
                Circle()
                    .fill(.red)
                    .frame(width: 50, height: 50)
            }

            TimelineItem(
                type: .present(.warning)
            ) {
                Circle()
                    .fill(.red)
                    .frame(width: 50, height: 50)
            }
        }
        .padding()
        .previewDisplayName()
    }
}
