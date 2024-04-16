import SwiftUI

/// Orbit component that displays title that helps to define content hierarchy. 
/// A counterpart of the native `SwiftUI.Text` with one of the title font styles applied.
///
/// A ``Heading`` is created using one of predefined title styles.
///
/// ```swift
/// Heading("Passengers", style: .title2)
/// ```
///
/// ### Customizing appearance
///
/// Textual properties can be modified in two ways:
/// - Modifiers applied directly to `Heading` that return the same type, such as ``textColor(_:)-80ix5`` or ``textAccentColor(_:)-k54u``. 
/// These can also be used for concatenation with other Orbit textual components like ``Text`` or ``Icon``. 
/// See the `InstanceMethods` section below for full list.
/// - Modifiers applied to view hierarchy, such as ``SwiftUI/View/textColor(_:)`` or ``SwiftUI/View/textIsCopyable(_:)``. 
/// See a full list of `View` extensions in documentation.
/// 
/// ```swift
/// VStack {
///     // Will result in `inkNormal` color
///     Heading("Override", type: .title3)
///         .textColor(.inkNormal)
///         
///     // Will result in `blueDark` color passed from environment
///     Heading("Modified", type: .title3)
///     
///     // Will result in a default `inkDark` color, ignoring the environment value
///     Heading("Default", type: .title3)
///         .textColor(nil)
///     
///     // Will result in mixed `redNormal` and `blueDark` colors
///     Heading("Concatenated", type: .title3)
///         .textColor(.redNormal) 
///     + Heading(" Title", type: .title2)
///         .bold()
///     + Icon(.grid)
///         .iconColor(.redNormal)
/// }
/// .textColor(.blueDark)
/// ```
/// 
/// Formatting and behaviour for ``TextLink``s found in the text can be modified by ``textLinkAction(_:)`` and
/// ``textLinkColor(_:)`` modifiers.
/// 
/// ```swift
/// Heading("Information for <applink1>Passenger</applink1>", type: .title3)
///     .textLinkColor(.inkNormal)
///     .textLinkAction {
///         // TextLink tap Action
///     }
/// ```
///
/// ### Layout
///
/// Orbit text components use a designated vertical padding that is the same in both single and multiline variant. 
/// This makes it easier to align them consistently next to other Orbit components like ``Icon`` not only based on the baseline, 
/// but also by `top` or `bottom` edges, provided the component text sizes match according to Orbit rules.
///
/// Orbit text components have a fixed vertical size. 
/// 
/// When the provided content is empty, the component results in `EmptyView` so that it does not take up any space in the layout.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/heading/)
public struct Heading: View, FormattedTextBuildable, PotentiallyEmptyView {

    // Builder properties
    var accentColor: Color?
    var baselineOffset: CGFloat?
    var color: Color?
    var fontWeight: Font.Weight?
    var isBold: Bool?
    var isItalic: Bool?
    var isMonospacedDigit: Bool?
    var isUnderline: Bool?
    var kerning: CGFloat?
    var lineHeight: CGFloat?
    var size: CGFloat?
    var strikethrough: Bool?
        
    private let content: Text
    private let style: Style

    public var body: some View {
        textContent
            .accessibility(addTraits: .isHeader)
    }

    @ViewBuilder private var textContent: Text {
        content
            .textColor(color)
            .textSize(custom: style.size)
            .fontWeight(fontWeight)
            .baselineOffset(baselineOffset)
            .bold(isBold)
            .italic(isItalic)
            .kerning(kerning)
            .monospacedDigit(isMonospacedDigit)
            .strikethrough(strikethrough)
            .underline(isUnderline)
            .textAccentColor(accentColor)
            .textLineHeight(style.lineHeight)
    }
    
    public var isEmpty: Bool {
        content.isEmpty
    }
    
    private init(
        text: Text,
        style: Style
    ) {
        self.content = text
        self.style = style

        // Set default weight
        self.fontWeight = style.weight
    }
}

// MARK: - Inits
public extension Heading {

