import SwiftUI
import Orbit

struct StorybookBadgeList {

    static let label = "This is simple BadgeList item"
    static let longLabel = "This is simple Neutral BadgeList item with <u>very long</u> and <strong>formatted</strong> multiline content with a <a href=\".\">TextLink</a>"

    static var basic: some View {
        VStack(alignment: .leading, spacing: .xxLarge) {
            VStack(alignment: .leading, spacing: .medium) {
                BadgeList(longLabel, icon: .grid)
                BadgeList(label, icon: .informationCircle, style: .status(.info))
                BadgeList(label, icon: .checkCircle, style: .status(.success))
                BadgeList(label, icon: .alertCircle, style: .status(.warning))
                BadgeList(label, icon: .alertCircle, style: .status(.critical))
            }
            VStack(alignment: .leading, spacing: .medium) {
                BadgeList(longLabel, icon: .grid)
                BadgeList(label, icon: .informationCircle, style: .status(.info))
                BadgeList(label, icon: .checkCircle, style: .status(.success))
                BadgeList(label, icon: .alertCircle, style: .status(.warning))
                BadgeList(label, icon: .alertCircle, style: .status(.critical))
            }
            .textColor(.inkNormal)
            .textSize(.small)
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .medium) {
            BadgeList("This is simple <ref>BadgeList</ref> item with <strong>SF Symbol</strong>", style: .status(.info)) {
                Icon("info.circle.fill")
            }
            BadgeList("This is simple <ref>BadgeList</ref> item with <strong>CountryFlag</strong>", style: .status(.critical)) {
                CountryFlag("us")
            }
            BadgeList("This is <ref>BadgeList</ref> item with no icon and custom color")
                .textColor(.blueDark)
        }
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
