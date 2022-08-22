import SwiftUI

/// An icon matching Orbit name.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/icon/)
public struct Icon: View {

    public static let sfSymbolToOrbitSizeRatio: CGFloat = 0.75
    public static let averageIconContentPadding: CGFloat = .xxxSmall

    @Environment(\.sizeCategory) var sizeCategory

    let content: Content
    let size: Size

    public var body: some View {
        if content.isEmpty == false {
            iconContent
                .alignmentGuide(.firstTextBaseline) { dimensions in
                    size.textBaselineAlignmentGuide(sizeCategory: sizeCategory, height: dimensions.height)
                }
                .alignmentGuide(.lastTextBaseline) { dimensions in
                    size.textBaselineAlignmentGuide(sizeCategory: sizeCategory, height: dimensions.height)
                }
        }
    }

    @ViewBuilder var iconContent: some View {
        switch content {
            case .symbol(let symbol, let color?):
                SwiftUI.Text(verbatim: symbol.value)
                    .foregroundColor(color)
                    .font(.orbitIcon(size: size.value, style: size.textStyle))
                    .accessibility(label: SwiftUI.Text(String(describing: symbol)))
            case .symbol(let symbol, nil):
                SwiftUI.Text(verbatim: symbol.value)
                    // foregroundColor(nil) prevents further overrides
                    .font(.orbitIcon(size: size.value, style: size.textStyle))
                    .accessibility(label: SwiftUI.Text(String(describing: symbol)))
            case .image(let image, let mode):
                image
                    .resizable()
                    .aspectRatio(contentMode: mode)
                    .frame(width: size.value, height: size.value * sizeCategory.ratio)
                    .accessibility(hidden: true)
            case .countryFlag(let countryCode):
                CountryFlag(countryCode, size: size)
            case .sfSymbol(let systemName, let color?):
                Image(systemName: systemName)
                    .foregroundColor(color)
                    .font(.system(size: size.value * Self.sfSymbolToOrbitSizeRatio * sizeCategory.ratio))
            case .sfSymbol(let systemName, nil):
                Image(systemName: systemName)
                    // foregroundColor(nil) prevents further overrides
                    .font(.system(size: size.value * Self.sfSymbolToOrbitSizeRatio * sizeCategory.ratio))
        }
    }

    @available(iOS 14.0, *)
    func textRepresentation(sizeCategory: ContentSizeCategory) -> SwiftUI.Text {
        switch content {
            case .symbol(let symbol, let color?):
                return SwiftUI.Text(verbatim: symbol.value)
                    .baselineOffset(-size.baselineOffset(sizeCategory: sizeCategory))
                    .foregroundColor(color)
                    .font(.orbitIcon(size: size.value, style: size.textStyle))
            case .symbol(let symbol, nil):
                return SwiftUI.Text(verbatim: symbol.value)
                    .baselineOffset(-size.baselineOffset(sizeCategory: sizeCategory))
                    // foregroundColor(nil) prevents further overrides
                    .font(.orbitIcon(size: size.value, style: size.textStyle))
            case .image(let image, _):
                return SwiftUI.Text(image.resizable())
            case .countryFlag(let countryCode):
                return SwiftUI.Text(SwiftUI.Image(countryCode, bundle: .current).resizable())
            case .sfSymbol(let systemName, let color?):
                return SwiftUI.Text(Image(systemName: systemName)).foregroundColor(color)
                    .font(.system(size: size.value * Self.sfSymbolToOrbitSizeRatio * sizeCategory.ratio))
            case .sfSymbol(let systemName, nil):
                return SwiftUI.Text(Image(systemName: systemName))
                    .font(.system(size: size.value * Self.sfSymbolToOrbitSizeRatio * sizeCategory.ratio))
        }
    }

    func textRepresentationFallback(sizeCategory: ContentSizeCategory) -> SwiftUI.Text? {
        switch content {
            case .symbol(let symbol, let color?):
                return SwiftUI.Text(verbatim: symbol.value)
                    .baselineOffset(-size.baselineOffset(sizeCategory: sizeCategory))
                    .foregroundColor(color)
                    .font(.orbitIcon(size: size.value, style: size.textStyle))
            case .symbol(let symbol, nil):
                return SwiftUI.Text(verbatim: symbol.value)
                    .baselineOffset(-size.baselineOffset(sizeCategory: sizeCategory))
                    // foregroundColor(nil) prevents further overrides
                    .font(.orbitIcon(size: size.value, style: size.textStyle))
            case .image, .countryFlag, .sfSymbol:
                assertionFailure(".image, .countryFlag, .sfSymbol as Text are only available in iOS 14.0 or newer")
                return nil
        }
    }
}

