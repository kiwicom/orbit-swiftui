import SwiftUI

/// An icon matching Orbit name.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/icon/)
public struct Icon: View {

    /// Approximate size ratio between SF Symbol and Orbit icon symbol.
    public static let sfSymbolToOrbitSymbolSizeRatio: CGFloat = 0.75
    /// Approximate Orbit icon symbol baseline.
    public static let symbolBaseline: CGFloat = 0.77

    @Environment(\.sizeCategory) var sizeCategory

    let content: Content
    let size: Size
    let baselineOffset: CGFloat

    public var body: some View {
        if content.isEmpty == false {
            iconContent
        }
    }

    @ViewBuilder var iconContent: some View {
        switch content {
            case .symbol(let symbol, let color?):
                alignmentWrapper {
                    symbolWrapper(symbol: symbol) {
                        SwiftUI.Text(verbatim: symbol.value)
                            .foregroundColor(color)
                    }
                }
            case .symbol(let symbol, nil):
                alignmentWrapper {
                    symbolWrapper(symbol: symbol) {
                        SwiftUI.Text(verbatim: symbol.value)
                    }
                }
            case .image(let image, let tint?, let mode):
                alignmentWrapper {
                    imageWrapper(mode: mode) {
                        image
                            .resizable()
                            .foregroundColor(tint)
                    }
                }
            case .image(let image, nil, let mode):
                alignmentWrapper {
                    imageWrapper(mode: mode) {
                        image
                            .resizable()
                    }
                }
            case .countryFlag(let countryCode):
                alignmentWrapper {
                    CountryFlag(countryCode, size: size)
                        .frame(height: dynamicSize)
                }
            case .sfSymbol(let systemName, let color?, let weight):
                sfSymbolWrapper(weight: weight) {
                    Image(systemName: systemName)
                        .foregroundColor(color)
                }
            case .sfSymbol(let systemName, nil, let weight):
                sfSymbolWrapper(weight: weight) {
                    Image(systemName: systemName)
                }
        }
    }

    @ViewBuilder func alignmentWrapper(@ViewBuilder content: () -> some View) -> some View {
        content()
            .alignmentGuide(.firstTextBaseline, computeValue: baseline)
            .alignmentGuide(.lastTextBaseline, computeValue: baseline)
    }

    @ViewBuilder func symbolWrapper(symbol: Icon.Symbol, @ViewBuilder content: () -> some View) -> some View {
        content()
            .font(.orbitIcon(size: size.value))
            .frame(height: dynamicSize)
            .accessibility(label: SwiftUI.Text(String(describing: symbol)))
            .flipsForRightToLeftLayoutDirection(symbol.flipsForRightToLeftLayoutDirection)
    }

    @ViewBuilder func imageWrapper(mode: ContentMode, @ViewBuilder content: () -> some View) -> some View {
        content()
            .aspectRatio(contentMode: mode)
            .frame(width: dynamicSize, height: dynamicSize)
            .accessibility(hidden: true)
    }

    @ViewBuilder func sfSymbolWrapper(weight: Font.Weight, @ViewBuilder content: () -> some View) -> some View {
        content()
            .font(.system(size: sfSymbolDynamicSize, weight: weight))
            .alignmentGuide(.firstTextBaseline) { $0[.firstTextBaseline] - baselineOffset }
            .alignmentGuide(.lastTextBaseline) { $0[.lastTextBaseline] - baselineOffset }
            .frame(minHeight: dynamicSize)
    }

    var dynamicSize: CGFloat {
        round(size.value * sizeCategory.ratio)
    }

    var sfSymbolSize: CGFloat {
        round(size.value * Self.sfSymbolToOrbitSymbolSizeRatio)
    }

    var sfSymbolDynamicSize: CGFloat {
        round(sfSymbolSize * sizeCategory.ratio)
    }

    func baseline(_ dimensions: ViewDimensions) -> CGFloat {
        dimensions.height * Self.symbolBaseline - baselineOffset
    }
}