    /// Creates Orbit ``Heading`` component.
    init(
        _ content: some StringProtocol = String(""),
        style: Style
    ) {
        self.init(text: Text(content), style: style)
    }
    
    /// Creates Orbit ``Heading`` component using localizable key.
    @_semantics("swiftui.init_with_localization")
    init(
        _ keyAndValue: LocalizedStringKey,
        style: Style,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil
    ) {
        self.init(text: Text(keyAndValue, tableName: tableName, bundle: bundle), style: style)
    }
}

// MARK: - Types
public extension Heading {

    /// Orbit ``Heading`` style that represents the default size and color of a title.
    enum Style: Equatable {
        /// 28 pts.
        case title1
        /// 22 pts.
        case title2
        /// 18 pts.
        case title3
        /// 16 pts.
        case title4
        /// 15 pts.
        case title5
        /// 13 pts.
        case title6

        /// Orbit `Heading` ``Heading/Style`` font size.
        public var size: CGFloat {
            switch self {
                case .title1:           return 28
                case .title2:           return 22
                case .title3:           return 18
                case .title4:           return 16
                case .title5:           return 15
                case .title6:           return 13
            }
        }

        /// Orbit `Heading` ``Heading/Style`` designated line height.
        public var lineHeight: CGFloat {
            switch self {
                case .title1:           return 32
                case .title2:           return 28
                case .title3:           return 24
                case .title4:           return 20
                case .title5:           return 20
                case .title6:           return 16
            }
        }

        /// Orbit `Heading` ``Heading/Style`` font weight.
        public var weight: Font.Weight {
            switch self {
                case .title1, .title4, .title5, .title6:    return .bold
                case .title2, .title3:                      return .medium
            }
        }
    }
}

// MARK: - TextRepresentable
extension Heading: TextRepresentable {

    public func text(environment: TextRepresentableEnvironment) -> SwiftUI.Text? {
        content.isEmpty
            ? nil
            : textContent.text(environment: environment)
    }
}

