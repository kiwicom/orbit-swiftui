import SwiftUI

/// An icon matching Orbit name.
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

    private let icon: Content?
    private let size: Size

    // Builder properties
    var baselineOffset: CGFloat?
    var fontWeight: Font.Weight?
    var color: Color?

    public var body: some View {
        if let icon, icon.isEmpty == false {
            content
                .accessibility(label: .init(icon.accessibilityLabel))
        }
    }

    @ViewBuilder private var content: some View {
        switch icon {
            case .none:
                EmptyView()
            case .transparent:
                Color.clear
                    .frame(width: dynamicSize, height: dynamicSize)
            case .skeleton:
                Skeleton(.atomic(.rectangle))
                    .frame(width: dynamicSize - .xxxSmall, height: dynamicSize - .xxxSmall)
            case .symbol(let symbol, let color):
                alignmentWrapper {
                    colorWrapper(color: color) {
                        SwiftUI.Text(verbatim: symbol.value)
                            .font(.orbitIcon(size: size.value))
                                .frame(height: dynamicSize)
                                .frame(minWidth: dynamicSize)
                                .flipsForRightToLeftLayoutDirection(symbol.flipsForRightToLeftLayoutDirection)
                        }
                    }
            case .sfSymbol(let systemName, let color):
                colorWrapper(color: color) {
                    Image(systemName: systemName)
                        .font(sfSymbolFont(sizeCategory: sizeCategory, textFontWeight: textFontWeight))
                        .alignmentGuide(.firstTextBaseline) { $0[.firstTextBaseline] + resolvedBaselineOffset }
                        .alignmentGuide(.lastTextBaseline) { $0[.lastTextBaseline] + resolvedBaselineOffset }
                        .frame(height: dynamicSize)
                        .frame(minWidth: dynamicSize)
                }
        }
    }

    @ViewBuilder private func alignmentWrapper(@ViewBuilder content: () -> some View) -> some View {
        content()
            .alignmentGuide(.firstTextBaseline, computeValue: baseline)
            .alignmentGuide(.lastTextBaseline, computeValue: baseline)
    }

    @ViewBuilder private func colorWrapper(color: Color?, @ViewBuilder content: () -> some View) -> some View {
        content()
            .foregroundColor(color ?? resolvedColor)
    }

    public var isEmpty: Bool {
        icon?.isEmpty ?? true
    }

    func sfSymbolFont(sizeCategory: ContentSizeCategory, textFontWeight: Font.Weight?) -> Font {
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
}

// MARK: - Inits
public extension Icon {
    
    /// Creates Orbit Icon component for provided icon content.
    ///
    /// - Parameters:
    ///     - content: Icon content. Can optionally include the color override that has a priority over the `.textColor` modifier.
    init(_ content: Icon.Content?, size: Size = .normal) {
        self.icon = content
        self.size = size
    }

