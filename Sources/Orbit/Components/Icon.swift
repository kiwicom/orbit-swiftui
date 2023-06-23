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
    @Environment(\.iconSize) private var iconSize
    @Environment(\.textColor) private var textColor
    @Environment(\.textFontWeight) private var textFontWeight
    @Environment(\.textSize) private var textSize
    @Environment(\.sizeCategory) private var sizeCategory

    private let content: Content?

    // Builder properties
    var baselineOffset: CGFloat?
    var fontWeight: Font.Weight?
    var color: Color?
    var size: CGFloat?

    public var body: some View {
        switch content {
            case .none, .sfSymbol(""):
                EmptyView()
            case .symbol(let symbol):
                SwiftUI.Text(verbatim: symbol.value)
                    .font(.orbitIcon(size: resolvedSize(textRepresentableEnvironment)))
                    .foregroundColor(resolvedColor(textRepresentableEnvironment))
                    .flipsForRightToLeftLayoutDirection(symbol.flipsForRightToLeftLayoutDirection)
                    .frame(height: frameSize)
                    .frame(minWidth: frameSize)
                    .alignmentGuide(.firstTextBaseline, computeValue: baseline)
                    .alignmentGuide(.lastTextBaseline, computeValue: baseline)
                    .accessibility(label: .init(String(describing: symbol).titleCased))
            case .sfSymbol(let systemName):
                Image(systemName: systemName)
                    .font(sfSymbolFont(textRepresentableEnvironment))
                    .foregroundColor(resolvedColor(textRepresentableEnvironment))
                    .frame(height: frameSize)
                    .frame(minWidth: frameSize)
                    .alignmentGuide(.firstTextBaseline) { $0[.firstTextBaseline] + resolvedBaselineOffset }
                    .alignmentGuide(.lastTextBaseline) { $0[.lastTextBaseline] + resolvedBaselineOffset }
        }
    }

    private var textRepresentableEnvironment: TextRepresentableEnvironment {
        .init(
            iconColor: iconColor,
            iconSize: iconSize,
            textAccentColor: nil,
            textColor: textColor,
            textFontWeight: textFontWeight,
            textSize: textSize,
            sizeCategory: sizeCategory
        )
    }

    public var isEmpty: Bool {
        content?.isEmpty ?? true
    }

    private func sfSymbolFont(_ textRepresentableEnvironment: TextRepresentableEnvironment) -> Font {
        .system(
            size: sfSymbolSize(textRepresentableEnvironment) * textRepresentableEnvironment.sizeCategory.ratio,
            weight: fontWeight ?? textRepresentableEnvironment.textFontWeight ?? Self.sfSymbolDefaultWeight
        )
    }

    private func resolvedColor(_ textRepresentableEnvironment: TextRepresentableEnvironment) -> Color {
        color ?? textRepresentableEnvironment.iconColor ?? textRepresentableEnvironment.textColor ?? .inkDark
    }

    private var frameSize: CGFloat {
        round(resolvedSize(textRepresentableEnvironment) * sizeCategory.ratio)
    }

    private func sfSymbolSize(_ textRepresentableEnvironment: TextRepresentableEnvironment) -> CGFloat {
        round(resolvedSize(textRepresentableEnvironment) * Self.sfSymbolToOrbitSymbolSizeRatio)
    }

    private func resolvedSize(_ textRepresentableEnvironment: TextRepresentableEnvironment) -> CGFloat {
        size
        ?? textRepresentableEnvironment.iconSize
        ?? textRepresentableEnvironment.textSize.map(Icon.Size.fromTextSize(size:))
        ?? Icon.Size.normal.value
    }

    private var resolvedBaselineOffset: CGFloat {
        baselineOffset ?? 0
    }

    private func baseline(_ dimensions: ViewDimensions) -> CGFloat {
        dimensions.height * Self.symbolBaseline + resolvedBaselineOffset
    }

    private init(_ content: Content?) {
        self.content = content
    }
}

// MARK: - Inits
public extension Icon {

    /// Creates Orbit Icon component for provided Orbit symbol.
    init(_ symbol: Icon.Symbol?) {
        self.init(symbol.map { Icon.Content.symbol($0) })
    }

