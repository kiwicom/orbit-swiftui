import SwiftUI

/// Shows related items.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/list/)
public struct List<Content: View>: View {

    let spacing: CGFloat
    @ViewBuilder let content: Content

    public var body: some View {
        VStack(alignment: .listTextLeading, spacing: spacing) {
            content
        }
    }

    /// Creates Orbit List component, wrapping ListItem content.
    public init(spacing: CGFloat = .xSmall, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
}

// MARK: - Alignment
public extension HorizontalAlignment {
    
    static let listTextLeading = Self.labelTextLeading
}

// MARK: - Previews
struct ListPreviews: PreviewProvider {

    static let listItemText = "This is simple list item"

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizes
            mix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        List {
            ListItem(listItemText)
            ListItem(listItemText, icon: .grid)
            ListItem(listItemText, icon: .symbol(.check, color: .greenNormal))
            ListItem(listItemText, icon: .none)
        }
        .previewDisplayName()
    }

    static var sizes: some View {
        VStack(alignment: .leading, spacing: .medium) {
            List {
                ListItem(listItemText)
                ListItem(listItemText)
            }

            List {
                ListItem(listItemText, size: .large)
                ListItem(listItemText, size: .large)
            }

            Separator()

            List {
                ListItem(listItemText, style: .secondary)
                ListItem(listItemText, style: .secondary)
            }

            List {
                ListItem(listItemText, size: .large, style: .secondary)
                ListItem(listItemText, size: .large, style: .secondary)
            }
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .medium) {
            List {
                ListItem(listItemText)
                ListItem(listItemText, icon: .grid)
                ListItem(listItemText, icon: .symbol(.check, color: .greenNormal))
                ListItem(listItemText, icon: .none)
                ListItem(listItemText, icon: .symbol(.accountCircle, color: .orangeNormal))
            }

            Separator()

            List {
                ListItem(listItemText, size: .small)
                ListItem(listItemText, size: .normal)
                ListItem(listItemText, size: .large)
                ListItem(listItemText, size: .xLarge)
                ListItem(listItemText, size: .custom(30))
            }

            Separator()

            List(spacing: .large) {
                ListItem(listItemText, spacing: 0)
                ListItem(listItemText, spacing: 0)
                ListItem(listItemText, spacing: .small)
                ListItem(listItemText, spacing: .small)
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        sizes
            .padding(.medium)
    }
}