    /// Creates Orbit Icon component for provided SF Symbol with specified color.
    init(_ systemName: String, size: Size = .normal) {
        self.init(
            .sfSymbol(systemName, color: nil),
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

// MARK: - Private
public extension Icon {

    /// Defines icon content for use in other components.
    enum Content: Equatable, Hashable {
        /// Orbit transparent icon placeholder. Useful when the layout should behave as if the icon was present.
        case transparent
        /// Orbit skeleton loading icon placeholder.
        case skeleton
        /// Orbit icon symbol with optional color specified. If not specified, it can be overridden using `.textColor()` modifier.
        case symbol(Symbol, color: Color? = nil)
        /// SF Symbol with optional color specified. If not specified, it can be overridden using `.textColor()` modifier.
        case sfSymbol(String, color: Color? = nil)

        /// Specifies whether the item has a non-empty content.
        var isEmpty: Bool {
            switch self {
                case .symbol, .transparent, .skeleton:      return false
                case .sfSymbol(let sfSymbol, _):            return sfSymbol.isEmpty
            }
        }

        /// Accessibility label suitable for the specified icon content.
        var accessibilityLabel: String {
            switch self {
                case .transparent, .skeleton:           return ""
                case .symbol(let symbol, _):            return String(describing: symbol).titleCased
                case .sfSymbol(let sfSymbol, _):        return sfSymbol
            }
        }

        public func hash(into hasher: inout Hasher) {
            switch self {
                case .transparent, .skeleton:           break
                case .symbol(let symbol, _):            hasher.combine(symbol)
                case .sfSymbol(let sfSymbol, _):        hasher.combine(sfSymbol)
            }
        }
    }
}

// MARK: - TextRepresentable
extension Icon: TextRepresentable {

    public func swiftUIText(textRepresentableEnvironment: TextRepresentableEnvironment) -> SwiftUI.Text? {
        if isEmpty {
            return nil
        }

        if #available(iOS 14.0, *) {
            return text(textRepresentableEnvironment: textRepresentableEnvironment)
        } else {
            return textFallback(textRepresentableEnvironment: textRepresentableEnvironment)
        }
    }

    @available(iOS 14.0, *)
    func text(textRepresentableEnvironment: TextRepresentableEnvironment) -> SwiftUI.Text? {
        switch icon {
            case .none:
                return nil
            case .transparent:
                return symbolWrapper(sizeCategory: textRepresentableEnvironment.sizeCategory) {
                    SwiftUI.Text(verbatim: Icon.Symbol.grid.value)
                        .foregroundColor(.clear)
                }
            case .skeleton:
                assertionFailure("text representation of skeleton icon is not supported")
                return nil
            case .symbol(let symbol, let color):
                return symbolWrapper(sizeCategory: textRepresentableEnvironment.sizeCategory) {
                    colorWrapper(color: color, textRepresentableEnvironment: textRepresentableEnvironment) {
                        SwiftUI.Text(verbatim: symbol.value)
                    }
                }
            case .sfSymbol(let systemName, let color):
                return baselineWrapper {
                    colorWrapper(color: color, textRepresentableEnvironment: textRepresentableEnvironment) {
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
        switch icon {
            case .none:
                return nil
            case .transparent:
                return symbolWrapper(sizeCategory: textRepresentableEnvironment.sizeCategory) {
                    SwiftUI.Text(verbatim: Icon.Symbol.grid.value)
                        .foregroundColor(.clear)
                }
            case .skeleton:
                assertionFailure("text representation of skeleton icon is not supported")
                return nil
            case .symbol(let symbol, let color):
                return symbolWrapper(sizeCategory: textRepresentableEnvironment.sizeCategory) {
                    baselineWrapper {
                        colorWrapper(color: color, textRepresentableEnvironment: textRepresentableEnvironment) {
                            SwiftUI.Text(verbatim: symbol.value)
                        }
                    }
                }
            case .sfSymbol:
                assertionFailure("image and sfSymbol text representation is available in iOS 14.0 or newer")
                return nil
        }
    }

    private func colorWrapper(color: Color?, textRepresentableEnvironment: TextRepresentableEnvironment, @ViewBuilder text: () -> SwiftUI.Text) -> SwiftUI.Text {
        text()
            .foregroundColor(color ?? resolvedColor(textRepresentableEnvironment: textRepresentableEnvironment))
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
            Icon(.skeleton)
            Icon(.transparent)
                .border(.inkNormal, width: .hairline)
            Icon(nil) // Results in EmptyView
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
                    .iconColor(.blueNormal)
                Icon(.grid)
                    .textColor(.blueNormal)
                Icon(.grid)
                Icon(.symbol(.grid))
            }

            HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                Icon(sfSymbol)
                    .textColor(nil)
                Icon(sfSymbol)
                    .iconColor(.blueNormal)
                Icon(sfSymbol)
                    .textColor(.blueNormal)
                Icon(sfSymbol)
                Icon(.sfSymbol(sfSymbol))
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
                    Icon(.symbol(symbol))
                    Icon(.symbol(symbol))
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
                    Icon(.sfSymbol(sfSymbol), size: size)
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
