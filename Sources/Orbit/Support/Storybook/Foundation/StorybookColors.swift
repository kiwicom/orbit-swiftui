import SwiftUI

struct StorybookColors {

    @ViewBuilder static var storybook: some View {
        VStack(spacing: .xLarge) {
            product
            white
            cloud
            ink
        }
    }

    @ViewBuilder static var storybookStatus: some View {
        VStack(spacing: .xLarge) {
            green
            red
            orange
            blue
        }
    }

    @ViewBuilder static var storybookGradient: some View {
        VStack(spacing: .xLarge) {
            bundle
        }
    }

    @ViewBuilder static var product: some View {
        card("Product") {
            HStack(spacing: 0) {
                color(&.productLight, uiColor: &.productLight, label: "Product Light")
                color(&.productLightHover, uiColor: &.productLightHover, label: "Product Light: hover")
                color(&.productLightActive, uiColor: &.productLightActive, label: "Product Light: active")
            }
            HStack(spacing: 0) {
                color(&.productNormal, uiColor: &.productNormal, label: "Product Normal")
                color(&.productNormalHover, uiColor: &.productNormalHover, label: "Product Normal: hover")
                color(&.productNormalActive, uiColor: &.productNormalActive, label: "Product Normal: active")
            }
            HStack(spacing: 0) {
                color(&.productDark, uiColor: &.productDark, label: "Product Dark")
                color(&.productDarkHover, uiColor: &.productDarkHover, label: "Product Dark: hover")
                color(&.productDarkActive, uiColor: &.productDarkActive, label: "Product Dark: active")
            }
            
            color(&.productDarker, uiColor: &.productDarker, label: "Product Darker")
        }
    }

    @ViewBuilder static var white: some View {
        card("White") {
            color(&.whiteLighter, uiColor: &.whiteLighter, label: "White Lighter")

            HStack(spacing: 0) {
                color(&.whiteNormal, uiColor: &.whiteNormal, label: "White")
                color(&.whiteHover, uiColor: &.whiteHover, label: "White: hover")
                color(&.whiteActive, uiColor: &.whiteActive, label: "White: active")
            }

            color(&.whiteDarker, uiColor: &.whiteDarker, label: "White Darker")
        }
    }

    @ViewBuilder static var cloud: some View {
        card("Cloud") {
            HStack(spacing: 0) {
                color(&.cloudLight, uiColor: &.cloudLight, label: "Cloud Light")
                color(&.cloudLightHover, uiColor: &.cloudLightHover, label: "Cloud Light: hover")
                color(&.cloudLightActive, uiColor: &.cloudLightActive, label: "Cloud Light: active")
            }
            HStack(spacing: 0) {
                color(&.cloudNormal, uiColor: &.cloudNormal, label: "Cloud Normal")
                color(&.cloudNormalHover, uiColor: &.cloudNormalHover, label: "Cloud Normal: hover")
                color(&.cloudNormalActive, uiColor: &.cloudNormalActive, label: "Cloud Normal: active")
            }
            HStack(spacing: 0) {
                color(&.cloudDark, uiColor: &.cloudDark, label: "Cloud Dark")
                color(&.cloudDarkHover, uiColor: &.cloudDarkHover, label: "Cloud Dark: hover")
                color(&.cloudDarkActive, uiColor: &.cloudDarkActive, label: "Cloud Dark: active")
            }
        }
    }

    @ViewBuilder static var ink: some View {
        card("Ink") {
            HStack(spacing: 0) {
                color(&.inkLight, uiColor: &.inkLight, label: "Ink Light")
                color(&.inkLightHover, uiColor: &.inkLightHover, label: "Ink Light: hover")
                color(&.inkLightActive, uiColor: &.inkLightActive, label: "Ink Light: active")
            }
            HStack(spacing: 0) {
                color(&.inkNormal, uiColor: &.inkNormal, label: "Ink Light")
                color(&.inkNormalHover, uiColor: &.inkNormalHover, label: "Ink Light: hover")
                color(&.inkNormalActive, uiColor: &.inkNormalActive, label: "Ink Light: active")
            }
            HStack(spacing: 0) {
                color(&.inkDark, uiColor: &.inkDark, label: "Ink Normal")
                color(&.inkDarkHover, uiColor: &.inkDarkHover, label: "Ink Normal: hover")
                color(&.inkDarkActive, uiColor: &.inkDarkActive, label: "Ink Normal: active")
            }
        }
    }

    @ViewBuilder static var green: some View {
        card("Green") {
            HStack(spacing: 0) {
                color(&.greenLight, uiColor: &.greenLight, label: "Green Light")
                color(&.greenLightHover, uiColor: &.greenLightHover, label: "Green Light: hover")
                color(&.greenLightActive, uiColor: &.greenLightActive, label: "Green Light: active")
            }
            HStack(spacing: 0) {
                color(&.greenNormal, uiColor: &.greenNormal, label: "Green Normal")
                color(&.greenNormalHover, uiColor: &.greenNormalHover, label: "Green Normal: hover")
                color(&.greenNormalActive, uiColor: &.greenNormalActive, label: "Green Normal: active")
            }
            HStack(spacing: 0) {
                color(&.greenDark, uiColor: &.greenDark, label: "Green Dark")
                color(&.greenDarkHover, uiColor: &.greenDarkHover, label: "Green Dark: hover")
                color(&.greenDarkActive, uiColor: &.greenDarkActive, label: "Green Dark: active")
            }
        }
    }

