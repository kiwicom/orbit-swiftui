import SwiftUI
import Orbit

struct StorybookBasicColors: View {

    var body: some View {
        VStack(spacing: 0) {
            ColorCard(title: "White") {
                ColorContent(color: &.whiteLighter, uiColor: &.whiteLighter, label: "White", variant: "lighter (dark-mode)")
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.whiteNormal, uiColor: &.whiteNormal, label: "White")
                    ColorContent(color: &.whiteHover, uiColor: &.whiteHover, label: "White", variant: "hover")
                    ColorContent(color: &.whiteActive, uiColor: &.whiteActive, label: "White", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                ColorContent(color: &.whiteDarker, uiColor: &.whiteDarker, label: "White", variant: "darker (dark-mode)")
                    .fixedSize(horizontal: false, vertical: true)
            }

            ColorCard(title: "Cloud") {
                HStack(spacing: 0) {
                    ColorContent(color: &.cloudLight, uiColor: &.cloudLight, label: "Cloud Light")
                    ColorContent(color: &.cloudLightHover, uiColor: &.cloudLightHover, label: "Cloud Light", variant: "hover")
                    ColorContent(color: &.cloudLightActive, uiColor: &.cloudLightActive, label: "Cloud Light", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.cloudNormal, uiColor: &.cloudNormal, label: "Cloud Normal")
                    ColorContent(color: &.cloudNormalHover, uiColor: &.cloudNormalHover, label: "Cloud Normal", variant: "hover")
                    ColorContent(color: &.cloudNormalActive, uiColor: &.cloudNormalActive, label: "Cloud Normal", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.cloudDark, uiColor: &.cloudDark, label: "Cloud Dark")
                    ColorContent(color: &.cloudDarkHover, uiColor: &.cloudDarkHover, label: "Cloud Dark", variant: "hover")
                    ColorContent(color: &.cloudDarkActive, uiColor: &.cloudDarkActive, label: "Cloud Dark", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)
            }

            ColorCard(title: "Ink") {
                HStack(spacing: 0) {
                    ColorContent(color: &.inkLight, uiColor: &.inkLight, label: "Ink Light")
                    ColorContent(color: &.inkLightHover, uiColor: &.inkLightHover, label: "Ink Light", variant: "hover")
                    ColorContent(color: &.inkLightActive, uiColor: &.inkLightActive, label: "Ink Light", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.inkNormal, uiColor: &.inkNormal, label: "Ink Normal")
                    ColorContent(color: &.inkNormalHover, uiColor: &.inkNormalHover, label: "Ink Normal", variant: "hover")
                    ColorContent(color: &.inkNormalActive, uiColor: &.inkNormalActive, label: "Ink Normal", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.inkDark, uiColor: &.inkDark, label: "Ink Dark")
                    ColorContent(color: &.inkDarkHover, uiColor: &.inkDarkHover, label: "Ink Dark", variant: "hover")
                    ColorContent(color: &.inkDarkActive, uiColor: &.inkDarkActive, label: "Ink Dark", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct StorybookProductColors: View {

    var body: some View {
        VStack(spacing: 0) {
            ColorCard(title: "Product") {
                HStack(spacing: 0) {
                    ColorContent(color: &.productLight, uiColor: &.productLight, label: "Product Light")
                    ColorContent(color: &.productLightHover, uiColor: &.productLightHover, label: "Product Light", variant: "hover")
                    ColorContent(color: &.productLightActive, uiColor: &.productLightActive, label: "Product Light", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.productNormal, uiColor: &.productNormal, label: "Product Normal")
                    ColorContent(color: &.productNormalHover, uiColor: &.productNormalHover, label: "Product Normal", variant: "hover")
                    ColorContent(color: &.productNormalActive, uiColor: &.productNormalActive, label: "Product Normal", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.productDark, uiColor: &.productDark, label: "Product Dark")
                    ColorContent(color: &.productDarkHover, uiColor: &.productDarkHover, label: "Product Dark", variant: "hover")
                    ColorContent(color: &.productDarkActive, uiColor: &.productDarkActive, label: "Product Dark", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                ColorContent(color: &.productDarker, uiColor: &.productDarker, label: "Product Darker")
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct StorybookStatusColors: View {

    var body: some View {
        VStack(spacing: 0) {
            ColorCard(title: "Blue") {
                HStack(spacing: 0) {
                    ColorContent(color: &.blueLight, uiColor: &.blueLight, label: "Blue Light")
                    ColorContent(color: &.blueLightHover, uiColor: &.blueLightHover, label: "Blue Light", variant: "hover")
                    ColorContent(color: &.blueLightActive, uiColor: &.blueLightActive, label: "Blue Light", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.blueNormal, uiColor: &.blueNormal, label: "Blue Normal")
                    ColorContent(color: &.blueNormalHover, uiColor: &.blueNormalHover, label: "Blue Normal", variant: "hover")
                    ColorContent(color: &.blueNormalActive, uiColor: &.blueNormalActive, label: "Blue Normal", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.blueDark, uiColor: &.blueDark, label: "Blue Dark")
                    ColorContent(color: &.blueDarkHover, uiColor: &.blueDarkHover, label: "Blue Dark", variant: "hover")
                    ColorContent(color: &.blueDarkActive, uiColor: &.blueDarkActive, label: "Blue Dark", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                ColorContent(color: &.blueDarker, uiColor: &.blueDarker, label: "Blue Darker")
                    .fixedSize(horizontal: false, vertical: true)
            }

            ColorCard(title: "Red") {
                HStack(spacing: 0) {
                    ColorContent(color: &.redLight, uiColor: &.redLight, label: "Red Light")
                    ColorContent(color: &.redLightHover, uiColor: &.redLightHover, label: "Red Light", variant: "hover")
                    ColorContent(color: &.redLightActive, uiColor: &.redLightActive, label: "Red Light", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.redNormal, uiColor: &.redNormal, label: "Red Normal")
                    ColorContent(color: &.redNormalHover, uiColor: &.redNormalHover, label: "Red Normal", variant: "hover")
                    ColorContent(color: &.redNormalActive, uiColor: &.redNormalActive, label: "Red Normal", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.redDark, uiColor: &.redDark, label: "Red Dark")
                    ColorContent(color: &.redDarkHover, uiColor: &.redDarkHover, label: "Red Dark", variant: "hover")
                    ColorContent(color: &.redDarkActive, uiColor: &.redDarkActive, label: "Red Dark", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                ColorContent(color: &.redDarker, uiColor: &.redDarker, label: "Red Darker")
                    .fixedSize(horizontal: false, vertical: true)
            }

            ColorCard(title: "Green") {
                HStack(spacing: 0) {
                    ColorContent(color: &.greenLight, uiColor: &.greenLight, label: "Green Light")
                    ColorContent(color: &.greenLightHover, uiColor: &.greenLightHover, label: "Green Light", variant: "hover")
                    ColorContent(color: &.greenLightActive, uiColor: &.greenLightActive, label: "Green Light", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.greenNormal, uiColor: &.greenNormal, label: "Green Normal")
                    ColorContent(color: &.greenNormalHover, uiColor: &.greenNormalHover, label: "Green Normal", variant: "hover")
                    ColorContent(color: &.greenNormalActive, uiColor: &.greenNormalActive, label: "Green Normal", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.greenDark, uiColor: &.greenDark, label: "Green Dark")
                    ColorContent(color: &.greenDarkHover, uiColor: &.greenDarkHover, label: "Green Dark", variant: "hover")
                    ColorContent(color: &.greenDarkActive, uiColor: &.greenDarkActive, label: "Green Dark", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                ColorContent(color: &.greenDarker, uiColor: &.greenDarker, label: "Green Darker")
                    .fixedSize(horizontal: false, vertical: true)
            }

            ColorCard(title: "Orange") {
                HStack(spacing: 0) {
                    ColorContent(color: &.orangeLight, uiColor: &.orangeLight, label: "Orange Light")
                    ColorContent(color: &.orangeLightHover, uiColor: &.orangeLightHover, label: "Orange Light", variant: "hover")
                    ColorContent(color: &.orangeLightActive, uiColor: &.orangeLightActive, label: "Orange Light", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.orangeNormal, uiColor: &.orangeNormal, label: "Orange Normal")
                    ColorContent(color: &.orangeNormalHover, uiColor: &.orangeNormalHover, label: "Orange Normal", variant: "hover")
                    ColorContent(color: &.orangeNormalActive, uiColor: &.orangeNormalActive, label: "Orange Normal", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 0) {
                    ColorContent(color: &.orangeDark, uiColor: &.orangeDark, label: "Orange Dark")
                    ColorContent(color: &.orangeDarkHover, uiColor: &.orangeDarkHover, label: "Orange Dark", variant: "hover")
                    ColorContent(color: &.orangeDarkActive, uiColor: &.orangeDarkActive, label: "Orange Dark", variant: "active")
                }
                .fixedSize(horizontal: false, vertical: true)

                ColorContent(color: &.orangeDarker, uiColor: &.orangeDarker, label: "Orange Darker")
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct StorybookBundleColors: View {

    var body: some View {
        ColorCard(title: "Bundle") {
            HStack(spacing: 0) {
                ColorGradientContent(gradient: .bundleBasic, label: "Bundle Basic")
                ColorContent(color: &.bundleBasicStart, uiColor: &.bundleBasicStart, label: "Bundle Basic", variant: "start")
                ColorContent(color: &.bundleBasicEnd, uiColor: &.bundleBasicEnd, label: "Bundle Basic", variant: "end")
            }
            .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 0) {
                ColorGradientContent(gradient: .bundleMedium, label: "Bundle Medium")
                ColorContent(color: &.bundleMediumStart, uiColor: &.bundleMediumStart, label: "Bundle Medium", variant: "start")
                ColorContent(color: &.bundleMediumEnd, uiColor: &.bundleMediumEnd, label: "Bundle Medium", variant: "end")
            }
            .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 0) {
                ColorGradientContent(gradient: .bundleTop, label: "Bundle Top")
                ColorContent(color: &.bundleTopStart, uiColor: &.bundleTopStart, label: "Bundle Top", variant: "start")
                ColorContent(color: &.bundleTopEnd, uiColor: &.bundleTopEnd, label: "Bundle Top", variant: "end")
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct ColorCard<Content: View>: View {

    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        Card(
            title,
            showBorder: false,
            titleStyle: .title6,
            backgroundColor: .clear,
            contentLayout: .custom(padding: .xSmall, spacing: 0)
        ) {
            VStack(spacing: .xxxSmall) {
                content
            }
            .padding(.bottom, .large)
            .compositingGroup()
            .elevation(.level2)
        }
    }
}

private struct ColorContent: View {

    let color: UnsafeMutablePointer<Color>
    let uiColor: UnsafeMutablePointer<UIColor>
    let label: String
    var variant: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            color.pointee
                .frame(maxWidth: .infinity)
                .frame(height: 88)
                .overlay(
                    VStack(alignment: .trailing, spacing: 0) {
                        SwiftUI.Text("\(hexStringFromColor(uiColor.pointee))")
                            .font(.system(.caption, design: .monospaced).monospacedDigit())
                            .fontWeight(.medium)
                            .foregroundColor(uiColor.pointee.brightness > 0.6 ? .inkDark : .whiteNormal)

                        Spacer(minLength: .medium)

                        if #available(iOS 14.0, *) {
                            ColorPicker(
                                selection: Binding<Color>(
                                    get: { color.pointee },
                                    set: { newColor in
                                        color.pointee = newColor
                                        uiColor.pointee = UIColor(newColor)
                                    }
                                )
                            ) {
                                EmptyView()
                            }
                        }
                    }
                    .padding(.horizontal, .small)
                    .padding(.vertical, .xSmall)
                    ,
                    alignment: .trailing
                )

            Group {
                Text(label, size: .small, color: .custom(.black), weight: .medium)
                + Text(optionalText, size: .small, color: .custom(.gray))
            }
            .padding(.small)

            Spacer(minLength: 0)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BorderRadius.default))
        .padding(.xSmall)
    }

    var optionalText: String {
        variant.isEmpty ? "" : "\n:\(variant)"
    }
}

private struct ColorGradientContent: View {

    let gradient: Orbit.Gradient
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            gradient.background
                .frame(height: 88)

            Group {
                Text(label, size: .small, color: .custom(.black), weight: .medium)
                + Text("\n:gradient", size: .small, color: .custom(.gray))
            }
            .padding(.small)

            Spacer(minLength: 0)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BorderRadius.default))
        .elevation(.level2)
        .padding(.xSmall)
    }
}

private extension UIColor {

    var brightness: CGFloat {
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getWhite(&brightness, alpha: &alpha)

        if UITraitCollection.current.userInterfaceStyle == .dark {
            return 1 - brightness
        } else {
            return brightness
        }
    }
}

private func hexStringFromColor(_ color: UIColor) -> String {
    let components = color.cgColor.components
    let r: CGFloat = components?[0] ?? 0.0
    let g: CGFloat = components?[1] ?? 0.0
    let b: CGFloat = components?[2] ?? 0.0

    let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    print(hexString)
    return hexString
 }

private extension Color {

    var hex: String {
        let uic: UIColor

        if #available(iOS 14.0, *) {
            uic = UIColor(self)
        } else {
            return ""
        }

        guard let components = uic.cgColor.components, components.count >= 3 else {
            return ""
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

struct StorybookColorsPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookBasicColors()
                .previewDisplayName("Basic")
            StorybookStatusColors()
                .previewDisplayName("Status")
            StorybookProductColors()
                .previewDisplayName("Product")
            StorybookBundleColors()
                .previewDisplayName("Bundle")
        }
        .previewLayout(.sizeThatFits)
    }
}
