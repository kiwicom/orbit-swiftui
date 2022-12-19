import SwiftUI

/// Hides long or complex information.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/collapse/)
public struct Collapse<Header: View, Content: View>: View {

    struct _Collapse: View {
        let header: Header
        let headerVerticalPadding: CGFloat
        let content: Content
        @Binding var isExpanded: Bool

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                SwiftUI.Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack(spacing: 0) {
                        header
                            .accessibility(.collapseHeader)
                        Spacer(minLength: .xSmall)
                        Icon(.chevronDown)
                            .rotationEffect(isExpanded ? .degrees(180) : .zero)
                    }
                    .padding(.vertical, headerVerticalPadding)
                }
                .buttonStyle(CollapseButtonStyle())

                if isExpanded {
                    content
                        .padding(.vertical, .small)
                }
            }
            .overlay(Separator(), alignment: .bottom)
        }
    }

    let header: Header
    let headerVerticalPadding: CGFloat
    let content: Content
    let isExpanded: Binding<Bool>?
    @State var internalIsExpanded = false

    public var body: some View {
        _Collapse(
            header: header,
            headerVerticalPadding: headerVerticalPadding,
            content: content,
            isExpanded: isExpanded ?? $internalIsExpanded
        )
    }
}

public extension Collapse {

    /// Creates Orbit Collapse component with a binding to the expansion state.
    init(isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content, @ViewBuilder headerContent: () -> Header) {
        self.header = headerContent()
        self.headerVerticalPadding = 0
        self.content = content()
        self.isExpanded = isExpanded
    }

    /// Creates Orbit Collapse component.
    init(@ViewBuilder content: () -> Content, @ViewBuilder headerContent: () -> Header) {
        self.header = headerContent()
        self.headerVerticalPadding = 0
        self.content = content()
        self.isExpanded = nil
    }
}

public extension Collapse where Header == Text {

    /// Creates Orbit Collapse component with a binding to the expansion state.
    init(_ title: String, isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.header = Text(title)
        self.headerVerticalPadding = .small
        self.content = content()
        self.isExpanded = isExpanded
    }

    /// Creates Orbit Collapse component.
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.header = Text(title)
        self.headerVerticalPadding = .small
        self.content = content()
        self.isExpanded = nil
    }
}

extension Collapse._Collapse {

    struct CollapseButtonStyle: SwiftUI.ButtonStyle {

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(
                    backgroundColor(isPressed: configuration.isPressed)
                        .contentShape(Rectangle())
                )
        }

        func backgroundColor(isPressed: Bool) -> Color {
            isPressed ? .inkNormal.opacity(0.06) : .clear
        }
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let collapseHeader = Self(rawValue: "orbit.collapse.header")
}

// MARK: - Previews
struct CollapsePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            collapsed
            expanded
            snapshot
        }
        .previewLayout(.sizeThatFits)
    }

    static func previewContent(isExpanded: Bool) -> some View {
        VStack(spacing: 0) {
            StateWrapper(initialState: isExpanded) { isExpanded in
                Collapse("Toggle custom content", isExpanded: isExpanded) {
                    contentPlaceholder
                }
            }
            StateWrapper(initialState: isExpanded) { isExpanded in
                Collapse(
                    "Toggle text content with absurdly long description that wraps to another line",
                    isExpanded: isExpanded
                ) {
                    contentPlaceholder
                }
            }
            StateWrapper(initialState: isExpanded) { isExpanded in
                Collapse(isExpanded: isExpanded) {
                    contentPlaceholder
                } headerContent: {
                    headerPlaceholder
                }
            }
        }
        .padding(.medium)
    }

    static var collapsed: some View {
        previewContent(isExpanded: false)
            .previewDisplayName()
    }

    static var expanded: some View {
        previewContent(isExpanded: true)
            .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(spacing: 0) {
            Collapse("Toggle content (collapsed)") {
                contentPlaceholder
            }
            Collapse("Toggle content (expanded)", isExpanded: .constant(true)) {
                contentPlaceholder
            }
            Collapse {
                contentPlaceholder
            } headerContent: {
                headerPlaceholder
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }
}
