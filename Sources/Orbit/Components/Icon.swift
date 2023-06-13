import SwiftUI

/// An Orbit Icon component.
///
/// Icon is concatenable with Text and Heading components, allowing the construction of multiline texts that include icons.
/// Apart from Orbit symbol, an Icon can be constructed from SF Symbol with matching Orbit icon size.
///
/// ```swift
/// Text("2") + Icon("multiply") + Icon(.baggage)
/// ```
///
/// Icon can be further styled using either `Icon` modifiers or global modifiers `iconColor`, `textColor`, `textFontWeight`, `baselineOffset`.
///
/// ```swift
/// VStack {
///   Icon(.grid)
///     .iconColor(nil)
///
///   Icon("circle.fill")
///     .fontWeight(.bold)
///     .baselineOffset(-2)
/// }
/// .iconColor(.redNormal)
/// .textFontWeight(.medium)
/// ```
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/icon/)
public struct Icon: View, TextBuildable {

    /// Approximate size ratio between SF Symbol and Orbit icon symbol.
    public static let sfSymbolToOrbitSymbolSizeRatio: CGFloat = 0.75
    /// Approximate Orbit icon symbol baseline.
    public static let symbolBaseline: CGFloat = 0.77
    /// Default SF Symbol weight matching Orbit icon symbols.
    public static let sfSymbolDefaultWeight: Font.Weight = .medium

    @Environment(\.iconColor) private var iconColor
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.textColor) private var textColor
    @Environment(\.textFontWeight) private var textFontWeight

    private let content: Content?
    private let size: Size

    // Builder properties
    var baselineOffset: CGFloat?
    var fontWeight: Font.Weight?
    var color: Color?

    public var body: some View {
        switch content {
            case .none, .sfSymbol(""):
                EmptyView()
            case .symbol(let symbol):
                SwiftUI.Text(verbatim: symbol.value)
                    .font(.orbitIcon(size: size.value))
                    .foregroundColor(resolvedColor)
                    .flipsForRightToLeftLayoutDirection(symbol.flipsForRightToLeftLayoutDirection)
                    .frame(height: dynamicSize)
                    .frame(minWidth: dynamicSize)
                    .alignmentGuide(.firstTextBaseline, computeValue: baseline)
                    .alignmentGuide(.lastTextBaseline, computeValue: baseline)
                    .accessibility(label: .init(String(describing: symbol).titleCased))
            case .sfSymbol(let systemName):
                Image(systemName: systemName)
                    .font(sfSymbolFont(sizeCategory: sizeCategory, textFontWeight: textFontWeight))
                    .foregroundColor(resolvedColor)
                    .frame(height: dynamicSize)
                    .frame(minWidth: dynamicSize)
                    .alignmentGuide(.firstTextBaseline) { $0[.firstTextBaseline] + resolvedBaselineOffset }
                    .alignmentGuide(.lastTextBaseline) { $0[.lastTextBaseline] + resolvedBaselineOffset }
        }
    }

    public var isEmpty: Bool {
        content?.isEmpty ?? true
    }

    private func sfSymbolFont(sizeCategory: ContentSizeCategory, textFontWeight: Font.Weight?) -> Font {
        .system(
            size: sfSymbolSize * sizeCategory.ratio,
            weight: fontWeight ?? textFontWeight ?? Self.sfSymbolDefaultWeight
        )
    }

    private var resolvedColor: Color {
        color ?? iconColor ?? textColor ?? .inkDark
    }

    private var dynamicSize: CGFloat {
        round(size.value * sizeCategory.ratio)
    }

    private var sfSymbolSize: CGFloat {
        round(size.value * Self.sfSymbolToOrbitSymbolSizeRatio)
    }

    private var resolvedBaselineOffset: CGFloat {
        baselineOffset ?? 0
    }

    private func baseline(_ dimensions: ViewDimensions) -> CGFloat {
        dimensions.height * Self.symbolBaseline + resolvedBaselineOffset
    }

    private init(_ content: Content?, size: Size = .normal) {
        self.content = content
        self.size = size
    }
}

// MARK: - Inits
public extension Icon {

