import SwiftUI

/// Orbit component that shows a single item in a ``Timeline``.
///
/// A ``TimelineItem`` consists of a label, description and a type that determines its visual progress:
/// 
/// ```swift
/// Timeline {
///     TimelineItem("Booked", type: .past)
///     TimelineItem("Checked in", type: .past)
///     TimelineItem("Board", type: .present)
/// }
/// ```
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/progress-indicators/timeline/)
public struct TimelineItem<Label: View, Sublabel: View, Description: View, Footer: View>: View {

    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private let type: TimelineItemType
    
    @ViewBuilder private let label: Label
    @ViewBuilder private let sublabel: Sublabel
    @ViewBuilder private let description: Description
    @ViewBuilder private let footer: Footer

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            TimelineIndicator(type: type)
            
            VStack(alignment: .leading, spacing: .xxSmall) {
                header
                    .textColor(type.textColor)

                description
                    .textColor(type.textColor)

                footer
            }
        }
        .anchorPreference(key: TimelineItemPreferenceKey.self, value: .bounds) {
            [TimelineItemPreference(bounds: $0, type: type)]
        }
    }

    @ViewBuilder private var header: some View {
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

    @ViewBuilder private var headerContent: some View {
        label
        sublabel
            .textSize(.small)
    }
    
    /// Creates Orbit ``TimelineItem`` component with custom content.
    public init(
        type: TimelineItemType = .future,
        @ViewBuilder label: () -> Label,
        @ViewBuilder sublabel: () -> Sublabel = { EmptyView() },
        @ViewBuilder description: () -> Description = { EmptyView() },
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {
        self.type = type
        self.label = label()
        self.sublabel = sublabel()
        self.description = description()
        self.footer = footer()
    }
}

// MARK: - Convenience Inits
public extension TimelineItem where Label == Heading, Sublabel == Text, Description == Text, Footer == EmptyView {

    /// Creates Orbit ``TimelineItem`` component.
    @_disfavoredOverload
    init(
        _ label: some StringProtocol = String(""),
        sublabel: some StringProtocol = String(""),
        description: some StringProtocol = String(""),
        type: TimelineItemType
    ) {
        self.init(type: type) {
            Heading(label, style: .title5)
        } sublabel: {
            Text(sublabel)
        } description: {
            Text(description)
        }
    }
    
    /// Creates Orbit ``TimelineItem`` component with localizable texts.
    @_semantics("swiftui.init_with_localization")
    init(
        _ label: LocalizedStringKey = "",
        sublabel: LocalizedStringKey = "",
        description: LocalizedStringKey = "",
        type: TimelineItemType,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        labelComment: StaticString? = nil
    ) {
        self.init(type: type) {
            Heading(label, style: .title5, tableName: tableName, bundle: bundle)
        } sublabel: {
            Text(sublabel, tableName: tableName, bundle: bundle)
        } description: {
            Text(description, tableName: tableName, bundle: bundle)
        }
    }
}

// MARK: - Types

/// Orbit ``TimelineItem`` type.
public enum TimelineItemType: Equatable {

    /// Orbit ``TimelineItemType`` status.
    public enum Status {
        case success
        case warning
        case critical
    }

    case past
    case present(Status? = nil)
    case future

    public static var present: Self { present() }
    
    public var icon: Icon.Symbol? {
        switch self {
            case .past:                  return .checkCircle
            case .present(.critical):    return .closeCircle
            case .present(.warning):     return .alertCircle
            case .present(.success):     return .checkCircle
            case .present:               return nil
            case .future:                return nil
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
            description: "We’ve assigned your request to one of our agents.",
            type: .past
        )
        .padding()
        .previewDisplayName()
    }

    static var snapshots: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                description: "We’ve assigned your request to one of our agents.",
                type: .future
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                description: "We’ve assigned your request to one of our agents.",
                type: .present
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                description: "We’ve assigned your request to one of our agents.",
                type: .present(.warning)
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                description: "We’ve assigned your request to one of our agents.",
                type: .present(.critical)
            )
            TimelineItem(
                "Requested",
                sublabel: "3rd May 14:04",
                description: "We’ve assigned your request to one of our agents.",
                type: .past
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
            TimelineItem(type: .future) {
                Heading("Requested", style: .title5)
            } sublabel: {
                Text("3rd May 14:04")
            } description: {
                Text("We’ve assigned your request to one of our agents.")
            } footer: {
                Button("Add info", action: {})
            }

            TimelineItem(type: .present(.warning)) { 
                EmptyView()
            } description: {
                Text("We’ve assigned your request to one of our agents.")
            } footer: {
                VStack {
                    Text("1 Passenger must check in with the airline for a possible fee")
                        .textSize(custom: 50)
                        .textColor(TimelineItemType.present(.warning).color)
                        .bold()
                        .padding(.leading, .xSmall)
                }
            }
                         
            TimelineItem(type: .present(.warning)) { 
                EmptyView()
            } description: {
                Text("We’ve assigned your request to one of our agents.")
            } footer: {
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