// MARK: - Inits
public extension Icon {
    
    /// Creates Orbit Icon component for provided icon content.
    ///
    /// - Parameters:
    ///     - content: Icon content. Can optionally include the color override.
    init(content: Icon.Content, size: Size = .normal, baselineOffset: CGFloat = 0) {
        self.content = content
        self.size = size
        self.baselineOffset = baselineOffset
    }

    /// Creates Orbit Icon component for provided Orbit icon symbol with specified color.
    ///
    /// - Parameters:
    ///     - color: Icon color. Can be set to `nil` and specified later using `.foregroundColor()` modifier.
    init(_ symbol: Icon.Symbol, size: Size = .normal, color: Color? = .inkDark, baselineOffset: CGFloat = 0) {
        self.init(
            content: .symbol(symbol, color: color),
            size: size,
            baselineOffset: baselineOffset
        )
    }
    
    /// Creates Orbit Icon component for provided Image.
    ///
    /// - Parameters:
    ///     - tint: Image tint. Can be set to `nil` and specified later using `.foregroundColor()` modifier.
    init(image: Image, size: Size = .normal, tint: Color? = .inkDark, baselineOffset: CGFloat = 0) {
        self.init(
            content: .image(image, tint: tint),
            size: size,
            baselineOffset: baselineOffset
        )
    }
    
    /// Creates Orbit Icon component for provided country code.
    init(countryCode: String, size: Size = .normal, baselineOffset: CGFloat = 0) {
        self.init(
            content: .countryFlag(countryCode),
            size: size,
            baselineOffset: baselineOffset
        )
    }
    
    /// Creates Orbit Icon component for provided SF Symbol with specified color.
    ///
    /// - Parameters:
    ///     - color: SF Symbol color. Can be set to `nil` and specified later using `.foregroundColor()` modifier.
    init(sfSymbol: String, size: Size = .normal, color: Color? = .inkDark, baselineOffset: CGFloat = 0) {
        self.init(
            content: .sfSymbol(sfSymbol, color: color),
            size: size,
            baselineOffset: baselineOffset
        )
    }
}

// MARK: - Types
public extension Icon {

    /// Defines icon content for use in other components.
    enum Content: Equatable {
        /// Orbit icon symbol with optional color specified. If not specified, it can be overridden using `.foregroundColor()` modifier.
        case symbol(Symbol, color: Color? = nil)
        /// Custom Image, suitable for use as icon with optional tint color specified. If not specified, it can be overridden using `.foregroundColor()` modifier.
        case image(Image, tint: Color? = nil, mode: ContentMode = .fit)
        /// Orbit CountryFlag content, suitable for use as icon.
        case countryFlag(String)
        /// SF Symbol with overridable weight and optional color specified. If not specified, it can be overridden using `.foregroundColor()` modifier.
        case sfSymbol(String, color: Color? = nil, weight: Font.Weight = .regular)

        public var isEmpty: Bool {
            switch self {
                case .symbol(let symbol, _):            return symbol == .none
                case .image:                            return false
                case .countryFlag(let countryCode):     return countryCode.isEmpty
                case .sfSymbol(let sfSymbol, _, _):     return sfSymbol.isEmpty
            }
        }
    }

    /// Preferred icon size in both dimensions. Actual size may differ based on icon content.
    enum Size: Equatable {
        /// Size 16.
        case small
        /// Size 20.
        case normal
        /// Size 24.
        case large
        /// Size 28.
        case xLarge
        /// Custom size.
        case custom(CGFloat)

        /// Icon size matching `Text` size.
        public static func text(_ size: Text.Size) -> Self {
            size.iconSize
        }

        /// Icon size matching `Heading` style.
        public static func heading(_ style: Heading.Style) -> Self {
            style.iconSize
        }

        public var value: CGFloat {
            switch self {
                case .small:                            return 16
                case .normal:                           return 20
                case .large:                            return 24
                case .xLarge:                           return 28
                case .custom(let size):                 return size
            }
        }
        