    /// Creates Orbit Icon component for provided Orbit symbol.
    init(_ symbol: Icon.Symbol?, size: Size = .normal) {
        self.init(
            symbol.map { Icon.Content.symbol($0) },
            size: size
        )
    }

    /// Creates Orbit Icon component for provided SF Symbol that matches the Orbit symbol sizing, reflecting the Dynamic Type settings.
    init(_ systemName: String, size: Size = .normal) {
        self.init(
            .sfSymbol(systemName),
            size: size
        )
    }
}

// MARK: - Types
public extension Icon {

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

        public var value: CGFloat {
            switch self {
                case .small:                            return 16
                case .normal:                           return 20
                case .large:                            return 24
                case .xLarge:                           return 28
                case .custom(let size):                 return size
            }
        }
    }
}

// MARK: - Private
private extension Icon {

    enum Content {
        case symbol(Symbol)
        case sfSymbol(String)

        var isEmpty: Bool {
            switch self {
                case .symbol:                           return false
                case .sfSymbol(let sfSymbol):           return sfSymbol.isEmpty
            }
        }
    }
}

// MARK: - TextRepresentable
extension Icon: TextRepresentable {

    public func swiftUIText(textRepresentableEnvironment: TextRepresentableEnvironment) -> SwiftUI.Text? {
        if #available(iOS 14.0, *) {
            return text(textRepresentableEnvironment: textRepresentableEnvironment)
        } else {
            return textFallback(textRepresentableEnvironment: textRepresentableEnvironment)
        }
    }

    @available(iOS 14.0, *)
    func text(textRepresentableEnvironment: TextRepresentableEnvironment) -> SwiftUI.Text? {
        switch content {
            case .none:
                return nil
            case .symbol(let symbol):
                return symbolWrapper(sizeCategory: textRepresentableEnvironment.sizeCategory) {
                    colorWrapper(textRepresentableEnvironment: textRepresentableEnvironment) {
                        SwiftUI.Text(verbatim: symbol.value)
                    }
                }
            case .sfSymbol(let systemName):
                return baselineWrapper {
                    colorWrapper(textRepresentableEnvironment: textRepresentableEnvironment) {
                        SwiftUI.Text(Image(systemName: systemName))
                            .font(
                                sfSymbolFont(
                                    sizeCategory: textRepresentableEnvironment.sizeCategory,
                                    textFontWeight: textRepresentableEnvironment.textFontWeight
                                )
                            )
                    }
                }
        }
    }

    private func textFallback(textRepresentableEnvironment: TextRepresentableEnvironment) -> SwiftUI.Text? {
        switch content {
            case .none:
                return nil
            case .symbol(let symbol):
                return symbolWrapper(sizeCategory: textRepresentableEnvironment.sizeCategory) {
                    baselineWrapper {
                        colorWrapper(textRepresentableEnvironment: textRepresentableEnvironment) {
                            SwiftUI.Text(verbatim: symbol.value)
                        }
                    }
                }
            case .sfSymbol:
                assertionFailure("Icon sfSymbol text representation is available in iOS 14.0 or newer")
                return nil
        }
    }

    private func colorWrapper(textRepresentableEnvironment: TextRepresentableEnvironment, @ViewBuilder text: () -> SwiftUI.Text) -> SwiftUI.Text {
        text()
            .foregroundColor(resolvedColor(textRepresentableEnvironment: textRepresentableEnvironment))
    }

    private func symbolWrapper(sizeCategory: ContentSizeCategory, @ViewBuilder text: () -> SwiftUI.Text) -> SwiftUI.Text {
        imageBaselineWrapper(sizeCategory: sizeCategory) {
            text()
                .font(.orbitIcon(size: size.value))
        }
    }

    private func baselineWrapper(@ViewBuilder text: () -> SwiftUI.Text) -> SwiftUI.Text {
        if let baselineOffset {
            return text()
                .baselineOffset(baselineOffset)
        } else {
            return text()
        }
    }

    private func resolvedColor(textRepresentableEnvironment: TextRepresentableEnvironment) -> Color {
        color ?? textRepresentableEnvironment.iconColor ?? textRepresentableEnvironment.textColor ?? .inkDark
    }

    private func imageBaselineWrapper(sizeCategory: ContentSizeCategory, @ViewBuilder text: () -> SwiftUI.Text) -> SwiftUI.Text {
        text()
            .baselineOffset(textBaselineOffset(baselineOffset, sizeCategory: sizeCategory))
    }

    private func textBaselineOffset(_ baselineOffset: CGFloat?, sizeCategory: ContentSizeCategory) -> CGFloat {
        (-size.value * sizeCategory.ratio) * (1 - Self.symbolBaseline) + resolvedBaselineOffset
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
        VStack(spacing: .medium) {
            Icon(.informationCircle)
            Icon(.informationCircle)
                .iconColor(.blueNormal)
            Icon(.placeholder)
                .textColor(.blueNormal)
                .iconColor(.redNormal)
            Icon(.grid)
                .opacity(0)
                .padding(-1)
                .overlay(Skeleton(.atomic(.rectangle)))
            Icon(.grid)
                .opacity(0)
                .border(.inkNormal, width: .hairline)
            Icon("") // Results in EmptyView
                .border(.inkNormal, width: .hairline)
        }
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
            VStack(alignment: .leading, spacing: .small) {
                textStack(.small, alignment: .firstTextBaseline)
                textStack(.normal, alignment: .firstTextBaseline)
                textStack(.large, alignment: .firstTextBaseline)
                textStack(.xLarge, alignment: .firstTextBaseline)
                textStack(.custom(30), alignment: .firstTextBaseline)
            }

            VStack(alignment: .leading, spacing: .small) {
                textStack(.small, alignment: .top)
                textStack(.normal, alignment: .top)
                textStack(.large, alignment: .top)
                textStack(.xLarge, alignment: .top)
                textStack(.custom(30), alignment: .top)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var heading: some View {
        VStack(alignment: .leading, spacing: .small) {
            VStack(alignment: .leading, spacing: .small) {
                headingStack(.title6, alignment: .firstTextBaseline)
                headingStack(.title5, alignment: .firstTextBaseline)
                headingStack(.title4, alignment: .firstTextBaseline)
                headingStack(.title3, alignment: .firstTextBaseline)
                headingStack(.title2, alignment: .firstTextBaseline)
                headingStack(.title1, alignment: .firstTextBaseline)
            }

            VStack(alignment: .leading, spacing: .small) {
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
                    Icon(sfSymbol, size: .small)
                        .iconColor(.blueNormal)
                    Icon(sfSymbol, size: .small)
                        .baselineOffset(.xxxSmall)

                    Icon(.informationCircle, size: .small)
                        .iconColor(.blueNormal)
                    Icon(.informationCircle, size: .small)
                        .baselineOffset(.xxxSmall)
                }
                .border(.cloudLightActive, width: .hairline)
            }
            .textColor(.greenDark)
            .overlay(
                Separator(color: .redNormal, thickness: .hairline),
                alignment: .centerFirstTextBaseline
            )

            Heading("Concatenated", style: .title6)
                .padding(.top, .xLarge)

            (
                Text("Text", size: .small)
                + Icon(sfSymbol, size: .small)
                    .iconColor(.blueNormal)
                + Icon(sfSymbol, size: .small)
                    .baselineOffset(.xxxSmall)

                + Icon(.informationCircle, size: .small)
                    .iconColor(.blueNormal)
                + Icon(.informationCircle, size: .small)
                    .baselineOffset(.xxxSmall)
            )
            .textColor(.greenDark)
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
            HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                Icon(.grid)
                    .textColor(nil)
                Icon(.grid)
                    .iconColor(.inkDark)
                Icon(.grid)
                    .iconColor(.blueNormal)
                Icon(.grid)
            }

            HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                Icon(sfSymbol)
                    .textColor(nil)
                Icon(sfSymbol)
                    .iconColor(.inkDark)
                Icon(sfSymbol)
                    .iconColor(.blueNormal)
                Icon(sfSymbol)
            }
        }
        .textColor(.greenNormalHover)
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

    static func size(iconSize: Icon.Size, textSize: Text.Size, color: Color) -> some View {
        HStack(spacing: .xSmall) {
            Text("\(Int(iconSize.value))")
                .textColor(color)
                .bold()

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
                    Icon(sfSymbol, size: size)
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
