import SwiftUI
import Orbit

struct StorybookList {

    static let listItemText = "This is simple list item"

    static var basic: some View {
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
    }
}

struct StorybookListPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookList.basic
            StorybookList.mix
        }
    }
}
