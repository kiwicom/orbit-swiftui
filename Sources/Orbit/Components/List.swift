import SwiftUI

/// Orbit component that displays vertically arranged related items.
///
/// A ``List`` typically consists of ``ListItem`` content.
///
/// ```swift
/// List {
///     ListItem("Planes", icon: .airplane)
///     ListItem("Trains")
/// }
/// ```
///
/// ### Layout
///
/// The component arranges list items in a `VStack` aligned to `leading` edge.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/list/)
public struct List<Content: View>: View {

    private let spacing: CGFloat
    @ViewBuilder private let content: Content

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            content
        }
    }
}

// MARK: - Inits
public extension List {
    
    /// Creates Orbit ``List`` component that wraps ``ListItem`` content.
    init(spacing: CGFloat = .xSmall, @ViewBuilder _ content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
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
            ListItem(listItemText, type: .secondary)
            ListItem(listItemText, icon: .circleSmall)
            ListItem(listItemText, icon: .circleSmall, type: .secondary)
            ListItem(listItemText) {
                Icon(.grid)
                    .iconSize(.small)
            }
            ListItem(listItemText, icon: .grid)
            ListItem(listItemText, icon: .check)
                .iconColor(.greenNormal)
            ListItem(listItemText, icon: nil)
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
                ListItem(listItemText)
                ListItem(listItemText)
            }
            .textSize(.large)

            Separator()

            List {
                ListItem(listItemText, type: .secondary)
                ListItem(listItemText, type: .secondary)
            }

            List {
                ListItem(listItemText, type: .secondary)
                ListItem(listItemText, type: .secondary)
            }
            .textSize(.large)
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .medium) {
            List {
                ListItem(listItemText)
                ListItem(listItemText, icon: .circleSmall)
                ListItem(listItemText, icon: .grid)
                ListItem(listItemText, icon: .check)
                    .iconColor(.greenNormal)
                ListItem(listItemText, icon: .none)
                ListItem(listItemText, icon: .accountCircle)
                    .iconColor(.orangeNormal)
            }

            Separator()

            List {
                ListItem(listItemText)
                    .textSize(.small)
                ListItem(listItemText)
                    .textSize(.normal)
                ListItem(listItemText)
                    .textSize(.large)
                ListItem(listItemText)
                    .textSize(.xLarge)
                ListItem(listItemText)
                    .textSize(custom: 30)
            }

            Separator()

            List(spacing: .small) {
                ListItem(listItemText)
                ListItem(listItemText, type: .secondary)
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        sizes
            .padding(.medium)
    }
}
