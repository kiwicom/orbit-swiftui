import SwiftUI

/// Wraps ListChoice items.

/// - Related components:
///   - ``ListChoice``
///   - ``Card``
///
/// - Important: Component expands horizontally to infinity up to a ``Layout/readableMaxWidth``.
public struct ListChoiceGroup<Content: View>: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let status: Status?
    let backgroundColor: Color?
    let content: () -> Content

    public var body: some View {
        Card(spacing: 0, padding: 0, style: .iOS, status: status, backgroundColor: backgroundColor) {
            content()
        }
    }
}

// MARK: - Inits
public extension ListChoiceGroup {
    
    /// Creates Orbit ListChoiceGroup wrapper component.
    init(
        status: Status? = nil,
        backgroundColor: Color? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.status = status
        self.backgroundColor = backgroundColor
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
            snapshotsIOS
            snapshotsIOSRegular
            snapshotsIOSRegularNarrow
        }
        .previewLayout(.sizeThatFits)
    }

    static var figma: some View {
        listChoiceGroups
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Figma")
    }

    static var snapshotsIOS: some View {
        listChoiceGroups
            .background(Color.cloudLight)
            .previewDisplayName("Style - iOS")
    }

    static var snapshotsIOSRegular: some View {
        listChoiceGroups
            .background(Color.cloudLight)
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: Layout.readableMaxWidth + 100)
            .previewDisplayName("Style - iOS Regular")
    }

    static var snapshotsIOSRegularNarrow: some View {
        listChoiceGroups
            .background(Color.cloudLight)
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: Layout.readableMaxWidth - 200)
            .previewDisplayName("Style - iOS Regular narrow")
    }

    static var listChoiceGroups: some View {
        VStack(spacing: .medium) {
            ListChoiceGroup {
                listChoices
            }

            ListChoiceGroup(status: .critical) {
                listChoices
            }
        }
        .padding(.vertical)
    }

    @ViewBuilder static var listChoices: some View {
        ListChoice("Title")

        ListChoice("Title", icon: .notification)

        ListChoice("Title", description: description, icon: .airplane)
    }
}