extension Icon: SwiftUITextRepresentable {
    public func asText(configuration: ContentSizeCategory) -> SwiftUI.Text? {
        if content.isEmpty == false {
            if #available(iOS 14.0, *) {
                return textRepresentation(sizeCategory: configuration)
            } else {
                return textRepresentationFallback(sizeCategory: configuration)
            }
        }

        return nil
    }
}

// MARK: - Inits
public extension Icon {
    
    /// Creates Orbit Icon component for provided icon content.
    ///
    /// - Parameters:
    ///     - content: Icon content. Can optionally include the color override.
    init(content: Icon.Content, size: Size = .normal) {
        self.content = content
        self.size = size
    }

    /// Creates Orbit Icon component for provided Orbit icon symbol with specified color.
    ///
    /// - Parameters:
    ///     - color: Icon color. Can be set to `nil` and specified later using `.foregroundColor()` modifier.
    init(_ symbol: Icon.Symbol, size: Size = .normal, color: Color? = .inkNormal) {
        self.init(
            content: .symbol(symbol, color: color),
            size: size
        )
    }
    
    /// Creates Orbit Icon component for provided Image.
    init(image: Image, size: Size = .normal) {
        self.init(
            content: .image(image),
            size: size
        )
    }
    
    /// Creates Orbit Icon component for provided country code.
    init(countryCode: String, size: Size = .normal) {
        self.init(
            content: .countryFlag(countryCode),
            size: size
        )
    }
    
    /// Creates Orbit Icon component for provided SF Symbol with specified color.
    ///
    /// - Parameters:
    ///     - color: SF Symbol color. Can be set to `nil` and specified later using `.foregroundColor()` modifier.
    init(sfSymbol: String, size: Size = .normal, color: Color? = .inkNormal) {
        self.init(
            content: .sfSymbol(sfSymbol, color: color),
            size: size
        )
    }
}

// MARK: - Types
public extension Icon {

    /// Defines content of an Icon for use in other components.
    /// An optional color can be provided. If not provided, color can be specified later, using `.foregroundColor()` modifier.
    ///
    /// Icon size in Orbit components is determined by enclosing component.
    enum Content: Equatable {
        /// Orbit icon symbol with optional overridable color.
        case symbol(Symbol, color: Color? = nil)
        /// Icon using custom Image with overridable size.
        case image(Image, mode: ContentMode = .fit)
        /// Orbit CountryFlag.
        case countryFlag(String)
        /// SwiftUI SF Symbol with optional overridable color.
        case sfSymbol(String, color: Color? = nil)

        public var isEmpty: Bool {
            switch self {
                case .symbol(let symbol, _):            return symbol == .none
                case .image:                            return false
                case .countryFlag(let countryCode):     return countryCode.isEmpty
                case .sfSymbol(let sfSymbol, _):        return sfSymbol.isEmpty
            }
        }
    }

    enum Size: Equatable {
        /// Size 16.
        case small
        /// Size 20.
        case normal
        /// Size 24.
        case large
        /// Size 28.
        case xLarge
        /// Size based on Font size.
        case fontSize(CGFloat)
        /// Size based on `Text` size.
        case text(Text.Size)
        /// Size based on `Heading` style.
        case heading(Heading.Style)
        /// Size based on `Label` title style.
        case label(Label.Style)
        /// Custom size
        case custom(CGFloat)
        
        public var value: CGFloat {
            switch self {
                case .small:                            return 16
                case .normal:                           return 20
                case .large:                            return 24
                case .xLarge:                           return 28
                case .fontSize(let size):               return round(size * 1.31)
                case .text(let size):                   return size.iconSize
                case .heading(let style):               return style.iconSize
                case .label(let style):                 return style.iconSize
                case .custom(let size):                 return size
            }
        }

        public var textStyle: Font.TextStyle {
            switch self {
                case .small:                            return Text.Size.small.textStyle
                case .normal:                           return Text.Size.normal.textStyle
                case .large:                            return Text.Size.large.textStyle
                case .xLarge:                           return Text.Size.xLarge.textStyle
                case .fontSize:                         return .body
                case .text(let size):                   return size.textStyle
                case .heading(let style):               return style.textStyle
                case .label(let style):                 return style.textStyle
                case .custom:                           return .body
            }
        }
        
        public static func == (lhs: Icon.Size, rhs: Icon.Size) -> Bool {
            lhs.value == rhs.value
        }

        /// Default text line height for icon size.
        public var textLineHeight: CGFloat {
            switch self {
                case .small:                            return Text.Size.small.iconSize
                case .normal:                           return Text.Size.normal.iconSize
                case .large:                            return Text.Size.large.iconSize
                case .xLarge:                           return Text.Size.xLarge.iconSize
                case .fontSize(let size):               return round(size * 1.31)
                case .text(let size):                   return size.iconSize
                case .heading(let style):               return style.iconSize
                case .label(let style):                 return style.iconSize
                case .custom(let size):                 return size
            }
        }

