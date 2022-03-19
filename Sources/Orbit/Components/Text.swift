import SwiftUI

/// Renders text blocks in styles to fit the purpose.
///
/// Can contain html formatted text that will be rendered as interactive ``TextLink`` layer.
///
/// - Related components:
///   - ``Heading``
///   - ``TextLink``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/text/)
/// - Important: Component has fixed vertical size.
public struct Text: View {

    let content: String
    let size: Size
    let color: Color?
    let weight: Font.Weight
    let lineSpacing: CGFloat?
    let alignment: TextAlignment
    let accentColor: UIColor
    let linkColor: UIColor
    let linkAction: TextLink.Action
    let isSelectable: Bool

    public var body: some View {
        if content.isEmpty == false {
            if content.containsHtmlFormatting {
                SwiftUI.Text(attributedText)
                    .multilineTextAlignment(alignment)
                    .lineSpacing(lineSpacing ?? 0)
                    .fixedSize(horizontal: false, vertical: true)
                    .overlay(selectableText)
                    .overlay(textLinks)
            } else {
                SwiftUI.Text(verbatim: content)
                    .foregroundColor(foregroundColor.map(SwiftUI.Color.init))
                    .font(.orbit(size: scaledSize, weight: weight))
                    .lineSpacing(lineSpacing ?? 0)
                    .multilineTextAlignment(alignment)
                    .fixedSize(horizontal: false, vertical: true)
                    .overlay(selectableText)
            }
        }
    }

    @ViewBuilder var textLinks: some View {
        if content.containsTextLinks {
            GeometryReader { geometry in
                TextLink(content: textLinkContent, size: geometry.size, color: linkColor) { url, text in
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                    linkAction(url, text)
                }
                .accessibility(addTraits: .isLink)
            }
        }
    }

    @ViewBuilder var selectableText: some View {
        if isSelectable {
            GeometryReader { geometry in
                SelectableLabelWrapper(text: attributedText.string)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
            }
        }
    }

    var textLinkContent: NSAttributedString {
        TagAttributedStringBuilder.all.attributedStringForLinks(
            content,
            fontSize: size.value,
            fontWeight: weight,
            lineSpacing: lineSpacing,
            alignment: alignment
        )
    }

    var foregroundColor: UIColor? {
        color?.uiValue
    }

    var attributedText: NSAttributedString {
        TagAttributedStringBuilder.all.attributedString(
            content,
            fontSize: size.value,
            fontWeight: weight,
            lineSpacing: lineSpacing,
            color: foregroundColor,
            linkColor: .clear,
            accentColor: accentColor
        )
    }

    var scaledSize: CGFloat {
        #if DEBUG
        return UIFontMetrics.default.scaledValue(for: size.value)
        #else
        return size.value
        #endif
    }
}

// MARK: - Inits
public extension Text {
    
    /// Creates Orbit Text component that displays a string literal.
    ///
    /// - Parameter content: String to display. Supports html formatting tags
    /// `<strong>`, `<u>`, `<ref>`, `<a href>` and `<applink>`.
    /// - Parameter size: Font size.
    /// - Parameter color: Font color (overridable by formatting).
    /// - Parameter weight: Base font weight (overridable by formatting).
    /// - Parameter lineSpacing: Distance in points between the bottom of one line fragment and the top of the next.
    /// - Parameter alignment: Horizontal alignment.
    /// - Parameter accentColor: Color for `<ref>` formatting tag.
    /// - Parameter linkColor: Color for `<a href>` and `<applink>` formatting tag.
    /// - Parameter linkAction: Handler for any detected TextLink tap action.
    /// - Parameter isSelectable: Determines if text is copyable using long tap gesture.
    init(
        _ content: String,
        size: Size = .normal,
        color: Color? = .inkNormal,
        weight: Font.Weight = .regular,
        lineSpacing: CGFloat? = nil,
        alignment: TextAlignment = .leading,
        accentColor: UIColor? = nil,
        linkColor: UIColor = TextLink.defaultColor,
        isSelectable: Bool = false,
        linkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.content = content
        self.size = size
        self.color = color
        self.weight = weight
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.accentColor = accentColor ?? color?.uiValue ?? .inkNormal
        self.linkColor = linkColor
        self.isSelectable = isSelectable
        self.linkAction = linkAction
    }
}

// MARK: - Types
public extension Text {

    enum Size {
        /// 12 pts.
        case small
        /// 14 pts.
        case normal
        /// 16 pts.
        case large
        /// 18 pts.
        case xLarge
        case custom(CGFloat)

        public var value: CGFloat {
            switch self {
                case .small:                return 12
                case .normal:               return 14
                case .large:                return 16
                case .xLarge:               return 18
                case .custom(let size):     return size
            }
        }
        
