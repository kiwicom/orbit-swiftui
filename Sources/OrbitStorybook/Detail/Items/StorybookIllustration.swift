import SwiftUI
import Orbit

struct StorybookIllustration {

    static var basic: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Card("Default", showBorder: false) {
                Illustration(.womanWithPhone)
                    .border(Color.cloudNormal)
            }

            Card("MaxHeight = 80", showBorder: false) {
                VStack {
                    Text("Frame - Center (default)", size: .small)
                    Illustration(.womanWithPhone, layout: .frame(maxHeight: 80))
                        .border(Color.cloudNormal)
                }

                VStack {
                    Text("Frame - Leading", size: .small)
                    Illustration(.womanWithPhone, layout: .frame(maxHeight: 80, alignment: .leading))
                        .border(Color.cloudNormal)
                }

                VStack {
                    Text("Frame - Trailing", size: .small)
                    Illustration(.womanWithPhone, layout: .frame(maxHeight: 80, alignment: .trailing))
                        .border(Color.cloudNormal)
                }

                VStack {
                    Text("Resizeable", size: .small)
                    Illustration(.womanWithPhone, layout: .resizeable)
                        .frame(height: 80)
                        .border(Color.cloudNormal)
                }
            }

            Card("MaxHeight = 30", showBorder: false) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Leading", size: .small)
                        Illustration(.womanWithPhone, layout: .frame(maxHeight: 30, alignment: .leading))
                            .border(Color.cloudNormal)
                    }

                    VStack(alignment: .leading) {
                        Text("Center", size: .small)
                        Illustration(.womanWithPhone, layout: .frame(maxHeight: 30))
                            .border(Color.cloudNormal)
                    }

                    VStack(alignment: .leading) {
                        Text("Resizeable", size: .small)
                        Illustration(.womanWithPhone, layout: .resizeable)
                            .frame(height: 30)
                            .border(Color.cloudNormal)
                    }

                    VStack(alignment: .leading) {
                        Text("Trailing", size: .small)
                        Illustration(.womanWithPhone, layout: .frame(maxHeight: 30, alignment: .trailing))
                            .border(Color.cloudNormal)
                    }
                }
            }

            Card("Resizeable", showBorder: false) {
                HStack(alignment: .top, spacing: .medium) {
                    VStack(alignment: .leading) {
                        Text("Width = 80", size: .small)
                        Illustration(.womanWithPhone, layout: .resizeable)
                            .frame(width: 80)
                            .border(Color.cloudNormal)
                    }

                    VStack(alignment: .leading) {
                        Text("Height = 80", size: .small)
                        Illustration(.womanWithPhone, layout: .resizeable)
                            .frame(height: 80)
                            .border(Color.cloudNormal)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Width = 80, Height = 80", size: .small)
                    Illustration(.womanWithPhone, layout: .resizeable)
                        .frame(width: 80, height: 80)
                        .border(Color.cloudNormal)
                }
            }
        }
        .previewDisplayName("Mixed sizes")
    }
}

struct StorybookIllustrationPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookIllustration.basic
        }
    }
}
