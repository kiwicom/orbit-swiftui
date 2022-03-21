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
        VStack(alignment: .listTextLeading, spacing: spacing) {
            content()
        }
    }

    /// Creates Orbit List component, wrapping ListItem content.
    public init(spacing: CGFloat = .xSmall, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }
}

// MARK: - Alignment
public extension HorizontalAlignment {
    
    static let listTextLeading = Self.labelTextLeading
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
            ListItem("This is just a line", iconContent: .icon(.airplaneDown, color: .blue))
            ListItem("This is just a line")
            ListItem("This is just a line", icon: .none)
            ListItem("This is just a line", iconContent: .icon(.baggageSet))
        }
    }

    static var snapshots: some View {
        Group {
            List {
                ListItem("This is just a normal a normal a normal a normal line just a normal line", iconContent: .icon(.airplaneDown, color: .green), size: .custom(20))
                ListItem("This is just a normal just a normal linejust a normal linejust a normal lineline", iconContent: .icon(.chat, color: .inkNormal))
                ListItem("This is just a normal line just a normal line just a normal line", iconContent: .icon(.accountCircle, color: .orange))
                ListItem("This is just a normal line", iconContent: .icon(.document, color: .blue))
                ListItem("This is just a normal line", icon: .none)
            }
            .border(.red)
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
