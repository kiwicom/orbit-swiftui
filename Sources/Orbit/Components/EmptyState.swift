import SwiftUI

/// Indicates when there’s no data to show, like when a search has no results.
///
/// ```swift
/// EmptyState("No items") {
///     Button("Add item") { /* */ }
/// }
/// .status(.critical)
/// ```
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/progress-indicators/emptystate/)
public struct EmptyState<Content: View, Buttons: View>: View {

    private let title: String
    private let description: String
    private let illustration: Illustration.Image
    @ViewBuilder private let content: Content
    @ViewBuilder private let buttons: Buttons

    public var body: some View {
        VStack(spacing: .medium) {
            Illustration(illustration, layout: .frame(maxHeight: 160))
                .padding(.top, .large)
        
            texts

            if content.isEmpty == false {
                content
            }

            if buttons.isEmpty == false {
                VStack(spacing: .xSmall) {
                    buttons
                }
                .textColor(nil)
            }
        }
        .frame(maxWidth: Layout.readableMaxWidth * 2/3)
        .padding(.medium)
        .accessibilityElement(children: .contain)
    }
    
    @ViewBuilder var texts: some View {
        if title.isEmpty == false || description.isEmpty == false {
            VStack(spacing: .xxSmall) {
                Heading(title, style: .title3)
                    .accessibility(.emptyStateTitle)
                
                Text(description)
                    .textColor(.inkNormal)
                    .accessibility(.emptyStateDescription)
            }
            .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Inits
public extension EmptyState {
 
    /// Creates Orbit EmptyState component.
    init(
        _ title: String = "",
        description: String = "",
        illustration: Illustration.Image = .none,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ButtonStackBuilder buttons: () -> Buttons
    ) {
        self.init(
            title: title,
            description: description,
            illustration: illustration
        ) {
            content()
        } buttons: {
            buttons()
        }
    }

    /// Creates Orbit EmptyState component with no action.
    init(
        _ title: String = "",
        description: String = "",
        illustration: Illustration.Image = .none
    ) where Content == EmptyView, Buttons == EmptyView {
        self.init(
            title: title,
            description: description,
            illustration: illustration
        ) {
            EmptyView()
        } buttons: {
            EmptyView()
        }
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let emptyStateTitle          = Self(rawValue: "orbit.emptystate.title")
    static let emptyStateDescription    = Self(rawValue: "orbit.emptystate.description")
}

// MARK: - Previews
struct EmptyStatePreviews: PreviewProvider {

    static let title = "No results"
    static let description = "Try a quick search to explore hundreds of affordable options."
    static let primaryButton = "Primary action"
    static let secondaryButton = "Secondary action"

    static var previews: some View {
        PreviewWrapper {
            standalone
            subtle
            noAction
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        EmptyState(title, description: description, illustration: .noResults) {
            contentPlaceholder
        } buttons: {
            Button(primaryButton) {}
            Button(secondaryButton) {}
        }
        .previewDisplayName()
    }
    
    static var subtle: some View {
        EmptyState(title, description: description, illustration: .error404) {
            Button(primaryButton) {}
        }
        .status(.critical)
        .previewDisplayName()
    }
    
    static var noAction: some View {
        EmptyState(title, description: description, illustration: .offline)
            .previewDisplayName()
    }

    static var snapshot: some View {
        standalone
    }
}
