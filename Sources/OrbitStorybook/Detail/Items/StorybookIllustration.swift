import SwiftUI
import Orbit

struct StorybookIllustration {

    static var basic: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Card("Default", showBorder: false) {
                Illustration(.womanWithPhone)
                    .border(.cloudNormal)
            }

            Card("MaxHeight = 80", showBorder: false) {
                VStack {
                    Text("Frame - Center (default)")
                    Illustration(.womanWithPhone, layout: .frame(maxHeight: 80))
                        .border(.cloudNormal)
                }

                VStack {
                    Text("Frame - Leading")
                    Illustration(.womanWithPhone, layout: .frame(maxHeight: 80, alignment: .leading))
                        .border(.cloudNormal)
                }

                VStack {
                    Text("Frame - Trailing")
                    Illustration(.womanWithPhone, layout: .frame(maxHeight: 80, alignment: .trailing))
                        .border(.cloudNormal)
                }

                VStack {
                    Text("Resizeable")
                    Illustration(.womanWithPhone, layout: .resizeable)
                        .frame(height: 80)
                        .border(.cloudNormal)
                }
            }

            Card("MaxHeight = 30", showBorder: false) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Leading")
                        Illustration(.womanWithPhone, layout: .frame(maxHeight: 30, alignment: .leading))
                            .border(.cloudNormal)
                    }

                    VStack(alignment: .leading) {
                        Text("Center")
                        Illustration(.womanWithPhone, layout: .frame(maxHeight: 30))
                            .border(.cloudNormal)
                    }

                    VStack(alignment: .leading) {
                        Text("Resizeable")
                        Illustration(.womanWithPhone, layout: .resizeable)
                            .frame(height: 30)
                            .border(.cloudNormal)
                    }

                    VStack(alignment: .leading) {
                        Text("Trailing")
                        Illustration(.womanWithPhone, layout: .frame(maxHeight: 30, alignment: .trailing))
                            .border(.cloudNormal)
                    }
                }
            }

            Card("Resizeable", showBorder: false) {
                HStack(alignment: .top, spacing: .medium) {
                    VStack(alignment: .leading) {
                        Text("Width = 80")
                        Illustration(.womanWithPhone, layout: .resizeable)
                            .frame(width: 80)
                            .border(.cloudNormal)
                    }

                    VStack(alignment: .leading) {
                        Text("Height = 80")
                        Illustration(.womanWithPhone, layout: .resizeable)
                            .frame(height: 80)
                            .border(.cloudNormal)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Width = 80, Height = 80")
                    Illustration(.womanWithPhone, layout: .resizeable)
                        .frame(width: 80, height: 80)
                        .border(.cloudNormal)
                }
            }
        }
        .textSize(.small)
        .previewDisplayName()
    }
}

struct StorybookIllustrationPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookIllustration.basic
        }
    }
}
