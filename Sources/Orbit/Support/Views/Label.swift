import SwiftUI

/// Label that combines text, icon and optional description under text.
public struct Label: View {

    public static let iconSpacing: CGFloat = .xSmall
    public static let descriptionSpacing: CGFloat = .xxxSmall

    let title: String
    let description: String
    let iconContent: Icon.Content
    let titleStyle: TitleStyle
    let descriptionStyle: DescriptionStyle
    let iconSpacing: CGFloat
    let descriptionSpacing: CGFloat
    let descriptionLinkAction: TextLink.Action

    public var body: some View {
        if isEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: iconSpacing) {
                Icon(iconContent, size: .label(titleStyle))
                    .alignmentGuide(.firstTextBaseline) { size in
                        self.titleStyle.size * Text.firstBaselineRatio + size.height / 2
                    }

                if isTextEmpty == false {
                    VStack(alignment: .leading, spacing: descriptionSpacing) {
                        titleView
                        descriptionView
                    }
                }
            }
        }
    }
    
    @ViewBuilder var titleView: some View {
        switch titleStyle {
            case .heading(let style, let color):           Heading(title, style: style, color: color)
            case .text(let size, let weight, let color):   Text(title, size: size, color: color, weight: weight)
        }
    }
    
    @ViewBuilder var descriptionView: some View {
        Text(
            description,
            size: descriptionStyle.size,
            color: descriptionStyle.color,
            linkColor: descriptionStyle.linkColor,
            linkAction: descriptionLinkAction
        )
    }
    
    var isTextEmpty: Bool {
        title.isEmpty && description.isEmpty
    }
    
    var isEmpty: Bool {
        isTextEmpty && iconContent.isEmpty
    }
}

// MARK: - Inits
public extension Label {

    /// Creates Orbit Label component.
    init(
        _ title: String = "",
        description: String = "",
        iconContent: Icon.Content,
        titleStyle: TitleStyle = .title4,
        descriptionStyle: DescriptionStyle = .default,
        iconSpacing: CGFloat = Self.iconSpacing,
        descriptionSpacing: CGFloat = Self.descriptionSpacing,
        descriptionLinkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.title = title
        self.description = description
        self.iconContent = iconContent
        self.titleStyle = titleStyle
        self.descriptionStyle = descriptionStyle
        self.iconSpacing = iconSpacing
        self.descriptionSpacing = descriptionSpacing
        self.descriptionLinkAction = descriptionLinkAction
    }

    /// Creates Orbit Label component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        titleStyle: TitleStyle = .title4,
        descriptionStyle: DescriptionStyle = .default,
        iconSpacing: CGFloat = Self.iconSpacing,
        descriptionSpacing: CGFloat = Self.descriptionSpacing,
        descriptionLinkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.init(
            title: title,
            description: description,
            iconContent: .icon(icon, color: titleStyle.color),
            titleStyle: titleStyle,
            descriptionStyle: descriptionStyle,
            iconSpacing: iconSpacing,
            descriptionSpacing: descriptionSpacing,
            descriptionLinkAction: descriptionLinkAction
        )
    }
}

// MARK: - Types
public extension Label {

    enum TitleStyle {
    
        case heading(_ style: Heading.Style = .title4, color: Heading.Color? = .inkNormal)
        case text(_ size: Text.Size = .normal, weight: Font.Weight = .medium, color: Text.Color? = .inkNormal)
    
        public static let display = Self.heading(.display)
        public static let displaySubtitle = Self.heading(.displaySubtitle)
        public static let title1 = Self.heading(.title1)
        public static let title2 = Self.heading(.title2)
        public static let title3 = Self.heading(.title3)
        public static let title4 = Self.heading(.title4)
        public static let title5 = Self.heading(.title5)
        public static let title6 = Self.heading(.title6)
        
        var size: CGFloat {
            switch self {
                case .heading(let style, _):            return style.size
                case .text(let size, _, _):             return size.value
            }
        }
        
        var iconSize: CGFloat {
            switch self {
                case .heading(let style, _):            return style.iconSize
                case .text(let size, _, _):             return size.iconSize
            }
        }
        
        var color: Color? {
            switch self {
                case .heading(_ , let color):           return color?.value
                case .text(_, _, let color):            return color?.value
            }
        }
    }
    
    enum DescriptionStyle {
    
        case `default`
        case custom(_ size: Text.Size = .normal, weight: Font.Weight = .regular, color: Text.Color? = .inkLight, linkColor: UIColor = .productDark)
        
        var size: Text.Size {
            switch self {
                case .default:                          return .normal
                case .custom(let size, _, _, _):        return size
            }
        }
        
        var weight: Font.Weight {
            switch self {
                case .default:                          return .regular
                case .custom(_ , let weight, _, _):     return weight
            }
        }
        
        var color: Text.Color? {
            switch self {
                case .default:                          return .inkLight
                case .custom(_, _, let color, _):       return color
            }
        }
        
        var linkColor: UIColor {
            switch self {
                case .default:                          return .productDark
                case .custom(_, _, _, let linkColor):   return linkColor
            }
        }
    }
}

// MARK: - Previews
struct HeaderPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            Group {
                Label()
                Label("Label")
                Label("Label", description: "Description")
                Label("No Icon", description: "Description", descriptionStyle: .custom(.large))
                Label("Orbit Icon", description: "Description", icon: .informationCircle, titleStyle: .heading(.title4, color: .none))
                    .foregroundColor(.blueNormal)
                Label("SF Symbol", description: "Description", iconContent: .sfSymbol("info.circle.fill"), titleStyle: .heading(.title4, color: .none))
                    .foregroundColor(.blueNormal)
                Label("CountryFlag", description: "Description", iconContent: .countryFlag("us"), titleStyle: .heading(.title4, color: .none))
                    .foregroundColor(.blueNormal)
                
                Label(
                    "Label",
                    description: #"Description <a href="..">link</a>"#,
                    icon: .grid,
                    titleStyle: .text(.large, weight: .bold, color: .none),
                    descriptionStyle: .custom(.custom(11), weight: .bold, color: .none, linkColor: .redDark)
                )
                .foregroundColor(.blueDark)
                
                Label("Label", icon: .grid)
                Label(icon: .grid)
            }
            
            Group {
                Label("Label", description: "Description", icon: .grid, titleStyle: .text(.small, weight: .medium))
                Label("Label", description: "Description", icon: .grid, titleStyle: .text(.large, weight: .bold))
                Label("Label", description: "Description", icon: .grid, titleStyle: .text(.custom(.xxLarge), weight: .bold))
            }
            
            Label(
                "Label with very very long text",
                description: "Description with very <strong>very</strong> long text",
                icon: .grid
            )
            .frame(width: 200, alignment: .leading)
            
            Label(
                "Label with very very long text",
                description: "Description with very <strong>very</strong> long text",
                icon: .grid,
                titleStyle: .title1
            )
            .frame(width: 200, alignment: .leading)
            
            Label(
                description: "Description with very <strong>very</strong> long text",
                icon: .grid
            )
            .frame(width: 200, alignment: .leading)
        }
        .previewLayout(.sizeThatFits)
    }
}
