import SwiftUI

/// Orbit component that displays one or more lines of read-only text. 
/// A counterpart of the native `SwiftUI.Text` with a support for Orbit markup formatting, ``TextLink``s and custom vertical padding.
///
/// A ``Text`` is created using the `String` verbatim or localizable content that can include 
/// html tags `<strong>`, `<u>`, `<ref>`, `<br>` to customize formatting.
/// Interactive tags `<a href>` and `<applinkX>` can be used to insert ``TextLink``s in the text.
///
/// ```swift
/// Text("Text with <ref>formatting</ref>,<br> <u>multiline</u> content and <a href=\"...\">TextLink</a>")
/// ```
///
/// The Orbit ``Text`` component consists of up to 3 layers on top of each other:
///
/// 1) A base `SwiftUI.Text` layer, either:
///     - `SwiftUI.Text(verbatim:)` (when the whole text is a plain text with no formatting)
///     - `SwiftUI.Text(attributedString:)` (when the text contains any Orbit html formatting)
/// 2) ``TextLink`` overlay (when the text contains ``TextLink``s). The native text modifier support is limited for this layer.
/// 3) A long tap gesture overlay (when the `textIsCopyable` is `true`)
///
/// ### Localization
/// 
/// The localization follows the same pattern as the native ``SwiftUI.Text``.
/// The default `main` bundle can be modified by using ``SwiftUI/View/localizationBundle(_:)`` modifier.
///
/// ### Concatenation
/// 
/// The Orbit Text supports concatenation, but does not fully support concatenating text that includes interactive ``TextLink``s.
/// It also does not fully support some global SwiftUI native text formatting view modifiers.
/// For proper rendering of `TextLinks`, any required text formatting modifiers must be also called on the `Text` directly.
///
/// ### Customizing appearance
///
/// Textual properties can be modified in two ways:
/// - Modifiers applied directly to `Text` that return the same type, such as ``textColor(_:)-7qk2x`` or ``textAccentColor(_:)-xmqw``. 
/// These can also be used for concatenation with other Orbit textual components like ``Heading`` or ``Icon``. 
/// See the `InstanceMethods` section below for full list.
/// - Modifiers applied to view hierarchy, such as ``SwiftUI/View/textColor(_:)`` or ``SwiftUI/View/textIsCopyable(_:)``.
/// See a full list of `View` extensions in documentation.
/// 
/// ```swift
/// VStack {
///     // Will result in `inkNormal` color
///     Text("Override")
///         .textColor(.inkNormal)
///         
///     // Will result in `blueDark` color passed from environment
///     Text("Modified")
///     
///     // Will result in a default `inkDark` color, ignoring the environment value
///     Text("Default")
///         .textColor(nil)
///     
///     // Will result in mixed `redNormal` and `blueDark` colors
///     Text("Concatenated")
///         .textColor(.redNormal) 
///     + Text(" Title")
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
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/text/)
public struct Text: View, FormattedTextBuildable, PotentiallyEmptyView {

    @Environment(\.multilineTextAlignment) private var multilineTextAlignment
    @Environment(\.lineSpacing) private var lineSpacing
    @Environment(\.locale) private var locale
    @Environment(\.localizationBundle) private var localizationBundle
    @Environment(\.textAccentColor) private var textAccentColor
    @Environment(\.textColor) private var textColor
    @Environment(\.textFontWeight) private var textFontWeight
    @Environment(\.textIsCopyable) private var textIsCopyable
    @Environment(\.textLineHeight) private var textLineHeight
    @Environment(\.textSize) private var textSize
    @Environment(\.sizeCategory) private var sizeCategory

    private let verbatimContent: String
    
    // Localization
    private let localization: TextLocalization?
    
    // Builder properties
    var size: CGFloat?
    var baselineOffset: CGFloat?
    var fontWeight: Font.Weight?
    var color: Color?
    var strikethrough: Bool?
    var kerning: CGFloat?
    var accentColor: Color?
    var isBold: Bool?
    var isItalic: Bool?
    var isUnderline: Bool?
    var isMonospacedDigit: Bool?
    var lineHeight: CGFloat?

