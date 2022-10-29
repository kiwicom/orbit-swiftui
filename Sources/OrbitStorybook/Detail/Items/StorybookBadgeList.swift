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
                BadgeList(longLabel, icon: .grid, labelColor: .secondary, size: .small)
                BadgeList(label, icon: .informationCircle, style: .status(.info), labelColor: .secondary, size: .small)
                BadgeList(label, icon: .checkCircle, style: .status(.success), labelColor: .secondary, size: .small)
                BadgeList(label, icon: .alertCircle, style: .status(.warning), labelColor: .secondary, size: .small)
                BadgeList(label, icon: .alertCircle, style: .status(.critical), labelColor: .secondary, size: .small)
            }
        }
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .medium) {
            BadgeList("This is simple <ref>BadgeList</ref> item with <strong>SF Symbol</strong>", icon: .sfSymbol("info.circle.fill"), style: .status(.info))
            BadgeList("This is simple <ref>BadgeList</ref> item with <strong>CountryFlag</strong>", icon: .countryFlag("cz"), style: .status(.critical))
            BadgeList("This is simple <ref>BadgeList</ref> item with custom image", icon: .image(.orbit(.facebook)), style: .status(.success))
            BadgeList("This is <ref>BadgeList</ref> item with no icon and custom color", labelColor: .custom(.blueDark))
        }
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
