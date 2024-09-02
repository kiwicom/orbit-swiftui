import SwiftUI
import Orbit

struct StorybookBadgeList {

    static let label = "This is simple BadgeList item"
    static let longLabel = "This is simple Neutral BadgeList item with <u>very long</u> and <strong>formatted</strong> multiline content with a <a href=\".\">TextLink</a>"

    static var basic: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .medium) {
                BadgeList(longLabel, icon: .grid)
                BadgeList(label, icon: .informationCircle, type: .status(.info))
                BadgeList(label, icon: .checkCircle, type: .status(.success))
                BadgeList(label, icon: .alertCircle, type: .status(.warning))
                BadgeList(label, icon: .alertCircle, type: .status(.critical))
            }
            VStack(alignment: .leading, spacing: .medium) {
                BadgeList(longLabel, icon: .grid)
                BadgeList(label, icon: .informationCircle, type: .status(.info))
                BadgeList(label, icon: .checkCircle, type: .status(.success))
                BadgeList(label, icon: .alertCircle, type: .status(.warning))
                BadgeList(label, icon: .alertCircle, type: .status(.critical))
            }
            .textColor(.inkNormal)
            .textSize(.small)
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .medium) {
            BadgeList(type: .status(.info)) {
                Text("This is simple <ref>BadgeList</ref> item with <strong>SF Symbol</strong>")
            } icon: {
                Icon("info.circle.fill")
            }
            
            BadgeList(type: .status(.critical)) {
                Text("This is simple <ref>BadgeList</ref> item with <strong>CountryFlag</strong>")
            } icon: {
                CountryFlag("us")                
            }
            
            BadgeList("This is <ref>BadgeList</ref> item with no icon and custom color")
                .textColor(.blueDark)
            
            BadgeList(type: .status(nil)) {
                Text("This is a <ref>BadgeList</ref> with <strong>status</strong> override")
            } icon: {
                Icon("info.circle.fill")                
            }
        }
        .iconSize(.small)
        .status(.success)
        .previewDisplayName()
    }
}

struct StorybookBadgeListPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookBadgeList.basic
            StorybookBadgeList.mix
        }
    }
}
