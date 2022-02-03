import SwiftUI

/// Header for Tiles and Cards, containing combination of title, description and icon.
public struct Header: View {

    public static let horizontalSpacing: CGFloat = 10
    public static let verticalSpacing: CGFloat = 6

    let title: String
    let description: String
    let iconContent: Icon.Content
    let titleStyle: TitleStyle
    let descriptionStyle: DescriptionStyle
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    let descriptionLinkAction: TextLink.Action

    public var body: some View {
        if isEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: horizontalSpacing) {
                iconContent.view()
                    .alignmentGuide(.firstTextBaseline) { size in
                        self.titleStyle.size * Text.firstBaselineRatio + size.height / 2
                    }

                if isTextEmpty == false {
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        heading
                        descriptionView
                    }
                }
            }
        }
    }
    
    @ViewBuilder var heading: some View {
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
public extension Header {

    /// Creates Orbit Header component for Tile or Card usage.
    init(
        _ title: String = "",
        description: String = "",
        iconContent: Icon.Content,
        titleStyle: TitleStyle = .title3,
        descriptionStyle: DescriptionStyle = .default,
        horizontalSpacing: CGFloat = Self.horizontalSpacing,
        verticalSpacing: CGFloat = Self.verticalSpacing,
        descriptionLinkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.title = title
        self.description = description
        self.iconContent = iconContent
        self.titleStyle = titleStyle
        self.descriptionStyle = descriptionStyle
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.descriptionLinkAction = descriptionLinkAction
    }

    /// Creates Orbit Header component for Tile or Card usage.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        titleStyle: TitleStyle = .title3,
        descriptionStyle: DescriptionStyle = .default,
        horizontalSpacing: CGFloat = Self.horizontalSpacing,
        verticalSpacing: CGFloat = Self.verticalSpacing,
        descriptionLinkAction: @escaping TextLink.Action = { _, _ in }
    ) {
        self.init(
            title: title,
            description: description,
            iconContent: .icon(icon, size: .header(titleStyle)),
            titleStyle: titleStyle,
            descriptionStyle: descriptionStyle,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            descriptionLinkAction: descriptionLinkAction
        )
    }
}

// MARK: - Inits
public extension Header {

    enum TitleStyle {
    
        case heading(_ style: Heading.Style = .title3, color: Heading.Color? = nil)
        case text(_ size: Text.Size, weight: Font.Weight = .medium, color: Text.Color? = .inkNormal)
    
        public static let display = Self.heading(.display)
        public static let displaySubtitle = Self.heading(.displaySubtitle)
        public static let title1 = Self.heading(.title1)
        public static let title2 = Self.heading(.title2)
        public static let title3 = Self.heading(.title3)
        public static let title4 = Self.heading(.title4)
        public static let title5 = Self.heading(.title5)
        
        var size: CGFloat {
            switch self {
                case .heading(let style, _):            return style.size
                case .text(let size, _, _):             return size.value
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
                Header()
                Header("Header")
                Header("Header", description: "Description")
                Header("Header", description: "Description", descriptionStyle: .custom(.large))
                Header("Header", description: "Description", icon: .grid)
                
                Header(
                    "Header",
                    description: #"Description <a href="..">link</a>"#,
                    icon: .grid,
                    titleStyle: .text(.large, weight: .bold, color: .none),
                    descriptionStyle: .custom(.custom(11), weight: .bold, color: .none, linkColor: .redDark)
                )
                .foregroundColor(.blueDark)
                
                Header("Header", icon: .grid)
                Header(icon: .grid)
            }
            
            Group {
                Header("Header", description: "Description", icon: .grid, titleStyle: .text(.small, weight: .medium))
                Header("Header", description: "Description", icon: .grid, titleStyle: .text(.large, weight: .bold))
                Header("Header", description: "Description", icon: .grid, titleStyle: .text(.custom(.xxLarge), weight: .bold))
            }
            
            Header(
                "Header with very very long text",
                description: "Description with very <strong>very</strong> long text",
                icon: .grid
            )
            .frame(width: 200, alignment: .leading)
            
            Header(
                "Header with very very long text",
                description: "Description with very <strong>very</strong> long text",
                icon: .grid,
                titleStyle: .title1
            )
            .frame(width: 200, alignment: .leading)
            
            Header(
                description: "Description with very <strong>very</strong> long text",
                icon: .grid
            )
            .frame(width: 200, alignment: .leading)
        }
        .previewLayout(.sizeThatFits)
    }
}