    @ViewBuilder static var orange: some View {
        card("Orange") {
            HStack(spacing: 0) {
                color(&.orangeLight, uiColor: &.orangeLight, label: "Orange Light")
                color(&.orangeLightHover, uiColor: &.orangeLightHover, label: "Orange Light: hover")
                color(&.orangeLightActive, uiColor: &.orangeLightActive, label: "Orange Light: active")
            }
            HStack(spacing: 0) {
                color(&.orangeNormal, uiColor: &.orangeNormal, label: "Orange Normal")
                color(&.orangeNormalHover, uiColor: &.orangeNormalHover, label: "Orange Normal: hover")
                color(&.orangeNormalActive, uiColor: &.orangeNormalActive, label: "Orange Normal: active")
            }
            HStack(spacing: 0) {
                color(&.orangeDark, uiColor: &.orangeDark, label: "Orange Dark")
                color(&.orangeDarkHover, uiColor: &.orangeDarkHover, label: "Orange Dark: hover")
                color(&.orangeDarkActive, uiColor: &.orangeDarkActive, label: "Orange Dark: active")
            }
        }
    }

    @ViewBuilder static var red: some View {
        card("Red") {
            HStack(spacing: 0) {
                color(&.redLight, uiColor: &.redLight, label: "Red Light")
                color(&.redLightHover, uiColor: &.redLightHover, label: "Red Light: hover")
                color(&.redLightActive, uiColor: &.redLightActive, label: "Red Light: active")
            }
            HStack(spacing: 0) {
                color(&.redNormal, uiColor: &.redNormal, label: "Red Normal")
                color(&.redNormalHover, uiColor: &.redNormalHover, label: "Red Normal: hover")
                color(&.redNormalActive, uiColor: &.redNormalActive, label: "Red Normal: active")
            }
            HStack(spacing: 0) {
                color(&.redDark, uiColor: &.redDark, label: "Red Dark")
                color(&.redDarkHover, uiColor: &.redDarkHover, label: "Red Dark: hover")
                color(&.redDarkActive, uiColor: &.redDarkActive, label: "Red Dark: active")
            }
        }
    }

    @ViewBuilder static var blue: some View {
        card("Blue") {
            HStack(spacing: 0) {
                color(&.blueLight, uiColor: &.blueLight, label: "Blue Light")
                color(&.blueLightHover, uiColor: &.blueLightHover, label: "Blue Light: hover")
                color(&.blueLightActive, uiColor: &.blueLightActive, label: "Blue Light: active")
            }
            HStack(spacing: 0) {
                color(&.blueNormal, uiColor: &.blueNormal, label: "Blue Normal")
                color(&.blueNormalHover, uiColor: &.blueNormalHover, label: "Blue Normal: hover")
                color(&.blueNormalActive, uiColor: &.blueNormalActive, label: "Blue Normal: active")
            }
            HStack(spacing: 0) {
                color(&.blueDark, uiColor: &.blueDark, label: "Blue Dark")
                color(&.blueDarkHover, uiColor: &.blueDarkHover, label: "Blue Dark: hover")
                color(&.blueDarkActive, uiColor: &.blueDarkActive, label: "Blue Dark: active")
            }
        }
    }

    @ViewBuilder static var bundle: some View {
        card("Bundle") {
            VStack(spacing: 0) {
                gradient(.bundleBasic, label: "Bundle Basic")
                HStack(spacing: 0) {
                    color(&.bundleBasicStart, uiColor: &.bundleBasicStart, label: "Bundle Basic: start")
                    color(&.bundleBasicEnd, uiColor: &.bundleBasicEnd, label: "Bundle Basic: end")
                }
            }
            VStack(spacing: 0) {
                gradient(.bundleMedium, label: "Bundle Medium")
                HStack(spacing: 0) {
                    color(&.bundleMediumStart, uiColor: &.bundleMediumStart, label: "Bundle Medium: start")
                    color(&.bundleMediumEnd, uiColor: &.bundleMediumEnd, label: "Bundle Medium: end")
                }
            }
            VStack(spacing: 0) {
                gradient(.bundleTop, label: "Bundle Top")
                HStack(spacing: 0) {
                    color(&.bundleTopStart, uiColor: &.bundleTopStart, label: "Bundle Top: start")
                    color(&.bundleTopEnd, uiColor: &.bundleTopEnd, label: "Bundle Top: end")
                }
            }
        }
    }

    @ViewBuilder static func color(
        _ color: UnsafeMutablePointer<Color>,
        uiColor: UnsafeMutablePointer<UIColor>,
        label: String
    ) -> some View {
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
                colorContent(uiColor.pointee, label: label)
            }
            .padding(.trailing, .small)
            .background(color.pointee)
        } else {
            colorContent(uiColor.pointee, label: label)
        }
    }

    @ViewBuilder static func colorContent(_ color: UIColor, label: String) -> some View {
        if let color = color.copy() as? UIColor {
            Color(color)
                .frame(height: 80)
                .overlay(
                    Text(
                        label,
                        size: .small,
                        color: .custom(color.brightness > 0.6 ? .inkDark : .whiteNormal),
                        weight: .medium
                    )
                    .padding(.horizontal, .medium)
                    .padding(.vertical, .small),
                    alignment: .topLeading
                )
        }
    }

    @ViewBuilder static func gradient(_ gradient: Gradient, label: String) -> some View {
        gradient.background
            .frame(height: 80)
            .overlay(
                Text(
                    label,
                    size: .small,
                    color: .white,
                    weight: .medium
                )
                .padding(.horizontal, .medium)
                .padding(.vertical, .small),
                alignment: .topLeading
            )
    }

    @ViewBuilder static func card<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        Card(title, showBorder: false, backgroundColor: .clear, contentLayout: .fill) {
            VStack(spacing: 0) {
                content()
            }
        }
    }
}

extension UIColor {

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

struct StorybookColorsPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            StorybookColors.storybook
            StorybookColors.storybookStatus
            StorybookColors.storybookGradient
        }
        .previewLayout(.sizeThatFits)
    }
}