        public static func == (lhs: Icon.Size, rhs: Icon.Size) -> Bool {
            lhs.value == rhs.value
        }
    }
}

// MARK: - TextRepresentable
extension Icon: TextRepresentable {

    public func swiftUIText(sizeCategory: ContentSizeCategory) -> SwiftUI.Text? {
        if content.isEmpty {
            return nil
        }

        if #available(iOS 14.0, *) {
            return text(sizeCategory: sizeCategory)
        } else {
            return textFallback(sizeCategory: sizeCategory)
        }
    }

    @available(iOS 14.0, *)
    func text(sizeCategory: ContentSizeCategory) -> SwiftUI.Text? {
        switch content {
            case .symbol(let symbol, let color?):
                return symbolWrapper(sizeCategory: sizeCategory) {
                    SwiftUI.Text(verbatim: symbol.value)
                        .foregroundColor(color)
                }
            case .symbol(let symbol, nil):
                return symbolWrapper(sizeCategory: sizeCategory) {
                    SwiftUI.Text(verbatim: symbol.value)
                }
            case .image(let image, let tint?, _):
                return SwiftUI.Text(image)
                    .baselineOffset(-baselineOffset)
                    .foregroundColor(tint)
            case .image(let image, _, _):
                return SwiftUI.Text(image)
                    .baselineOffset(-baselineOffset)
            case .countryFlag:
                assertionFailure("text representation of countryFlag icon is not supported")
                return nil
            case .sfSymbol(let systemName, let color?, let weight):
                return sfSymbolWrapper(sizeCategory: sizeCategory, weight: weight) {
                    SwiftUI.Text(Image(systemName: systemName))
                        .foregroundColor(color)
                }
            case .sfSymbol(let systemName, nil, let weight):
                return sfSymbolWrapper(sizeCategory: sizeCategory, weight: weight) {
                    SwiftUI.Text(Image(systemName: systemName))
                }
        }
    }

    func textFallback(sizeCategory: ContentSizeCategory) -> SwiftUI.Text? {
        switch content {
            case .symbol(let symbol, let color?):
                return symbolWrapper(sizeCategory: sizeCategory) {
                    SwiftUI.Text(verbatim: symbol.value)
                        .foregroundColor(color)
                }
            case .symbol(let symbol, nil):
                return symbolWrapper(sizeCategory: sizeCategory) {
                    SwiftUI.Text(verbatim: symbol.value)
                }
            case .countryFlag:
                assertionFailure("text representation of countryFlag icon is not supported")
                return nil
            case .image, .sfSymbol:
                assertionFailure("image and sfSymbol text representation is available in iOS 14.0 or newer")
                return nil
        }
    }

    func symbolWrapper(sizeCategory: ContentSizeCategory, @ViewBuilder text: () -> SwiftUI.Text) -> SwiftUI.Text {
        text()
            .font(.orbitIcon(size: size.value))
            .baselineOffset(textBaselineOffset(sizeCategory: sizeCategory))
    }

    func sfSymbolWrapper(sizeCategory: ContentSizeCategory, weight: Font.Weight, @ViewBuilder text: () -> SwiftUI.Text) -> SwiftUI.Text {
        text()
            .font(.system(size: sfSymbolSize * sizeCategory.ratio, weight: weight))
            .baselineOffset(-baselineOffset)
    }

    func textBaselineOffset(sizeCategory: ContentSizeCategory) -> CGFloat {
        (-size.value * sizeCategory.ratio) * (1 - Self.symbolBaseline) - baselineOffset
    }
}

extension Icon.Symbol {

    var flipsForRightToLeftLayoutDirection: Bool {
        switch self {
            case .chevronForward,
                 .chevronBackward,
                 .chevronDoubleForward,
                 .chevronDoubleBackward,
                 .flightDirect,
                 .flightMulticity,
                 .flightNomad,
                 .flightReturn,
                 .routeNoStops,
                 .routeOneStop,
                 .routeTwoStops:
                return true
            default:
                return false
        }
    }
}

