import SwiftUI

/// Orbit component that hides long or complex content.
///
/// A ``Collapse`` consists of a header and a collapsible content.
///
/// ```swift
/// Collapse("Details", isExpanded: $showDetails) {
///     content
/// }
/// ```
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/collapse/)
public struct Collapse<Title: View, Content: View>: View {

    private let showSeparator: Bool
    @Binding var isExpanded: Bool
    @ViewBuilder private let content: Content
    @ViewBuilder private let title: Title

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SwiftUI.Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 0) {
                    title
                        .textFontWeight(.medium)
                        .accessibility(.collapseHeader)

                    Spacer(minLength: .xSmall)

                    Icon(.chevronDown)
                        .rotationEffect(isExpanded ? .degrees(180) : .zero)
                }
            }
            .buttonStyle(ListChoiceButtonStyle())

            if isExpanded {
                content
                    .padding(.vertical, .small)
            }
        }
        .overlay(separator, alignment: .bottom)
    }

    @ViewBuilder private var separator: some View {
        if showSeparator {
            Separator()
        }
    }
    
    /// Creates Orbit ``Collapse`` component with a binding to the expansion state
    public init(
        isExpanded: Binding<Bool>,
        showSeparator: Bool = true,
        @ViewBuilder content: () -> Content,
        @ViewBuilder title: () -> Title
    ) {
        self.title = title()
        self.content = content()
        self.showSeparator = showSeparator
        self._isExpanded = isExpanded
    }
}

// MARK: - Convenience Inits
public extension Collapse where Title == CollapseTitle {

    /// Creates Orbit ``Collapse`` component with a binding to the expansion state.
    @_disfavoredOverload
    init(
        _ title: some StringProtocol = String(""),
        isExpanded: Binding<Bool>, 
        showSeparator: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            isExpanded: isExpanded, 
            showSeparator: showSeparator
        ) {
            content()
        } title: {
            CollapseTitle(title: Text(title))
        }
    }
    
    /// Creates Orbit ``Collapse`` component with a binding to the expansion state.
    @_semantics("swiftui.init_with_localization")
    init(
        _ title: LocalizedStringKey = "",
        isExpanded: Binding<Bool>, 
        showSeparator: Bool = true,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            isExpanded: isExpanded, 
            showSeparator: showSeparator
        ) {
            content()
        } title: {
            CollapseTitle(title: Text(title, tableName: tableName, bundle: bundle))
        }
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let collapseHeader = Self(rawValue: "orbit.collapse.header")
}

// MARK: - Types

public struct CollapseTitle: View {
    
    let title: Text

    public var body: some View {
        title
            .padding(.vertical, .small)
    }
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
                } title: {
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
            Collapse("Toggle content (collapsed)", isExpanded: .constant(false)) {
                contentPlaceholder
            }
            Collapse("Toggle content (expanded)", isExpanded: .constant(true)) {
                contentPlaceholder
            }
            Collapse(isExpanded: .constant(false)) {
                contentPlaceholder
            } title: {
                headerPlaceholder
            }
            Collapse("No separator", isExpanded: .constant(false), showSeparator: false) {
                contentPlaceholder
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }
}