    /// Creates Orbit Icon component for provided SF Symbol that matches the Orbit symbol sizing, reflecting the Dynamic Type settings.
    init(_ systemName: String) {
        self.init(.sfSymbol(systemName))
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

        public var value: CGFloat {
            switch self {
                case .small:                            return 16
                case .normal:                           return 20
                case .large:                            return 24
                case .xLarge:                           return 28
            }
        }

        /// Icon size matching text line height.
        public static func fromTextSize(size: CGFloat) -> CGFloat {
            Text.Size.lineHeight(forTextSize: size)
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
                return symbolWrapper(textRepresentableEnvironment) {
                    colorWrapper(textRepresentableEnvironment) {
                        SwiftUI.Text(verbatim: symbol.value)
                    }
                }
            case .sfSymbol(let systemName):
                return baselineWrapper {
                    colorWrapper(textRepresentableEnvironment) {
                        SwiftUI.Text(Image(systemName: systemName))
                            .font(
                                sfSymbolFont(textRepresentableEnvironment)
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
                return symbolWrapper(textRepresentableEnvironment) {
                    baselineWrapper {
                        colorWrapper(textRepresentableEnvironment) {
                            SwiftUI.Text(verbatim: symbol.value)
                        }
                    }
                }
            case .sfSymbol:
                assertionFailure("Icon sfSymbol text representation is available in iOS 14.0 or newer")
                return nil
        }
    }

    private func colorWrapper(_ textRepresentableEnvironment: TextRepresentableEnvironment, @ViewBuilder text: () -> SwiftUI.Text) -> SwiftUI.Text {
        text()
            .foregroundColor(resolvedColor(textRepresentableEnvironment))
    }

    private func symbolWrapper(_ textRepresentableEnvironment: TextRepresentableEnvironment, @ViewBuilder text: () -> SwiftUI.Text) -> SwiftUI.Text {
        text()
            .font(.orbitIcon(size: resolvedSize(textRepresentableEnvironment)))
            .baselineOffset(textBaselineOffset(textRepresentableEnvironment))
    }

    private func baselineWrapper(@ViewBuilder text: () -> SwiftUI.Text) -> SwiftUI.Text {
        if let baselineOffset {
            return text()
                .baselineOffset(baselineOffset)
        } else {
            return text()
        }
    }

    private func textBaselineOffset(_ textRepresentableEnvironment: TextRepresentableEnvironment) -> CGFloat {
        (-resolvedSize(textRepresentableEnvironment) * sizeCategory.ratio)
        * (1 - Self.symbolBaseline)
        + resolvedBaselineOffset
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
            }

            VStack(alignment: .leading, spacing: .small) {
                textStack(.small, alignment: .top)
                textStack(.normal, alignment: .top)
                textStack(.large, alignment: .top)
                textStack(.xLarge, alignment: .top)
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
                    Text("Text")
                    Icon(sfSymbol)
                        .iconColor(.blueNormal)
                    Icon(sfSymbol)
                        .baselineOffset(.xxxSmall)

                    Icon(.informationCircle)
                        .iconColor(.blueNormal)
                    Icon(.informationCircle)
                        .baselineOffset(.xxxSmall)
                }
                .border(.cloudLightActive, width: .hairline)
            }
            .textSize(.small)
            .textColor(.greenDark)
            .overlay(
                Separator(color: .redNormal, thickness: .hairline),
                alignment: .centerFirstTextBaseline
            )

            Heading("Concatenated", style: .title6)
                .padding(.top, .xLarge)

            (
                Text("Text")
                + Icon(sfSymbol)
                    .iconColor(.blueNormal)
                + Icon(sfSymbol)
                    .baselineOffset(.xxxSmall)

                + Icon(.informationCircle)
                    .iconColor(.blueNormal)
                + Icon(.informationCircle)
                    .baselineOffset(.xxxSmall)
            )
            .textSize(.small)
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
                    Text(String(describing: symbol))
                        .textSize(.small)
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
                Icon(.passengers)
                    .iconSize(iconSize)
                Text("\(String(describing: textSize).titleCased) text and icon size")
                    .textSize(textSize)
            }
            .overlay(Separator(thickness: .hairline), alignment: .top)
            .overlay(Separator(thickness: .hairline), alignment: .bottom)
        }
    }

    static func headingStack(_ style: Heading.Style, alignment: VerticalAlignment) -> some View {
        alignmentStack(alignment: alignment) {
            Heading("\(style)".capitalized, style: style)
        }
        .iconSize(custom: style.lineHeight)
    }

    static func textStack(_ size: Text.Size, alignment: VerticalAlignment) -> some View {
        alignmentStack(alignment: alignment) {
            Text("\(String(describing: size).titleCased)")
        }
        .textSize(size)
    }

    static func alignmentStack<V: View>(alignment: VerticalAlignment, @ViewBuilder content: () -> V) -> some View {
        HStack(spacing: .xSmall) {
            HStack(alignment: alignment, spacing: .xxSmall) {
                Group {
                    Icon(sfSymbol)
                    Icon(.informationCircle)
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