// MARK: - Previews
struct HeadingPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            formatted
            sizes
            lineHeight
            lineSpacing
            concatenated
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            Heading("Heading", style: .title1)
            Heading("", style: .title1) // EmptyView
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var formatted: some View {
        VStack(alignment: .trailing, spacing: .medium) {
            Group {
                Heading("Multiline\nlong heading", style: .title2)
                    .textColor(.inkNormal)
                    .textAccentColor(.greenDark)
                    .kerning(5)
                    .strikethrough()
                    .underline()

                Heading("Multiline\n<ref>long</ref> heading", style: .title2)
                    .textAccentColor(.redNormal)
                    .kerning(5)
                    .strikethrough()
                    .underline()

                Heading("Multiline\n<applink1>long</applink1> heading", style: .title2)
                    .textColor(.orangeNormal)
                    .textAccentColor(.blueDark)
                    .kerning(5)
                    .strikethrough()
                    .underline()
            }
            .multilineTextAlignment(.trailing)
            .lineSpacing(10)
            .border(.cloudNormal)
        }
        .textColor(.blueNormal)
        .padding(.medium)
        .previewDisplayName()
    }
    
    static var sizes: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            formattedHeading("<ref><u>Title 1</u></ref> with a very large and <strong>multiline</strong> content", style: .title1)
            formattedHeading("<ref><u>Title 2</u></ref> with a very very large and <strong>multiline</strong> content", style: .title2)
            formattedHeading("<ref><u>Title 3</u></ref> with a very very very very large and <strong>multiline</strong> content", style: .title3)
            formattedHeading("<ref><u>Title 4</u></ref> with a very very very very large and <strong>multiline</strong> content", style: .title4)
            formattedHeading("<ref><u>Title 5</u></ref> with a very very very very very large and <strong>multiline</strong> content", style: .title5, color: .blueDarker)
            formattedHeading("<ref><u>TITLE 6</u></ref> WITH A VERY VERY VERY VERY VERY LARGE AND <strong>MULTILINE</strong> CONTENT", style: .title6, color: nil)
        }
        .textColor(.inkNormal)
        .padding(.medium)
        .previewDisplayName()
    }

    static var lineHeight: some View {
        VStack(alignment: .trailing, spacing: .medium) {
            VStack(alignment: .trailing, spacing: .xxxSmall) {
                LineHeight(style: .title1, formatted: false)
                LineHeight(style: .title2, formatted: false)
                LineHeight(style: .title3, formatted: false)
                LineHeight(style: .title4, formatted: false)
                LineHeight(style: .title5, formatted: false)
                LineHeight(style: .title6, formatted: false)
            }

            VStack(alignment: .trailing, spacing: .xxxSmall) {
                LineHeight(style: .title1, formatted: true)
                LineHeight(style: .title2, formatted: true)
                LineHeight(style: .title3, formatted: true)
                LineHeight(style: .title4, formatted: true)
                LineHeight(style: .title5, formatted: true)
                LineHeight(style: .title6, formatted: true)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var lineSpacing: some View {
        HStack(alignment: .top, spacing: .xxxSmall) {
            VStack(alignment: .trailing, spacing: .xxxSmall) {
                Group {
                    Heading("Single line", style: .title2)
                        .background(Color.redLightHover)
                    Heading("<applink1>Single</applink1> line", style: .title2)
                        .background(Color.redLightHover.opacity(0.7))
                    Heading("<strong>Single</strong> line", style: .title2)
                        .background(Color.redLightHover.opacity(0.4))
                }
                .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
            }

            Group {
                Heading("Multiline\nwith\n<strong>formatting</strong>", style: .title2)
                Heading("Multiline\nwith\n<applink1>links</applink1>", style: .title2)
            }
            .lineSpacing(.xxxSmall)
            .background(Color.redLightHover.opacity(0.7))
            .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
            .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerLastTextBaseline)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var concatenated: some View {
        Group {
            Icon(.grid)
            +
            Heading(" <ref><u>Title 4</u></ref> with <strong>multiline</strong>", style: .title4)
            +
            Heading(" <ref><u>Title 5</u></ref> with <strong>multiline</strong>", style: .title5)
                .textColor(.greenDark)
                .textAccentColor(.blueDarker)
            +
            Heading(" <ref><u>TITLE 6</u></ref> WITH <strong>MULTILINE</strong> CONTENT", style: .title6)
            +
            Text(" and Text")
        }
        .textColor(.inkDark)
        .padding(.medium)
        .previewDisplayName()
    }

    static func formattedHeading(_ content: String, style: Heading.Style, color: Color? = .inkDark) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Heading(content, style: style)
                .textColor(color)
                .textAccentColor(.blueNormal)
            Spacer()
            Text("\(Int(style.size))/\(Int(style.lineHeight))")
                .textColor(.inkNormal)
                .fontWeight(.medium)
        }
    }

    struct LineHeight: View {

        @Environment(\.sizeCategory) var sizeCategory
        let style: Heading.Style
        let formatted: Bool

        var body: some View {
            HStack(spacing: .xxSmall) {
                Heading(
                    "\(formatted ? "<ref>" : "")\(String(describing:style).capitalized)\(formatted ? "</ref>" : "")",
                    style: style
                )
                .textAccentColor(Status.info.darkColor)
                .fixedSize()
                .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerLastTextBaseline)

                Text("\(style.size.formatted) / \(style.lineHeight.formatted)")
                    .textSize(custom: 6)
                    .environment(\.sizeCategory, .large)
            }
            .padding(.trailing, .xxSmall)
            .border(.redNormal, width: .hairline)
            .measured()
            .padding(.trailing, 40 * sizeCategory.controlRatio)
            .overlay(
                SwiftUI.Text("T")
                    .orbitFont(size: style.size, sizeCategory: sizeCategory)
                    .border(.redNormal, width: .hairline)
                    .measured()
                ,
                alignment: .trailing
            )
        }
    }
}