        public var lineHeight: CGFloat {
            switch self {
                case .small:                return 16
                case .normal:               return 20
                case .large:                return 24
                case .xLarge:               return 24
                case .custom(let size):     return size + 4
            }
        }
        
        public var iconSize: CGFloat {
            switch self {
                case .large:                return 22
                default:                    return lineHeight
            }
        }
    }

    enum Color: Equatable {
        case inkNormal
        case inkLight
        case white
        case custom(UIColor)

        var value: SwiftUI.Color {
            SwiftUI.Color(uiValue)
        }
        
        var uiValue: UIColor {
            switch self {
                case .inkNormal:            return .inkNormal
                case .inkLight:             return .inkLight
                case .white:                return .white
                case .custom(let color):    return color
            }
        }
    }
}

// MARK: - Constants
extension Text {
    public static var firstBaselineRatio: CGFloat { 0.35 }
}

// MARK: - Previews
struct TextPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            selectable
            formatted
            snapshots
            attributedTextSnapshots
            attributedTextInteractive
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Text("Text plain")
            .previewDisplayName("Standalone")
    }

    static var selectable: some View {
        Text("Text selectable", isSelectable: true)
            .previewDisplayName("Selectable")
    }

    static var multilineText: String {
        "Text longer and multiline with no links"
    }

    static var multilineFormattedText: String {
        "Text longer and <u>multiline</u> with <a href=\"...\">text link</a>"
    }

    @ViewBuilder static var formatted: some View {

        Text("Text <u>formatted</u>", accentColor: .orangeNormal)
            .border(Color.cloudDark)
            .previewDisplayName("Text - formatted")

        Group {
            Text(multilineText)
                .previewDisplayName("Text - multiline")

            Text(multilineFormattedText)
                .previewDisplayName("Text - formatted multiline")
            
            Text(multilineFormattedText, color: .none)
                .foregroundColor(.blueDark)
                .previewDisplayName("Text - formatted multiline with color override")

            Text(multilineText, alignment: .trailing)
                .previewDisplayName("Text - multiline")

            Text(multilineFormattedText, alignment: .trailing)
                .previewDisplayName("Text - formatted multiline")
        }
        .border(Color.cloudDark)
        .frame(width: 150)
    }

    @ViewBuilder static var figma: some View {
        Group {
            Text("Text Small", size: .small)
            Text("Text Normal")
            Text("Text Large", size: .large)
            Text("Text Extra Large", size: .xLarge)
        }

        Separator()

        Group {
            Text("Text Medium Small", size: .small, weight: .medium)
            Text("Text Medium Normal", size: .normal, weight: .medium)
            Text("Text Medium Large", size: .large, weight: .medium)
            Text("Text Medium Extra Large", size: .xLarge, weight: .medium)
        }

        Separator()

        Group {
            Text("Text Bold Small", size: .small, weight: .bold)
            Text("Text Bold Normal", size: .normal, weight: .bold)
            Text("Text Bold Large", size: .large, weight: .bold)
            Text("Text Bold Extra Large", size: .xLarge, weight: .bold)
        }
    }

    static var snapshots: some View {
        VStack(alignment: .leading, spacing: .medium) {
            figma

            Separator()

            Text("Very very very very very very very very very very very very long text.", size: .large, weight: .bold)

            Separator()

            Group {
                Text("Text custom size", size: .custom(5))
                Text("Text custom size", size: .custom(21))
                
                Text("Text <strong>formatted</strong> custom size", size: .custom(5))
                Text("Text <strong>formatted</strong> custom size", size: .custom(21))
                
                Text("Text <applink1>TextLink</applink1> custom size", size: .custom(5))
                Text("Text <applink1>TextLink</applink1> custom size", size: .custom(21))
                Separator()
            }
            
            Group {
                Text("Text Normal - Undefined color, modified to Blue", size: .normal, color: nil)
                    .foregroundColor(.blueNormal)
                    .foregroundColor(.redNormal)
                Text("Text Normal - InkLight color", size: .normal, color: .inkLight)
                    .foregroundColor(.blueNormal)
                    .foregroundColor(.redNormal)
                Text("Text Normal - Custom color", size: .normal, color: .custom(.productDark))
                    .foregroundColor(.blueNormal)
                    .foregroundColor(.redNormal)
                
                Separator()
            }

            Group {
                Text("Text Normal, M")
                    .environment(\.sizeCategory, .medium)
                Text("Text Normal, XS")
                    .environment(\.sizeCategory, .extraSmall)
                Text("Text Normal, XXXL")
                    .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }

    static var snapshotsSizing: some View {
        VStack(spacing: .medium) {
            standalone
                .border(Color.cloudDark)
            formatted
        }
    }

    static var attributedTextInteractive: some View {
        PreviewWrapperWithState(initialState: (0.7, 0.7, 0.7)) { state in
            ScrollView {
                VStack(alignment: .leading, spacing: .medium) {
                    Text(
                        """
                        An <ref>attributed text</ref> that can contain <a href="https://kiwi.com">multiple</a> \
                        HTML <a href="https://www.apple.com">links</a> with \
                        <u>underline</u> and <strong>strong</strong> support.
                        """,
                        accentColor: .redNormal
                    )
                    .border(Color.cloudDark)
                    .padding(.trailing, 200 * (1 - state.wrappedValue.0))

                    Slider(
                        value: Binding<Double>(get: { state.wrappedValue.0 }, set: { state.wrappedValue.0 = $0 }),
                        in: 0...1
                    )

                    Text(
                        """
                        An <ref>attributed text</ref> that can contain <a href="https://kiwi.com">multiple</a> \
                        HTML <a href="https://www.apple.com">links</a> with \
                        <u>underline</u> and <strong>strong</strong> support.
                        """,
                        size: .custom(12),
                        color: .custom(.blueLightActive),
                        weight: .bold,
                        accentColor: .blueNormal
                    )
                    .border(Color.cloudDark)
                    .padding(.leading, 200 * (1 - state.wrappedValue.1))

                    Slider(
                        value: Binding<Double>(get: { state.wrappedValue.1 }, set: { state.wrappedValue.1 = $0 }),
                        in: 0...1
                    )

                    Text(
                        """
                        A normal basic very very long text that contains no tags or links.
                        """
                    )
                    .border(Color.cloudDark)
                    .padding(.trailing, 200 * (1 - state.wrappedValue.2))

                    Slider(
                        value: Binding<Double>(get: { state.wrappedValue.2 }, set: { state.wrappedValue.2 = $0 }),
                        in: 0...1
                    )

                    Text(
                        """
                        Line limit is set to <ref>2</ref>.
                        An <ref>attributed text</ref> that can contain <a href="https://kiwi.com">multiple</a> \
                        HTML <a href="https://www.apple.com">links</a> with \
                        <u>underline</u> and <strong>strong</strong> support.
                        """,
                        size: .custom(22),
                        color: .inkLight,
                        weight: .bold
                    )
                    .lineLimit(2)
                    .border(Color.cloudDark)
                }
            }
            .padding()
            .previewDisplayName("Live Preview")
            .previewLayout(.sizeThatFits)
        }
    }

    static var attributedTextSnapshots: some View {
        VStack(alignment: .leading, spacing: .medium) {

            Text("An <ref>attributed</ref> text <a href=\"..\">link</a>", accentColor: .orangeNormal)
                .border(Color.cloudDarker)
                .padding()

            Text(
                """
                Custom line height set to 12pt.
                Custom line height set to 12pt.
                Custom line height set to 12pt.
                """,
                lineSpacing: Spacing.small
            )
            .padding()

            Text(
                """
                <b>Custom line height</b> set to 12pt.
                <b>Custom line height</b> set to 12pt.
                <b>Custom line height</b> set to 12pt.
                """,
                lineSpacing: Spacing.small
            )
            .padding()

            Button("An <ref><u>attributed</u></ref> button")
                .padding(.horizontal)

            ButtonLink("An <ref>attributed</ref> <u>button</u> <applink1>link</applink1>")
                .padding(.horizontal)

            Card("Attributed alert inside Card", action: .buttonLink("Edit")) {
                Alert(
                    "Alert",
                    description: "<strong>Strong</strong> description with <a href=\"https://www.apple.com\">link</a>",
                    icon: .alert,
                    buttons: .primary("<strong>OK</strong> then, why <u>not</u>"),
                    status: .warning
                )
            }

            Card("Attributed text inside Card", action: .buttonLink("Edit")) {
                Text(
                    """
                    An <ref>attributed text</ref> that can contain <a href="https://kiwi.com">multiple</a> \
                    HTML <a href="https://www.apple.com">links</a> with \
                    <u>underline</u> and <strong>strong</strong> support.
                    """,
                    accentColor: .orangeNormal
                )

                HStack {
                    Badge("<strong>Strong</strong> badge <u>label</u>", icon: .accommodation)
                    Badge("<strong>Strong</strong> badge <u>label</u>", style: .status(.success, inverted: true))
                    Spacer(minLength: 0)
                }
                BadgeList("<strong>Strong</strong> badge <u>label</u>", icon: .accommodation, style: .status(.success))
            }
        }
        .padding(.vertical)
        .background(Color.cloudLight)
        .previewDisplayName("Attributed Text")
        .previewLayout(.sizeThatFits)
    }
}
