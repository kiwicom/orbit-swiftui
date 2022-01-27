import SwiftUI

/// Header for Tiles and Cards, containing combination of title, description and icon.
public struct Header: View {

    public static let horizontalSpacing: CGFloat = 10
    public static let verticalSpacing: CGFloat = 6

    let title: String
    let description: String
    let iconContent: Icon.Content
    let titleStyle: Heading.Style
    let descriptionSize: Text.Size
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    public var body: some View {
        if isEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: horizontalSpacing) {
                iconContent.view()
                    .alignmentGuide(.firstTextBaseline) { size in
                        self.titleStyle.size * Text.firstBaselineRatio + size.height / 2
                    }

                if isTextEmpty == false {
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        Heading(title, style: titleStyle)
                        Text(description, size: descriptionSize, color: .inkLight)
                    }
                }
            }
        }
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
        titleStyle: Heading.Style = .title3,
        descriptionSize: Text.Size = .normal,
        horizontalSpacing: CGFloat = Self.horizontalSpacing,
        verticalSpacing: CGFloat = Self.verticalSpacing
    ) {
        self.title = title
        self.description = description
        self.iconContent = iconContent
        self.titleStyle = titleStyle
        self.descriptionSize = descriptionSize
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    /// Creates Orbit Header component for Tile or Card usage.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Symbol = .none,
        titleStyle: Heading.Style = .title3,
        descriptionSize: Text.Size = .normal,
        horizontalSpacing: CGFloat = Self.horizontalSpacing,
        verticalSpacing: CGFloat = Self.verticalSpacing
    ) {
        self.init(
            title: title,
            description: description,
            iconContent: .icon(icon, size: .heading(titleStyle)),
            titleStyle: titleStyle,
            descriptionSize: descriptionSize,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing
        )
    }
}

// MARK: - Previews
struct HeaderPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            Header()
            Header("Header")
            Header("Header", description: "Description")
            Header("Header", description: "Description", descriptionSize: .custom(30))
            Header("Header", description: "Description", icon: .baggageSet)
            Header("Header", icon: .baggageSet)
            Header(icon: .baggageSet)
            
            Header(
                "Header with very very long text",
                description: "Description with very <strong>very</strong> long text",
                icon: .baggageSet
            )
            .frame(width: 200, alignment: .leading)
            
            Header(
                "Header with very very long text",
                description: "Description with very <strong>very</strong> long text",
                icon: .baggageSet,
                titleStyle: .title1
            )
            .frame(width: 200, alignment: .leading)
            
            Header(
                description: "Description with very <strong>very</strong> long text",
                icon: .baggageSet
            )
            .frame(width: 200, alignment: .leading)
        }
        .previewLayout(.sizeThatFits)
    }
}
