import SwiftUI

/// Label that prefixes text with icon of correct size, vertically aligned on `firstBaseline`.
///
/// Offers two horizontal alignments:
///  - `labelTextLeading`
///  - `labelIconCenter`
///
/// - Important: Using above alignments on horizontally expanding content will increase the container size.
public struct Label: View {

    public static let defaultSpacing: CGFloat = .xSmall
    
    let title: String
    let iconContent: Icon.Content
    let iconSize: Icon.Size?
    let style: Style
    let spacing: CGFloat

    public var body: some View {
        if isEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: spacing) {
                icon
                    .alignmentGuide(.labelIconCenter) { $0[HorizontalAlignment.center] }

                titleView
                    .alignmentGuide(.labelTextLeading) { $0[.leading] }
            }
        }
    }

    @ViewBuilder var icon: some View {
        if let color = style.color {
            iconView
                .foregroundColor(color)
        } else {
            iconView
        }
    }

    @ViewBuilder var iconView: some View {
        Icon(content: iconContent, size: iconSize ?? .label(style))
    }
    
    @ViewBuilder var titleView: some View {
        switch style {
            case .heading(let style, let color):
                Heading(title, style: style, color: color)
            case .text(let size, let weight, let color, let accentColor, let linkColor, let linkAction):
                Text(
                    title,
                    size: size,
                    color: color,
                    weight: weight,
                    accentColor: accentColor,
                    linkColor: linkColor,
                    linkAction: linkAction
                )
        }
    }
    
    var isEmpty: Bool {
        title.isEmpty && iconContent.isEmpty
    }
}

// MARK: - Inits
public extension Label {

    /// Creates Orbit Label component.
    init(
        _ title: String = "",
        icon: Icon.Content = .none,
        iconSize: Icon.Size? = nil,
        style: Style = .title4,
        spacing: CGFloat = Self.defaultSpacing
    ) {
        self.title = title
        self.iconContent = icon
        self.iconSize = iconSize
        self.style = style
        self.spacing = spacing
    }
}

// MARK: - Types
public extension Label {

    enum Style {
    
        case heading(_ style: Heading.Style = .title4, color: Heading.Color? = .inkNormal)
        case text(
            _ size: Text.Size = .normal,
            weight: Font.Weight = .regular,
            color: Text.Color? = .inkNormal,
            accentColor: UIColor = .inkNormal,
            linkColor: TextLink.Color = .primary,
            linkAction: TextLink.Action = { _, _ in }
        )
    
        /// 40 pts.
        public static let display = Self.heading(.display)
        /// 22 pts.
        public static let displaySubtitle = Self.heading(.displaySubtitle)
        /// 28 pts.
        public static let title1 = Self.heading(.title1)
        /// 22 pts.
        public static let title2 = Self.heading(.title2)
        /// 18 pts.
        public static let title3 = Self.heading(.title3)
        /// 16 pts.
        public static let title4 = Self.heading(.title4)
        /// 14 pts.
        public static let title5 = Self.heading(.title5)
        /// 12 pts.
        public static let title6 = Self.heading(.title6)
        
        var size: CGFloat {
            switch self {
                case .heading(let style, _):            return style.size
                case .text(let size, _, _, _, _, _):    return size.value
            }
        }

        var textStyle: Font.TextStyle {
            switch self {
                case .heading(let style, _):            return style.textStyle
                case .text(let size, _, _, _, _, _):    return size.textStyle
            }
        }
        
        var iconSize: CGFloat {
            switch self {
                case .heading(let style, _):            return style.iconSize
                case .text(let size, _, _, _, _, _):    return size.iconSize
            }
        }
        
        var lineHeight: CGFloat {
            switch self {
                case .heading(let style, _):            return style.lineHeight
                case .text(let size, _, _, _, _, _):    return size.lineHeight
            }
        }
        
        var iconSpacing: CGFloat {
            .xxSmall
        }
        
        var color: Color? {
            switch self {
                case .heading(_ , let color):           return color?.value
                case .text(_, _, let color, _, _, _):   return color?.value
            }
        }
    }
}

// MARK: - Alignments
public extension HorizontalAlignment {
    
