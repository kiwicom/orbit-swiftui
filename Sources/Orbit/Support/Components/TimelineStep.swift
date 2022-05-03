import SwiftUI

/// One item of a Timeline.
///
/// - Related components
///   - ``Timeline``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/progress-indicators/timeline/)
public struct TimelineStep: View {

    public static let indicatorDiameter: CGFloat = Icon.Size.large.value

    let label: String
    let sublabel: String
    let style: Style
    let content: String

    public var body: some View {
        HStack(alignment: .top, spacing: .small) {
            Color.clear
                .frame(width: Icon.Size.large.value, height: Icon.Size.large.value)
                .overlay(indicator)

            VStack(alignment: .leading, spacing: .xSmall) {
                HStack(spacing: .xSmall) {
                    Badge(label, style: badgeStyle)

                    Text(sublabel, size: .small)
                }

                Text(content, size: .normal, color: .custom(style.textColor))
                    .padding(.leading, .xSmall)
            }
            .anchorPreference(key: PreferenceKey.self, value: .bounds) {
                [TimelineStepPreference(bounds: $0, style: style)]
            }
        }
    }

    @ViewBuilder var indicator: some View {
        icon
            .background(
                Circle()
                    .fill(Color.whiteNormal)
                    .padding(.xxxSmall)
            )
    }

    @ViewBuilder var icon: some View {
        switch style {
            case .default:
                Circle()
                    .strokeBorder(Color.cloudNormalHover, lineWidth: 2)
                    .frame(width: .small, height: .small)
            case .status:
                Icon(style.icon, size: .large, color: style.color)
        }
    }

    var badgeStyle: Badge.Style {
        switch style {
            case .default:              return .neutral
            case .status(let status):   return .status(status, inverted: false)
        }
    }
}

// MARK: - Inits
public extension TimelineStep {

    /// Creates Orbit TimelineStep component.
    init(_ label: String = "", sublabel: String = "", style: Style = .default, content: String) {
        self.label = label
        self.sublabel = sublabel
        self.style = style
        self.content = content
    }
}

// MARK: - Types
extension TimelineStep {

    public enum Style: Equatable {
        case `default`
        case status(Status)

        public var icon: Icon.Symbol {
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

    struct PreferenceKey: SwiftUI.PreferenceKey {
        typealias Value = [TimelineStepPreference]

        static var defaultValue: Value = []

        static func reduce(value: inout Value, nextValue: () -> Value) {
            value.append(contentsOf: nextValue())
        }
    }
}

struct TimelineStepPreference {
    let bounds: Anchor<CGRect>
    let style: TimelineStep.Style
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
            style: .default,
            content: "We’ve assigned your request to one of our agents."
        )
        .padding()
    }

    static var snapshots: some View {
        VStack {
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .default,
                content: "We’ve assigned your request to one of our agents."
            )
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .status(.success),
                content: "We’ve assigned your request to one of our agents."
            )
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .status(.warning),
                content: "We’ve assigned your request to one of our agents."
            )
            TimelineStep(
                "Requested",
                sublabel: "3rd May 14:04",
                style: .status(.critical),
                content: "We’ve assigned your request to one of our agents."
            )
        }
        .padding()
        .previewDisplayName("Snapshots")
    }
}