// MARK: - Previews
struct IconPreviews: PreviewProvider {

    static let sfSymbol = "info.circle.fill"

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizes
            text
            heading
            baseline
            colors
            rightToLeft
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Icon(.informationCircle)
            .padding(.medium)
            .previewDisplayName()
    }
    
    static var sizes: some View {
        VStack(alignment: .leading, spacing: .small) {
            size(iconSize: .small, textSize: .small, color: .redNormal)
            size(iconSize: .normal, textSize: .normal, color: .orangeNormal)
            size(iconSize: .large, textSize: .large, color: .greenNormal)
            size(iconSize: .xLarge, textSize: .xLarge, color: .blueNormal)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var text: some View {
        VStack(alignment: .leading, spacing: .small) {
            textStack(.small, alignment: .firstTextBaseline)
            textStack(.normal, alignment: .firstTextBaseline)
            textStack(.large, alignment: .firstTextBaseline)
            textStack(.xLarge, alignment: .firstTextBaseline)
            textStack(.custom(30), alignment: .firstTextBaseline)

            textStack(.small, alignment: .top)
            textStack(.normal, alignment: .top)
            textStack(.large, alignment: .top)
            textStack(.xLarge, alignment: .top)
            textStack(.custom(30), alignment: .top)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var heading: some View {
        VStack(alignment: .leading, spacing: .small) {
            headingStack(.title6, alignment: .firstTextBaseline)
            headingStack(.title5, alignment: .firstTextBaseline)
            headingStack(.title4, alignment: .firstTextBaseline)
            headingStack(.title3, alignment: .firstTextBaseline)
            headingStack(.title2, alignment: .firstTextBaseline)
            headingStack(.title1, alignment: .firstTextBaseline)

            Group {
                headingStack(.title6, alignment: .top)
                headingStack(.title5, alignment: .top)
                headingStack(.title4, alignment: .top)
                headingStack(.title3, alignment: .top)
                headingStack(.title2, alignment: .top)
                headingStack(.title1, alignment: .top)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var baseline: some View {
        VStack(alignment: .leading, spacing: 0) {
            Heading("Standalone", style: .title6)

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Text("Text", size: .small)
                    Icon(sfSymbol: sfSymbol, size: .small, color: nil)
                    Icon(sfSymbol: sfSymbol, size: .small, color: nil, baselineOffset: .xxxSmall)

                    Icon(.informationCircle, size: .small, color: nil)
                    Icon(.informationCircle, size: .small, color: nil, baselineOffset: .xxxSmall)

                    Group {
                        Icon(image: .orbit(.navigateClose), size: .small, tint: nil)
                        Icon(image: .orbit(.navigateClose), size: .small, tint: nil, baselineOffset: .xxxSmall)
                        Icon(image: .orbit(.facebook), size: .small)
                        Icon(image: .orbit(.facebook), size: .small, baselineOffset: .xxxSmall)
                    }

                    Icon(countryCode: "us", size: .small)
                    Icon(countryCode: "us", size: .small, baselineOffset: .xxxSmall)
                }
                .border(Color.cloudLightActive, width: .hairline)
            }
            .foregroundColor(Color.greenDark)
            .overlay(
                Separator(color: .redNormal, thickness: .hairline),
                alignment: .centerFirstTextBaseline
            )

            Heading("Concatenated", style: .title6)
                .padding(.top, .xLarge)

            (
                Text("Text", size: .small)
                + Icon(sfSymbol: sfSymbol, size: .small, color: nil)
                + Icon(sfSymbol: sfSymbol, size: .small, color: nil, baselineOffset: .xxxSmall)

                + Icon(.informationCircle, size: .small, color: nil)
                + Icon(.informationCircle, size: .small, color: nil, baselineOffset: .xxxSmall)

                + Icon(image: .orbit(.navigateClose), tint: nil)
                + Icon(image: .orbit(.navigateClose), tint: nil, baselineOffset: .xxxSmall)
                + Icon(image: .orbit(.facebook))
                + Icon(image: .orbit(.facebook), baselineOffset: .xxxSmall)
            )
            .foregroundColor(Color.greenDark)
            .overlay(
                Separator(color: .redNormal, thickness: .hairline),
                alignment: .centerFirstTextBaseline
            )
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var colors: some View {
        VStack(alignment: .leading, spacing: .small) {
            HStack(alignment: .firstTextBaseline) {
                Icon(.grid)
                Icon(.grid, color: .blueNormal)
                Icon(.grid, color: nil)
                Icon(content: .grid)
                Icon(content: .symbol(.grid, color: nil))
            }

            HStack(alignment: .firstTextBaseline) {
                Icon(sfSymbol: sfSymbol)
                Icon(sfSymbol: sfSymbol, color: .blueNormal)
                Icon(sfSymbol: sfSymbol, color: nil)
                Icon(content: .sfSymbol(sfSymbol))
                Icon(content: .sfSymbol(sfSymbol, color: nil))
            }

            HStack(alignment: .firstTextBaseline) {
                Icon(image: .orbit(.navigateClose))
                Icon(image: .orbit(.navigateClose), tint: .blueNormal)
                Icon(image: .orbit(.navigateClose), tint: nil)
                Icon(content: .image(.orbit(.navigateClose)))
                Icon(content: .image(.orbit(.navigateClose), tint: nil))
            }
        }
        .foregroundColor(.greenNormalHover)
        .padding(.medium)
        .previewDisplayName()
    }

    static var rightToLeft: some View {
        VStack(alignment: .trailing) {
            ForEach(flippableSymbols, id: \.value) { symbol in
                HStack {
                    Text(String(describing: symbol), size: .small)
                    Icon(symbol)
                    Icon(symbol)
                        .environment(\.layoutDirection, .rightToLeft)
                }
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static func size(iconSize: Icon.Size, textSize: Text.Size, color: UIColor) -> some View {
        HStack(spacing: .xSmall) {
            Text("\(Int(iconSize.value))", color: .custom(color), weight: .bold)

            HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                Icon(.passengers, size: iconSize)
                Text("XLarge text and icon size", size: textSize)
            }
            .overlay(Separator(thickness: .hairline), alignment: .top)
            .overlay(Separator(thickness: .hairline), alignment: .bottom)
        }
    }

    static func headingStack(_ style: Heading.Style, alignment: VerticalAlignment) -> some View {
        alignmentStack(style.iconSize, alignment: alignment) {
            Heading("\(style)".capitalized, style: style)
        }
    }

    static func textStack(_ size: Text.Size, alignment: VerticalAlignment) -> some View {
        alignmentStack(size.iconSize, alignment: alignment) {
            Text("Text \(Int(size.value))", size: size)
        }
    }

    static func alignmentStack<V: View>(_ size: Icon.Size, alignment: VerticalAlignment, @ViewBuilder content: () -> V) -> some View {
        HStack(spacing: .xSmall) {
            HStack(alignment: alignment, spacing: .xxSmall) {
                Group {
                    Icon(countryCode: "us", size: size)
                    Icon(image: .orbit(.facebook), size: size)
                    Icon(sfSymbol: sfSymbol, size: size)
                    Icon(.informationCircle, size: size)
                    content()
                }
                .background(Color.redLightHover)
            }
            .overlay(
                Separator(color: .redNormal, thickness: .hairline),
                alignment: .init(horizontal: .center, vertical: alignment)
            )
            .background(
                Separator(color: .greenNormal, thickness: .hairline),
                alignment: .init(horizontal: .center, vertical: .top)
            )
            .background(
                Separator(color: .greenNormal, thickness: .hairline),
                alignment: .init(horizontal: .center, vertical: .bottom)
            )
        }
    }

    static let flippableSymbols = Icon.Symbol.allCases.filter(\.flipsForRightToLeftLayoutDirection)
}
