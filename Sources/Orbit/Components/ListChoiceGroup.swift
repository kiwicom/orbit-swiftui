import SwiftUI

public enum ListChoiceGroupStyle {
    
    // Style with no decoration.
    case borderless
    
    // Style with Card-like appearance.
    case card(status: Status? = nil, backgroundColor: Color = .white)
}

/// Wraps ListChoice items.

/// - Related components:
///   - ``ListChoice``
///   - ``Card``
///
/// - Important: Expands horizontally up to ``Layout/readableMaxWidth`` by default and then centered. Can be adjusted by `width` property.
public struct ListChoiceGroup<Content: View>: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let title: String
    let iconContent: Icon.Content
    let style: ListChoiceGroupStyle
    let titleStyle: Header.TitleStyle
    let width: ContainerWidth
    let content: () -> Content

    public var body: some View {
        switch style {
            case .card(let status, let backgroundColor):
                Card(
                    title,
                    spacing: 0,
                    padding: 0,
                    style: .iOS,
                    status: status,
                    width: width,
                    backgroundColor: backgroundColor
                ) {
                    content()
                }
            case .borderless:
                borderlessView
        }
    }
    
    var borderlessView: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            Header(title, iconContent: iconContent, titleStyle: titleStyle)
                .padding([.horizontal, .top], .medium)

            VStack(alignment: .leading, spacing: 0) {
                content()
            }
        }
        .frame(maxWidth: Layout.readableMaxWidth, alignment: .leading)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Inits
public extension ListChoiceGroup {
    
    /// Creates Orbit ListChoiceGroup wrapper component.
    init(
        _ title: String = "",
        icon: Icon.Symbol = .none,
        style: ListChoiceGroupStyle = .card(),
        titleStyle: Header.TitleStyle = .title3,
        width: ContainerWidth = .expanding(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.iconContent = .icon(icon, size: .header(titleStyle))
        self.style = style
        self.titleStyle = titleStyle
        self.width = width
        self.content = content
    }
    
    /// Creates Orbit ListChoiceGroup wrapper component.
    init(
        _ title: String = "",
        iconContent: Icon.Content,
        style: ListChoiceGroupStyle = .card(),
        titleStyle: Header.TitleStyle = .title3,
        width: ContainerWidth = .expanding(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.iconContent = iconContent
        self.style = style
        self.titleStyle = titleStyle
        self.width = width
        self.content = content
    }
}

// MARK: - Previews
struct ListChoiceGroupPreviews: PreviewProvider {
    
    static let description = """
        Description with <strong>very</strong> <ref>very</ref> <u>very</u> long multiline \
        description and <u>formatting</u> with <applink1>links</applink1>
        """

    static var previews: some View {
        PreviewWrapper {
            snapshotsCard
            snapshotsCardRegular
            snapshotsCardRegularNarrow
            snapshotsBorderless
            snapshotsBorderlessRegular
            snapshotsBorderlessRegularNarrow
        }
        .previewLayout(.sizeThatFits)
    }

    static var figma: some View {
        listChoiceGroupsCard
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Figma")
    }

    static var snapshotsCard: some View {
        listChoiceGroupsCard
            .background(Color.cloudLight)
            .previewDisplayName("Style - Card")
    }

    static var snapshotsCardRegular: some View {
        listChoiceGroupsCard
            .background(Color.cloudLight)
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: Layout.readableMaxWidth + 100)
            .previewDisplayName("Style - Card Regular")
    }

    static var snapshotsCardRegularNarrow: some View {
        listChoiceGroupsCard
            .background(Color.cloudLight)
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: Layout.readableMaxWidth - 5)
            .previewDisplayName("Style - Card Regular narrow")
    }
    
    static var snapshotsBorderless: some View {
        listChoiceGroupsBorderless
            .background(Color.cloudLight)
            .previewDisplayName("Style - Borderless")
    }

    static var snapshotsBorderlessRegular: some View {
        listChoiceGroupsBorderless
            .background(Color.cloudLight)
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: Layout.readableMaxWidth + 100)
            .previewDisplayName("Style - Borderless Regular")
    }

    static var snapshotsBorderlessRegularNarrow: some View {
        listChoiceGroupsBorderless
            .background(Color.cloudLight)
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: Layout.readableMaxWidth - 8)
            .previewDisplayName("Style - Borderless Regular narrow")
    }

    static var listChoiceGroupsCard: some View {
        VStack(spacing: .medium) {
            ListChoiceGroup {
                listChoices
            }

            ListChoiceGroup(style: .card(status: .critical)) {
                listChoices
            }
        }
        .padding(.vertical)
    }
    
    static var listChoiceGroupsBorderless: some View {
        VStack(spacing: .medium) {
            ListChoiceGroup(style: .borderless) {
                listChoices
            }
            
            ListChoiceGroup("Group Title", style: .borderless) {
                listChoices
            }
        }
        .padding(.vertical)
    }

    @ViewBuilder static var listChoices: some View {
        ListChoice("Choice Title")

        ListChoice("Choice Title", icon: .notification)

        ListChoice("Choice Title", description: description, icon: .airplane)
    }
}
