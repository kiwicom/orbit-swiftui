import SwiftUI

/// Hides long or complex information.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/collapse/)
public struct Collapse<Header: View, Content: View>: View {

    let headerVerticalPadding: CGFloat
    let showSeparator: Bool
    let isExpanded: Binding<Bool>?
    @ViewBuilder let content: Content
    @ViewBuilder let header: Header

    public var body: some View {
        BindingSource(isExpanded, fallbackInitialValue: false) { $isExpanded in
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
            .overlay(separator, alignment: .bottom)
        }
    }

    @ViewBuilder var separator: some View {
        if showSeparator {
            Separator()
        }
    }
}

public extension Collapse {

    /// Creates Orbit Collapse component with a binding to the expansion state.
    init(
        isExpanded: Binding<Bool>,
        showSeparator: Bool = true,
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header
    ) {
        self.header = header()
        self.headerVerticalPadding = 0
        self.content = content()
        self.showSeparator = showSeparator
        self.isExpanded = isExpanded
    }

    /// Creates Orbit Collapse component.
    init(@ViewBuilder content: () -> Content, showSeparator: Bool = true, @ViewBuilder header: () -> Header) {
        self.header = header()
        self.headerVerticalPadding = 0
        self.content = content()
        self.showSeparator = showSeparator
        self.isExpanded = nil
    }
}

public extension Collapse where Header == Text {

    /// Creates Orbit Collapse component with a binding to the expansion state.
    init(_ title: String, isExpanded: Binding<Bool>, showSeparator: Bool = true,  @ViewBuilder content: () -> Content) {
        self.header = Text(title)
        self.headerVerticalPadding = .small
        self.content = content()
        self.showSeparator = showSeparator
        self.isExpanded = isExpanded
    }

    /// Creates Orbit Collapse component.
    init(_ title: String, showSeparator: Bool = true, @ViewBuilder content: () -> Content) {
        self.header = Text(title)
        self.headerVerticalPadding = .small
        self.content = content()
        self.showSeparator = showSeparator
        self.isExpanded = nil
    }
}

extension Collapse {

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
            StateWrapper(isExpanded) { isExpanded in
                Collapse("Toggle custom content", isExpanded: isExpanded) {
                    contentPlaceholder
                }
            }
            StateWrapper(isExpanded) { isExpanded in
                Collapse(
                    "Toggle text content with absurdly long description that wraps to another line",
                    isExpanded: isExpanded
                ) {
                    contentPlaceholder
                }
            }
            StateWrapper(isExpanded) { isExpanded in
                Collapse(isExpanded: isExpanded) {
                    contentPlaceholder
                } header: {
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
            } header: {
                headerPlaceholder
            }
            Collapse("No separator", showSeparator: false) {
                contentPlaceholder
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }
}