    public var body: some View {
        if isEmpty == false {
            text(textRepresentableEnvironment: textRepresentableEnvironment)
                .lineSpacing(lineSpacingAdjusted)
                .overlay(copyableText)
                // If the text contains links, the TextLink overlay takes accessibility priority
                .accessibility(hidden: content(textRepresentableEnvironment.locale).containsTextLinks)
                .overlay(textLinks)
                .padding(.vertical, textRepresentableEnvironment.lineHeightPadding(lineHeight: lineHeight, size: size))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder private var textLinks: some View {
        if content(locale).containsTextLinks {
            TextLink(textLinkAttributedString(textRepresentableEnvironment: textRepresentableEnvironment))
        }
    }

    @ViewBuilder private var copyableText: some View {
        if textIsCopyable {
            CopyableText(
                attributedString(textRepresentableEnvironment: textRepresentableEnvironment).string
            )
        }
    }
    
    var isEmpty: Bool {
        verbatimContent.isEmpty
    }

    func text(textRepresentableEnvironment: TextRepresentableEnvironment, isConcatenated: Bool = false) -> SwiftUI.Text {
        if content(textRepresentableEnvironment.locale).containsHtmlFormatting {
            return modifierWrapper(
                SwiftUI.Text(
                    attributedString(
                        textRepresentableEnvironment: textRepresentableEnvironment,
                        isConcatenated: isConcatenated
                    )
                )
            )
        } else {
            return modifierWrapper(
                fontWeightWrapper(
                    boldWrapper(
                        SwiftUI.Text(verbatim: content(textRepresentableEnvironment.locale))
                            .foregroundColor(textRepresentableEnvironment.resolvedColor(color))
                    )
                )
            )
            .font(textRepresentableEnvironment.font(size: size, weight: fontWeight, isBold: isBold))
        }
    }
    
    private func content(_ locale: Locale) -> String {
        switch localization {
            case .key(let localizedStringKey, let bundle, let tableName, let explicitKey):
                localizedStringKey.localized(locale: locale, bundle: bundle ?? localizationBundle, tableName: tableName, explicitKey: explicitKey) ?? verbatimContent
            case .resource(let resource):
                resolvedLocalizedStringResource(resource, locale: locale) ?? verbatimContent
            case nil:
                verbatimContent
        }
    }
    
    private func resolvedLocalizedStringResource(_ resource: Any, locale: Locale) -> String? {
        if #available(iOS 16, *) {
            if let resource = resource as? LocalizedStringResource {
                var res = resource
                res.locale = locale
                return String(localized: res)
            }
        }
        
        return nil
    }

    private var textRepresentableEnvironment: TextRepresentableEnvironment {
        .init(
            iconColor: nil,
            iconSize: nil,
            locale: locale,
            textAccentColor: textAccentColor,
            textColor: textColor,
            textFontWeight: textFontWeight,
            textLineHeight: lineHeight,
            textSize: textSize,
            sizeCategory: sizeCategory
        )
    }

    private func boldWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if #available(iOS 16.0, *), let isBold {
            return text
                .bold(isBold)
        } else if let isBold, isBold {
            return text
                .bold()
        } else {
            return text
        }
    }

    private func italicWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if #available(iOS 16.0, *), let isItalic {
            return text
                .italic(isItalic)
        }
        else if let isItalic, isItalic {
            return text
                .italic()
        } else {
            return text
        }
    }

    private func strikethroughWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if let strikethrough {
            return text
                .strikethrough(strikethrough)
        } else {
            return text
        }
    }

    private func underlineWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if let isUnderline {
            return text
                .underline(isUnderline)
        } else {
            return text
        }
    }

    private func monospacedDigitWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if #available(iOS 15.0, *), let isMonospacedDigit, isMonospacedDigit {
            return text
                .monospacedDigit()
        } else {
            return text
        }
    }

    private func kerningWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if let kerning {
            return text
                .kerning(kerning)
        } else {
            return text
        }
    }

    private func baselineOffsetWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if let baselineOffset {
            return text
                .baselineOffset(baselineOffset)
        } else {
            return text
        }
    }

    private func fontWeightWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        if let fontWeight {
            return text
                .fontWeight(fontWeight)
        } else {
            return text
        }
    }

    private func modifierWrapper(_ text: SwiftUI.Text) -> SwiftUI.Text {
        // Stacks all optional modifier overrides
        // except those that are not relevant to mixed html formatted text
        monospacedDigitWrapper(
            underlineWrapper(
                baselineOffsetWrapper(
                    strikethroughWrapper(
                        kerningWrapper(
                            italicWrapper(
                                // fontWeight and bold are omitted as they would override the mixed AttributedString
                                text
                            )
                        )
                    )
                )
            )
        )
    }

    private func textLinkAttributedString(
        textRepresentableEnvironment: TextRepresentableEnvironment
    ) -> NSAttributedString {
        TagAttributedStringBuilder.all.attributedString(
            content(textRepresentableEnvironment.locale),
            alignment: multilineTextAlignment,
            fontSize: textRepresentableEnvironment.scaledSize(size),
            fontWeight: textRepresentableEnvironment.resolvedFontWeight(fontWeight, isBold: isBold),
            lineSpacing: lineSpacingAdjusted,
            kerning: kerning,
            strikethrough: strikethrough ?? false,
            color: .clear,
            accentColor: .clear
        )
    }

    private func attributedString(
        textRepresentableEnvironment: TextRepresentableEnvironment,
        isConcatenated: Bool = false
    ) -> NSAttributedString {
        TagAttributedStringBuilder.all.attributedString(
            content(textRepresentableEnvironment.locale),
            alignment: multilineTextAlignment,
            fontSize: textRepresentableEnvironment.scaledSize(size),
            fontWeight: textRepresentableEnvironment.resolvedFontWeight(fontWeight, isBold: isBold),
            lineSpacing: lineSpacingAdjusted,
            kerning: kerning,
            color: textRepresentableEnvironment.resolvedColor(color).uiColor,
            linkColor: isConcatenated ? nil : .clear,
            accentColor: textRepresentableEnvironment.resolvedAccentColor(accentColor, color: color).uiColor
        )
    }

    private var lineSpacingAdjusted: CGFloat {
        textRepresentableEnvironment.lineSpacingAdjusted(lineSpacing, lineHeight: lineHeight, size: size)
    }
}