        /// Text line height for icon size for specified ContentSizeCategory.
        public func dynamicTextLineHeight(sizeCategory: ContentSizeCategory) -> CGFloat {
            round(textLineHeight * sizeCategory.ratio)
        }

        public func textBaselineAlignmentGuide(sizeCategory: ContentSizeCategory, height: CGFloat) -> CGFloat {
            round(dynamicTextLineHeight(sizeCategory: sizeCategory) * Text.firstBaselineRatio + height / 2)
        }

        public func baselineOffset(sizeCategory: ContentSizeCategory) -> CGFloat {
            round(dynamicTextLineHeight(sizeCategory: sizeCategory) * 0.2)
        }
    }
}

// MARK: - Previews
struct IconPreviews: PreviewProvider {

    static let multilineText = "Multiline\nlong\ntext"
    static let sfSymbol = "info.circle.fill"
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshotSizes
            snapshotSizesText
            snapshotSizesLabelText
            snapshotSizesHeading
            snapshotSizesLabelHeading
            alignments
            storybookMix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Icon(.informationCircle)
    }
    
    static var storybook: some View {
        VStack(alignment: .leading, spacing: .medium) {
            snapshotSizes
            snapshotSizesText
            snapshotSizesHeading
            alignments
        }
    }
    
    static var snapshotSizes: some View {
        VStack(alignment: .leading, spacing: .small) {
            HStack(spacing: .xSmall) {
                Text("16", color: .custom(.redNormal))
            
                HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                    Icon(.passengers, size: .small)
                    Text("Small text and icon size", size: .small)
                }
                .overlay(Separator(thickness: .hairline), alignment: .top)
                .overlay(Separator(thickness: .hairline), alignment: .bottom)
            }
            HStack(spacing: .xSmall) {
                Text("20", color: .custom(.orangeNormal))
            
                HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                    Icon(.passengers, size: .normal)
                    Text("Normal text and icon size", size: .normal)
                }
                .overlay(Separator(thickness: .hairline), alignment: .top)
                .overlay(Separator(thickness: .hairline), alignment: .bottom)
            }
            HStack(spacing: .xSmall) {
                Text("24", color: .custom(.greenNormal))
            
                HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                    Icon(.passengers, size: .large)
                    Text("Large text and icon size", size: .large)
                }
                .overlay(Separator(thickness: .hairline), alignment: .top)
                .overlay(Separator(thickness: .hairline), alignment: .bottom)
            }
        }
    }
    
    static func headingStack(_ style: Heading.Style) -> some View {
        HStack(spacing: .xSmall) {
            HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                Icon(.passengers, size: .heading(style))
                Heading("Heading", style: style)
            }
            .overlay(Separator(thickness: .hairline), alignment: .top)
            .overlay(Separator(thickness: .hairline), alignment: .bottom)
        }
    }
    
    static func labelHeadingStack(_ style: Heading.Style) -> some View {
        HStack(spacing: .xSmall) {
            Label("Label Heading", icon: .passengers, style: .heading(style))
                .overlay(Separator(thickness: .hairline), alignment: .top)
                .overlay(Separator(thickness: .hairline), alignment: .bottom)
        }
    }
    
    static func labelTextStack(_ size: Text.Size) -> some View {
        HStack(spacing: .xSmall) {
            Label("Label Text", icon: .passengers, style: .text(size))
                .overlay(Separator(), alignment: .top)
                .overlay(Separator(), alignment: .bottom)
        }
    }
    
    static func textStack(_ size: Text.Size) -> some View {
        HStack(spacing: .xSmall) {
            HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                Icon(.passengers, size: .text(size))
                Text("Text", size: size)
            }
            .overlay(Separator(), alignment: .top)
            .overlay(Separator(), alignment: .bottom)
        }
    }
    
    static var snapshotSizesText: some View {
        VStack(alignment: .leading, spacing: .small) {
            textStack(.small)
            textStack(.normal)
            textStack(.large)
            textStack(.xLarge)
            textStack(.custom(50))
        }
        .previewDisplayName("Calculated sizes for Text")
    }
    
    static var snapshotSizesLabelText: some View {
        VStack(alignment: .leading, spacing: .small) {
            labelTextStack(.small)
            labelTextStack(.normal)
            labelTextStack(.large)
            labelTextStack(.xLarge)
            labelTextStack(.custom(50))
        }
        .previewDisplayName("Calculated sizes for Text in Label")
    }
    
    static var snapshotSizesHeading: some View {
        VStack(alignment: .leading, spacing: .small) {
            headingStack(.title6)
            headingStack(.title5)
            headingStack(.title4)
            headingStack(.title3)
            headingStack(.title2)
            headingStack(.title1)
            headingStack(.displaySubtitle)
            headingStack(.display)
        }
        .previewDisplayName("Calculated sizes for Heading")
    }
    
    static var snapshotSizesLabelHeading: some View {
        VStack(alignment: .leading, spacing: .small) {
            labelHeadingStack(.title6)
            labelHeadingStack(.title5)
            labelHeadingStack(.title4)
            labelHeadingStack(.title3)
            labelHeadingStack(.title2)
            labelHeadingStack(.title1)
            labelHeadingStack(.displaySubtitle)
            labelHeadingStack(.display)
        }
        .previewDisplayName("Calculated sizes for Heading in Label")
    }

    static var storybookMix: some View {
        VStack(alignment: .leading, spacing: .small) {
            Text("SF Symbol vs Orbit sizes (custom-font-label)", size: .small)
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(sfSymbol: sfSymbol, size: .custom(Text.Size.xLarge.iconSize), color: nil)
                    Icon(sfSymbol: sfSymbol, size: .fontSize(Text.Size.xLarge.value), color: nil)
                    Icon(sfSymbol: sfSymbol, size: .label(.text(.xLarge)), color: nil)
                    Color.clear.frame(width: .xSmall, height: 1)
                    Icon(.informationCircle, size: .custom(Text.Size.xLarge.iconSize), color: nil)
                    Icon(.informationCircle, size: .fontSize(Text.Size.xLarge.value), color: nil)
                    Icon(.informationCircle, size: .label(.text(.xLarge)), color: nil)
                    Color.clear.frame(width: .xSmall, height: 1)
                    Text("XLarge", size: .xLarge, color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(sfSymbol: sfSymbol, size: .custom(Text.Size.small.iconSize), color: nil)
                    Icon(sfSymbol: sfSymbol, size: .fontSize(Text.Size.small.value), color: nil)
                    Icon(sfSymbol: sfSymbol, size: .label(.text(.small)), color: nil)
                    Color.clear.frame(width: .xSmall, height: 1)
                    Icon(.informationCircle, size: .custom(Text.Size.small.iconSize), color: nil)
                    Icon(.informationCircle, size: .fontSize(Text.Size.small.value), color: nil)
                    Icon(.informationCircle, size: .label(.text(.small)), color: nil)
                    Color.clear.frame(width: .xSmall, height: 1)
                    Text("Small", size: .small, color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))

            Text("Flag - Image - SF Symbol sizes", size: .small)
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(countryCode: "cz", size: .xLarge)
                    Icon(image: .orbit(.facebook), size: .xLarge)
                    Icon(sfSymbol: sfSymbol, size: .xLarge, color: nil)
                    Text("Text", size: .custom(20), color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(countryCode: "cz", size: .small)
                    Icon(image: .orbit(.facebook), size: .small)
                    Icon(sfSymbol: sfSymbol, size: .small, color: nil)
                    Text("Text", size: .small, color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))

            Text("Baseline alignment", size: .small)
            HStack(alignment: .firstTextBaseline) {
                Group {
                    Text("O", size: .custom(30))
                    Icon(.informationCircle, size: .fontSize(30))
                    Icon(.informationCircle, size: .fontSize(8))
                    Text("O", size: .custom(8))
                    Text("Text", size: .normal)
                }
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))

            Text("Icon color override", size: .small)
            HStack(alignment: .firstTextBaseline) {
                Icon(content: .grid, size: .xLarge)
                Icon(content: .symbol(.grid, color: nil))
                Icon(content: .symbol(.grid, color: .redNormal), size: .text(.small))
                Text("Text", size: .small, color: nil)
            }
            .foregroundColor(.blueDark)
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))
        }
    }

    static var alignments: some View {
        VStack(spacing: .medium) {
            HStack(spacing: .medium) {
                HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                    Icon(.grid)
                    Text(multilineText)
                }
                HStack(alignment: .lastTextBaseline, spacing: .xSmall) {
                    Icon(.grid)
                    Text(multilineText)
                }
            }
            Label("Multiline\nlong\nLabel", icon: .grid, style: .text())
        }
    }

    static var snapshot: some View {
        VStack(spacing: .medium) {
            IconPreviews.snapshotSizes
            Separator()
            IconPreviews.storybookMix
        }
        .padding(.medium)
    }
}

struct IconDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")
            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        IconPreviews.snapshotSizes
        IconPreviews.storybookMix
    }
}
