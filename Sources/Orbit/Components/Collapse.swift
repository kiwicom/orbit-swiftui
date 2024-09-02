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
/// Use ``showsSeparator(_:)`` to adjust separator visibility.
///
/// ```swift
/// Collapse("Details", isExpanded: $showDetails) {
///     content
/// }
/// .showsSeparator(false)
/// ```
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/collapse/)
public struct Collapse<Title: View, Content: View>: View {
    
    @Environment(\.showsSeparator) private var showsSeparator
    
    private let isExpanded: OptionalBindingSource<Bool>
    @ViewBuilder private let content: Content
    @ViewBuilder private let title: Title

    public var body: some View {
		OptionalBinding(isExpanded) { $isExpanded in
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
    }

    @ViewBuilder private var separator: some View {
        if showsSeparator {
            Separator()
        }
    }
    
    /// Creates Orbit ``Collapse`` component with custom content.
    public init(
        isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder title: () -> Title
    ) {
        self.title = title()
        self.content = content()
        self.isExpanded = .binding(isExpanded)
    }
    
    /// Creates Orbit ``Collapse`` component with custom content.
    public init(
        isExpanded: Bool = false,
        @ViewBuilder content: () -> Content,
        @ViewBuilder title: () -> Title
    ) {
        self.title = title()
        self.content = content()
        self.isExpanded = .state(isExpanded)
    }
}

// MARK: - Convenience Inits
public extension Collapse where Title == CollapseTitle {

    /// Creates Orbit ``Collapse`` component.
    @_disfavoredOverload
    init(
        _ title: some StringProtocol = String(""),
        isExpanded: Binding<Bool>, 
        @ViewBuilder content: () -> Content
    ) {
        self.init(isExpanded: isExpanded) {
            content()
        } title: {
            CollapseTitle(title: Text(title))
        }
    }
    
    /// Creates Orbit ``Collapse`` component.
    @_disfavoredOverload
    init(
        _ title: some StringProtocol = String(""),
        isExpanded: Bool = false, 
        @ViewBuilder content: () -> Content
    ) {
        self.init(isExpanded: isExpanded) {
            content()
        } title: {
            CollapseTitle(title: Text(title))
        }
    }
    
    /// Creates Orbit ``Collapse`` component with localizable title.
    @_semantics("swiftui.init_with_localization")
    init(
        _ title: LocalizedStringKey = "",
        isExpanded: Binding<Bool>, 
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(isExpanded: isExpanded) {
            content()
        } title: {
            CollapseTitle(title: Text(title, tableName: tableName, bundle: bundle))
        }
    }
    
    /// Creates Orbit ``Collapse`` component with localizable title.
    @_semantics("swiftui.init_with_localization")
    init(
        _ title: LocalizedStringKey = "",
        isExpanded: Bool = false, 
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(isExpanded: isExpanded) {
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
            Collapse("Toggle with internal state") {
                contentPlaceholder
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
            Collapse("No separator", isExpanded: .constant(false)) {
                contentPlaceholder
            }
            .showsSeparator(false)
        }
        .padding(.medium)
        .previewDisplayName()
    }
}