// MARK: - Inits (Localized)

public extension Text {
    
    /// Creates Orbit ``Text`` component that displays a localized content identified by a separate key and default value.
    ///
    /// - Parameters:
    ///   - key: The unique key for a string in the table identified by `tableName`.
    ///   - value: The default value for a string in the table identified by `tableName`.
    ///   - tableName: The name of the string table to search.
    ///   - bundle: The bundle containing the strings file. If `nil`, use the
    ///     main bundle.
    ///   - comment: Contextual information about this key-value pair.
    @_semantics("swiftui.init_with_localization")
    init(
        _ key: StaticString,
        value: LocalizedStringKey,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil
    ) {
        self.localization = .key(value, bundle: bundle, tableName: tableName, explicitKey: key.description)
        self.verbatimContent = String(describing: key)
    }
    
    /// Creates Orbit ``Text`` component that displays a localized content identified by a key.
    ///
    /// - Parameters:
    ///   - keyAndValue: The key for a string in the table identified by `tableName`.
    ///   - tableName: The name of the string table to search.
    ///   - bundle: The bundle containing the strings file. If `nil`, use the
    ///     main bundle.
    ///   - comment: Contextual information about this key-value pair.
    @_semantics("swiftui.init_with_localization")
    init(
        _ keyAndValue: LocalizedStringKey,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil
    ) {
        self.localization = .key(keyAndValue, bundle: bundle, tableName: tableName)
        self.verbatimContent = keyAndValue.key ?? ""
    }
}

// MARK: iOS16+
@available(iOS 16, *)
public extension Text {
    
    /// Creates Orbit ``Text`` component that displays a localized string resource.
    ///
    /// - Parameter resource: Localized resource to display.
    @_disfavoredOverload
    @_semantics("swiftui.init_with_localization")
    init(_ resource: LocalizedStringResource) {
        self.localization = .resource(resource)
        self.verbatimContent = resource.key
    }
}

// MARK: - Inits (Verbatim)
public extension Text {
    
