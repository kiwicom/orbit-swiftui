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

            List(spacing: .large) {
                ListItem(listItemText)
                ListItem(listItemText)
                ListItem(listItemText)
                ListItem(listItemText)
            }
        }
        .previewDisplayName()
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
