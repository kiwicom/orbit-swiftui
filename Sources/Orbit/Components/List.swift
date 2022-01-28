import SwiftUI

/// Shows related items.
///
/// A wrapper for ``ListItem`` components.
///
/// - Related components:
///   - ``ListItem``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/list/)
public struct List<Content: View>: View {

    let spacing: CGFloat
    let content: () -> Content

    public var body: some View {
        VStack(alignment: .listAlignment, spacing: spacing) {
            content()
        }
    }

    /// Creates Orbit List component, wrapping ListItem content.
    public init(spacing: CGFloat = .xSmall, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }
}

extension HorizontalAlignment {
    
    enum ListAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.leading]
        }
    }

    static let listAlignment = HorizontalAlignment(ListAlignment.self)
}

// MARK: - Previews
struct ListPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshots
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        List {
            ListItem("This is just a line", iconContent: .icon(.airplaneDown, size: .small, color: .blue))
            ListItem("This is just a line")
            ListItem("This is just a line", icon: .none)
            ListItem("This is just a line", iconContent: .icon(.baggageSet, size: .small))
        }
    }

    static var snapshots: some View {
        Group {
            List {
                ListItem("This is just a normal line", iconContent: .icon(.airplaneDown, size: .small, color: .green))
                ListItem("This is just a normal line", iconContent: .icon(.chat, size: .small, color: .inkNormal))
                ListItem("This is just a normal line", iconContent: .icon(.accountCircle, size: .small, color: .orange))
                ListItem("This is just a normal line", iconContent: .icon(.document, size: .small, color: .blue))
                ListItem("This is just a normal line", icon: .none)
            }
            .padding()

            List {
                ListItem("This is just a normal line")
                ListItem("This is just a normal line", size: .normal, style: .secondary)
                ListItem("This is just a normal line", size: .large, style: .primary)
                ListItem("This is just a normal line", size: .large, style: .secondary)
                ListItem("This is just a normal line", size: .small, style: .primary)
                ListItem("This is just a normal line", size: .small, style: .secondary)
            }
            .padding()
        }
        .previewDisplayName("Snapshots")
    }
}