    /// Creates Orbit ``Text`` component that displays a stored string without localization.
    ///
    /// - Parameter content: The string value to display without localization.
    @_disfavoredOverload
    init<S: StringProtocol>(_ content: S) {
        self.init(verbatim: String(content))
    }
    
    /// Creates Orbit ``Text`` component that displays a string literal without localization.
    ///
    /// - Parameter resource: A string to display without localization.
    init(verbatim content: String) {
        self.localization = nil
        self.verbatimContent = content
    }
}

// MARK: - Types
public extension Text {

    /// Orbit predefined ``Text`` font size.
    enum Size: Equatable {
        /// 13 pts.
        case small
        /// 15 pts.
        case normal
        /// 16 pts.
        case large
        /// 18 pts.
        case xLarge

        public static func lineHeight(forTextSize size: CGFloat) -> CGFloat {
            switch size {
                case 13:    return 16
                case 15:    return 20
                case 16:    return 24
                case 18:    return 24
                default:    return size * Font.fontSizeToLineHeightRatio
            }
        }

        /// Value of Orbit `Text` ``Text/Size``.
        public var value: CGFloat {
            switch self {
                case .small:                        return 13
                case .normal:                       return 15
                case .large:                        return 16
                case .xLarge:                       return 18
            }
        }

        /// Designated line height for Orbit `Text` ``Text/Size``.
        public var lineHeight: CGFloat {
            switch self {
                case .small:                        return 16
                case .normal:                       return 20
                case .large:                        return 24
                case .xLarge:                       return 24
            }
        }
    }
}

enum TextLocalization {
    case key(LocalizedStringKey, bundle: Bundle?, tableName: String? = nil, explicitKey: String? = nil)
    case resource(Any)
}

// MARK: - TextRepresentable
extension Text: TextRepresentable {

    public func swiftUIText(textRepresentableEnvironment: TextRepresentableEnvironment) -> SwiftUI.Text? {
        if isEmpty { return nil }

        return text(textRepresentableEnvironment: textRepresentableEnvironment, isConcatenated: true)
    }
}

@available(iOS 16, *)
extension LocalizedStringResource.BundleDescription {
    
    fileprivate var bundle: Bundle? {        
        switch self {
            case .forClass(let anyClass):   Bundle(for: anyClass)
            case .atURL(let uRL):           Bundle(url: uRL)
            case .main:                     .main
            @unknown default:               .main
        }
    }
}
    
// MARK: - Previews
struct TextPreviews: PreviewProvider {

    static let multilineText = "Text with multiline content \n with no formatting or text links"
    static let multilineFormattedText = "Text with <ref>formatting</ref>,<br> <u>multiline</u> content <br> and <a href=\"...\">text link</a>"

