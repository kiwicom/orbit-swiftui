import SwiftUI
import Orbit

struct StorybookHorizontalScroll {

    static var basic: some View {
        content
            .background(Color.whiteDarker)
    }

    @ViewBuilder static var content: some View {
        simpleSmallRatio
        simpleCustom
        ratioWidthIntrinsicHeight
        smallRatioWidthIntrinsicHeight
        fullWidthIntrinsicHeight
        intrinsic
        custom
        pagination
    }

    static var simpleSmallRatio: some View {
        VStack(spacing: .large) {
            HorizontalScroll(spacing: .large, itemWidth: .ratio(1.01)) {
                Color.greenLight.frame(height: 10)
                Color.greenLight.frame(height: 30)
                Color.greenLight.frame(height: 50)
            }
            .border(Color.cloudDark)

            HorizontalScroll(spacing: .large, itemWidth: .ratio(1)) {
                Color.greenLight.frame(height: 10)
                Color.greenLight.frame(height: 30)
                Color.greenLight.frame(height: 50)
            }
            .border(Color.cloudDark)

            HorizontalScroll(spacing: .large, itemWidth: .ratio(0.5)) {
                Color.greenLight.frame(height: 10)
                Color.greenLight.frame(height: 30)
                Color.greenLight.frame(height: 50)
            }
            .border(Color.cloudDark)

            HorizontalScroll(spacing: .large, itemWidth: .ratio(0.33)) {
                Color.greenLight.frame(height: 10)
                Color.greenLight.frame(height: 30)
                Color.greenLight.frame(height: 50)
                Color.greenLight.frame(height: 20)
            }
            .border(Color.cloudDark)
        }
        .background(Color.redLight.frame(width: 1).padding(.leading, .xSmall), alignment: .leading)
        .background(Color.redLight.frame(width: 1).padding(.trailing, .xSmall), alignment: .trailing)
        .previewDisplayName("W - ratios, H - intrinsic")
    }

    static var simpleCustom: some View {
        HorizontalScroll(itemWidth: .custom(30), itemHeight: .custom(30)) {
            Color.greenLight
            Color.greenLight
            Color.greenLight
        }
        .border(Color.cloudDark)
        .previewDisplayName("W - custom, H - custom")
    }

    static var ratioWidthIntrinsicHeight: some View {
        HorizontalScroll {
            intrinsicContent

            intrinsicContent {
                Color.greenLight
                    .frame(width: 100, height: 150)
            }

            intrinsicContent
        }
        .border(Color.cloudDark)
        .previewDisplayName("W - ratio, H - intrinsic")
    }

    static var smallRatioWidthIntrinsicHeight: some View {
        HorizontalScroll(itemWidth: .ratio(0.3), itemHeight: .intrinsic) {
            intrinsicContent {
                VStack(alignment: .leading) {
                    Text("Spacer")
                    Spacer()
                    contentPlaceholder
                }
            }

            intrinsicContent {
                Color.greenLight
                    .frame(height: 150)
            }

            intrinsicContent
        }
        .border(Color.cloudDark)
        .previewDisplayName("W - small ratio, H - intrinsic")
    }

    static var fullWidthIntrinsicHeight: some View {
        HorizontalScroll(itemWidth: .ratio(1), itemHeight: .intrinsic) {
            intrinsicContent

            intrinsicContent {
                Color.greenLight
                    .frame(height: 150)
            }

            intrinsicContent
        }
        .border(Color.cloudDark)
        .previewDisplayName("W - full, H - intrinsic")
    }

    static var intrinsic: some View {
        HorizontalScroll(itemWidth: .intrinsic, itemHeight: .intrinsic) {
            intrinsicContent

            intrinsicContent {
                Color.greenLight
                    .frame(width: 100, height: 150)
            }

            intrinsicContent
        }
        .previewDisplayName("W - intrinsic, H - intrinsic")
    }

    static var custom: some View {
        HorizontalScroll(itemWidth: .custom(100), itemHeight: .custom(130)) {
            intrinsicContent {
                Spacer()
                Color.greenLight
            }

            intrinsicContent {
                Color.greenLight
                Spacer()
                Text("Footer")
            }

            intrinsicContent {
                Text("No Spacer")
            }
        }
        .border(Color.cloudDark)
        .previewDisplayName("W - custom, H - custom")
    }

    static let scrollUnitPoint = UnitPoint(x: 10, y: 0)

    @ViewBuilder static var pagination: some View {
        if #available(iOS 14, *) {
            ScrollViewReader { scrollProxy in
                VStack(spacing: .medium) {
                    HorizontalScroll {
                        intrinsicContent {
                            Spacer()
                            Color.greenLight
                        }
                        .id(1)

                        intrinsicContent {
                            Color.greenLight
                            Spacer()
                            Text("Footer")
                        }
                        .id(2)

                        intrinsicContent {
                            Text("No Spacer")
                        }
                        .id(3)
                    }
                    .border(Color.cloudDark)

                    HStack {
                        Button("Scroll to 1", size: .small) {
                            withAnimation {
                                scrollProxy.scrollTo(1, anchor: .topLeading)
                            }
                        }
                        Button("Scroll to 2", size: .small) {
                            withAnimation {
                                scrollProxy.scrollTo(2, anchor: .topLeading)
                            }
                        }
                        Button("Scroll to 3", size: .small) {
                            withAnimation {
                                scrollProxy.scrollTo(3, anchor: .topLeading)
                            }
                        }
                    }
                    .padding(.medium)
                }
            }

        } else {
            Text("Pagination support only for iOS >= 14")
        }
    }

    static var intrinsicContent: some View {
        intrinsicContent {
            contentPlaceholder
        }
    }

    static func intrinsicContent<Content>(@ViewBuilder content: () -> Content) -> some View where Content: View {
        VStack(alignment: .leading) {
            Text("Intrinsic")
            content()
        }
        .border(Color.cloudNormal)
    }
}

struct StorybookHorizontalScrollPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookHorizontalScroll.basic
        }
    }
}