    static let labelIconCenter = HorizontalAlignment(LabelIconCenterAlignment.self)
    static let labelTextLeading = HorizontalAlignment(LabelTextLeadingAlignment.self)
    
    enum LabelIconCenterAlignment: AlignmentID {
        public static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.leading]
        }
    }

    enum LabelTextLeadingAlignment: AlignmentID {
        public static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.leading]
        }
    }
}

// MARK: - Previews
struct LabelPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            snapshots
            snapshotLabelLayout
            snapshotStackLayout
            snapshotColorOverride
        }
        .previewLayout(.sizeThatFits)
    }
    
    @ViewBuilder static var snapshots: some View {
        VStack(alignment: .leading, spacing: .large) {
            
            // No content
            Label()
                .border(Color.inkLighter)

            Label("Label")

            Label(icon: .grid)
            
            Label("Label", icon: .informationCircle)
            
            VStack(alignment: .leading, spacing: 0) {
                Heading("leading alignment", style: .title5)
                Label("Label", icon: .grid, style: .title1)
                Label("Label", icon: .grid, style: .text(.small))
                Label("Label", icon: .countryFlag("us"), style: .title1)
                Label("Label", icon: .countryFlag("us"), style: .text(.small))
                Label("Label", icon: .sfSymbol("info.circle.fill"), style: .title1)
                Label("Label", icon: .sfSymbol("info.circle.fill"), style: .text(.small))
            }

            
            VStack(alignment: .labelTextLeading, spacing: 0) {
                Heading("labelTextLeading alignment", style: .title5)
                Label("Label", icon: .grid, style: .title1)
                Label("Label", icon: .grid, style: .text(.small))
                Label("Label", icon: .countryFlag("us"), style: .title1)
                Label("Label", icon: .countryFlag("us"), style: .text(.small))
                Label("Label", icon: .sfSymbol("info.circle.fill"), style: .title1)
                Label("Label", icon: .sfSymbol("info.circle.fill"), style: .text(.small))
            }
            

            VStack(alignment: .labelIconCenter, spacing: 0) {
                Heading("labelIconCenter alignment", style: .title5)
                Label("Label", icon: .grid, style: .title1)
                Label("Label", icon: .grid, style: .text(.small))
                Label("Label", icon: .countryFlag("us"), style: .title1)
                Label("Label", icon: .countryFlag("us"), style: .text(.small))
                Label("Label", icon: .sfSymbol("info.circle.fill"), style: .title1)
                Label("Label", icon: .sfSymbol("info.circle.fill"), style: .text(.small))
            }
        }
        .padding()
    }
    
    @ViewBuilder static var snapshotLabelLayout: some View {
        HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
            VStack(alignment: .leading, spacing: .xSmall) {
                Label("Label with long multiline text", icon: .grid, style: .title2)
                Text("Description very very very very verylong multiline text", color: .inkLight)
                contentPlaceholder
            }
            Spacer()
            Badge("Trailing")
        }
        .frame(width: 200, alignment: .leading)
        .padding()
    }
    
    @ViewBuilder static var snapshotStackLayout: some View {
        HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
            Icon(.grid, size: .label(.title2))
            
            VStack(alignment: .leading, spacing: .xSmall) {
                Heading("Label with long multiline text", style: .title2)
                Text("Description very very very very verylong multiline text", color: .inkLight)
                contentPlaceholder
            }
            
            Spacer()
            Badge("Trailing")
        }
        .frame(width: 200, alignment: .leading)
        .padding()
    }
    
    static var snapshotColorOverride: some View {
        VStack(alignment: .leading, spacing: .xxxSmall) {
            Label("Orbit Icon", icon: .informationCircle, style: .heading(.title5, color: .none))
                .foregroundColor(.blueNormal)
                .border(Color.cloudLight)
            
            Label("SF Symbol", icon: .sfSymbol("info.circle.fill"), style: .heading(.title5, color: .none))
                .foregroundColor(.blueNormal)
                .border(Color.cloudLight)
            
            Label("CountryFlag", icon: .countryFlag("us"), style: .heading(.title5, color: .none))
                .foregroundColor(.blueNormal)
                .border(Color.cloudLight)
        }
        .padding()
    }
}