    static let plainText = "Text"
    static let markdownText = "Text **str** *ita*"
    static let htmlText = "Text <strong>str</strong> <u>und</u> <ref>acc</ref> <applink1>lnk</applink1>"
    static let plusText = " + "

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizes
            multilineFormatting
            formatting
            monospaced
            lineHeight
            lineSpacing
            interactive
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var standalone: some View {
        VStack(alignment: .trailing, spacing: .medium) {
            Text("Multiline text\nplain with with no formatting")
            Text("Multiline text\n<strong>selectable</strong> (with long tap gesture)")
                .textIsCopyable()

            Text(
"""
Multiline text <u>underlined</u>, <strong>strong</strong>, <ref>accented</ref>,
<strong><u>underlined strong</u></strong>, <ref><u>underlined accented</u></ref>
"""
            )

            Text("""
Multiline <applink1>text</applink1> <u>underlined</u>, <strong>strong</strong>, <ref>accented</ref>,
<strong><u>underlined strong</u></strong>, <ref><u>underlined accented</u></ref>,
<strong><applink1>TextLink strong</applink1></strong>
"""
            )
            .textAccentColor(.orangeNormal)

            Text("") // Results in EmptyView
        }
        .textAccentColor(.blueNormal)
        .multilineTextAlignment(.trailing)
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizes: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Group {
                text("Text Small", size: .small, weight: .regular)
                text("Text Normal", size: .normal, weight: .regular)
                text("Text Large", size: .large, weight: .regular)
                text("Text Extra Large", size: .xLarge, weight: .regular)
            }

            Separator()

            Group {
                text("Text Medium Small", size: .small, weight: .medium)
                text("Text Medium Normal", size: .normal, weight: .medium)
                text("Text Medium Large", size: .large, weight: .medium)
                text("Text Medium Extra Large", size: .xLarge, weight: .medium)
            }

            Separator()

            Group {
                text("Text Bold Small", size: .small, weight: .bold)
                text("Text Bold Normal", size: .normal, weight: .bold)
                text("Text Bold Large", size: .large, weight: .bold)
                text("Text Bold Extra Large", size: .xLarge, weight: .bold)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var multilineFormatting: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Group {
                Text("Selectable text (on long tap)")
                    .textIsCopyable()
                Text("Text with no formatting")
                Text("Text <u>formatted</u> <strong>and</strong> <ref>accented</ref>")
                    .textAccentColor(.orangeNormal)
                Text("<applink1>Text</applink1> <u>formatted</u> <strong>and</strong> <ref>accented</ref>")
                    .textAccentColor(.orangeNormal)

                if #available(iOS 16.0, *) {
                    Group {
                        Text("Text with kerning and strikethrough")
                        Text("Text <u>with kerning</u> <strong>and</strong> <ref>strikethrough</ref>")
                        Text(
                            "<applink1>Text</applink1> <u>with kerning</u> <strong>and</strong> <strong><applink2>strikethrough</applink2></strong>"
                        )
                        .kerning(6)
                        .strikethrough()
                    }
                    .textAccentColor(.orangeNormal)
                    .lineSpacing(10)
                    .kerning(6)
                    .strikethrough()
                }
            }
            .border(.cloudDark, width: .hairline)

            Text(multilineText)
                .textColor(.greenDark)
                .background(Color.greenLight)
            Text(multilineText)
                .textColor(.blueDark)
                .background(Color.blueLight)
            Text(multilineFormattedText)
                .textColor(.greenDark)
                .textAccentColor(.orangeDark)
                .background(Color.greenLight)
            Text(multilineFormattedText)
                .textAccentColor(.orangeDark)
                .textColor(.blueDark)
                .background(Color.blueLight)

            // This text may reveal issues between iOS TextLink word wrapping
            Text(
                "By continuing, you accept the <applink1>Terms Of Use</applink1> and <applink2>Privacy Policy</applink2>."
            )
            .textSize(.small)
            .textColor(.inkNormal)
            .textLinkColor(.secondary)
            .multilineTextAlignment(.leading)
        }
        .multilineTextAlignment(.trailing)
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var formatting: some View {
        TextFormattingPreviews.FormattingTable()
    }

    static var monospaced: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Group {
                    Text("1111111111")
                    Text("8888888888")
                    Text("1111111111")
                        .monospacedDigit()
                    Text("8888888888")
                        .monospacedDigit()
                }
                .border(.cloudNormal, width: .hairline)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var lineHeight: some View {
        VStack(alignment: .trailing, spacing: .medium) {
            VStack(alignment: .trailing, spacing: .xxxSmall) {
                LineHeight(size: .small, formatted: false)
                LineHeight(size: .normal, formatted: false)
                LineHeight(size: .large, formatted: false)
                LineHeight(size: .xLarge, formatted: false)
            }
            VStack(alignment: .trailing, spacing: .xxxSmall) {
                LineHeight(size: .small, formatted: true)
                LineHeight(size: .normal, formatted: true)
                LineHeight(size: .large, formatted: true)
                LineHeight(size: .xLarge, formatted: true)
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var lineSpacing: some View {
        HStack(alignment: .top, spacing: .xxxSmall) {
            VStack(alignment: .trailing, spacing: .xxxSmall) {
                Group {
                    Text("Text single line")
                        .background(Color.redLightHover)
                    Text("Text <applink1>single</applink1> line")
                        .background(Color.redLightHover.opacity(0.7))
                    Text("Text <strong>single</strong> line")
                        .background(Color.redLightHover.opacity(0.4))
                }
                .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
            }

            Group {
                Text("Multliline\nwith\n<strong>formatting</strong>")
                Text("Multliline\nwith\n<applink1>links</applink1>")
            }
            .lineSpacing(.xxxSmall)
            .background(Color.redLightHover.opacity(0.7))
            .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerFirstTextBaseline)
            .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerLastTextBaseline)
        }
        .textSize(.large)
        .padding(.medium)
        .previewDisplayName()
    }

    static var interactive: some View {
        StateWrapper((0.7, 0.7, 0.7)) { state in
            ScrollView {
                VStack(alignment: .leading, spacing: .medium) {
                    Text(
                        """
                        An <ref>attributed text</ref> that can contain <a href="https://kiwi.com">multiple</a> \
                        HTML <a href="https://www.apple.com">links</a> with \
                        <u>underline</u> and <strong>strong</strong> support.
                        """
                    )
                    .textAccentColor(.redNormal)
                    .border(.cloudDark, width: .hairline)
                    .padding(.trailing, 200 * (1 - state.wrappedValue.0))

                    SwiftUI.Slider(
                        value: Binding<Double>(get: { state.wrappedValue.0 }, set: { state.wrappedValue.0 = $0 }),
                        in: 0...1
                    )

                    Text(
                        """
                        An <ref>attributed text</ref> that can contain <a href="https://kiwi.com">multiple</a> \
                        HTML <a href="https://www.apple.com">links</a> with \
                        <u>underline</u> and <strong>strong</strong> support.
                        """
                    )
                    .textSize(custom: 12)
                    .textColor(.blueLightActive)
                    .bold()
                    .textAccentColor(.blueNormal)
                    .border(.cloudNormal)
                    .padding(.leading, 200 * (1 - state.wrappedValue.1))

                    SwiftUI.Slider(
                        value: Binding<Double>(get: { state.wrappedValue.1 }, set: { state.wrappedValue.1 = $0 }),
                        in: 0...1
                    )

                    Text(
                        """
                        A normal basic very very long text that contains no tags or links.
                        """
                    )
                    .border(.cloudNormal)
                    .padding(.trailing, 200 * (1 - state.wrappedValue.2))

                    SwiftUI.Slider(
                        value: Binding<Double>(get: { state.wrappedValue.2 }, set: { state.wrappedValue.2 = $0 }),
                        in: 0...1
                    )

                    Text(
                        """
                        Line limit is set to <ref>2</ref>.
                        An <ref>attributed text</ref> that can contain <a href="https://kiwi.com">multiple</a> \
                        HTML <a href="https://www.apple.com">links</a> with \
                        <u>underline</u> and <strong>strong</strong> support.
                        """
                    )
                    .textSize(custom: 22)
                    .textColor(.inkNormal)
                    .bold()
                    .lineLimit(2)
                    .border(.cloudNormal)
                }
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    struct LineHeight: View {

        @Environment(\.sizeCategory) var sizeCategory
        let size: Text.Size
        let formatted: Bool

        var body: some View {
            HStack(spacing: .xxSmall) {
                Text("\(sizeText) \(formatted ? "<applink1>" : "")\(String(describing: size))\(formatted ? "</applink1>" : "")")
                    .textSize(size)
                    .textAccentColor(Status.info.darkColor)
                    .fixedSize()
                    .overlay(Separator(color: .redNormal, thickness: .hairline), alignment: .centerLastTextBaseline)

                Text("\(size.value.formatted) / \(size.lineHeight.formatted)")
                    .textSize(custom: 6)
                    .environment(\.sizeCategory, .large)
            }
            .padding(.trailing, .xxSmall)
            .border(.redNormal, width: .hairline)
            .measured()
            .padding(.trailing, 40 * sizeCategory.controlRatio)
            .overlay(
                SwiftUI.Text("T")
                    .orbitFont(size: size.value, sizeCategory: sizeCategory)
                    .border(.redNormal, width: .hairline)
                    .measured()
                ,
                alignment: .trailing
            )
        }

        var sizeText: String {
            formatted
                ? "<ref>Orbit</ref>"
                : "Orbit"
        }
    }

    static func text(_ content: String, size: Text.Size, weight: Font.Weight) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: .small) {
            Text(content)
                .textSize(size)
                .fontWeight(weight)
            Spacer()
            Text("\(Int(size.value))/\(Int(size.lineHeight))")
                .textColor(.inkNormal)
                .fontWeight(.medium)
        }
    }
}
