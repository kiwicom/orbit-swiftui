import SwiftUI

/// Indicates when there’s no data to show, like when a search has no results.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/progress-indicators/emptystate/)
public struct EmptyState: View {

    let title: String
    let description: String
    let illustration: Illustration.Image
    let action: Action

    public var body: some View {
        VStack(spacing: .medium) {
            Illustration(illustration, layout: .frame(maxHeight: 120))
                .padding(.top, .large)
        
            texts
            
            actions
        }
        .accessibilityElement(children: .contain)
    }
    
    @ViewBuilder var texts: some View {
        if title.isEmpty == false || description.isEmpty == false {
            VStack(spacing: .xSmall) {
                Heading(title, style: .title4, alignment: .center)
                    .accessibility(.emptyStateTitle)
                Text(description, color: .inkNormal, alignment: .center)
                    .accessibility(.emptyStateDescription)
            }
        }
    }
    
    @ViewBuilder var actions: some View {
        switch action {
            case .none:
                EmptyView()
            case .button(let label, let style, let action):
                Button(label, style: style, action: action)
                    .idealSize()
                    .accessibility(.emptyStateButton)
        }
    }
}

// MARK: - Types
public extension EmptyState {
    
    enum Action {
        case none
        case button(_ label: String, style: Button.Style = .primary, action: () -> Void = {})
    }
}

// MARK: - Inits
public extension EmptyState {
 
    /// Creates Orbit EmptyState component.
    init(
        _ title: String = "",
        description: String = "",
        illustration: Illustration.Image,
        action: Action = .none
    ) {
        self.title = title
        self.description = description
        self.illustration = illustration
        self.action = action
    }
}

// MARK: - Identifiers
public extension AccessibilityID {

    static let emptyStateTitle          = Self(rawValue: "orbit.emptystate.title")
    static let emptyStateDescription    = Self(rawValue: "orbit.emptystate.description")
    static let emptyStateButton         = Self(rawValue: "orbit.emptystate.button")
}

// MARK: - Previews
struct EmptyStatePreviews: PreviewProvider {

    static let title = "Sorry, we couldn't find that connection."
    static let description = "Try changing up your search a bit. We'll try harder next time."
    static let button = "Adjust search"

    static var previews: some View {
        PreviewWrapper {
            standalone
            subtle
            noAction
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        EmptyState(title, description: description, illustration: .noResults, action: .button(button))
            .previewDisplayName()
    }
    
    static var subtle: some View {
        EmptyState(title, description: description, illustration: .error404, action: .button(button, style: .primarySubtle))
            .previewDisplayName()
    }
    
    static var noAction: some View {
        EmptyState(title, description: description, illustration: .offline)
            .previewDisplayName()
    }

    static var snapshot: some View {
        standalone
            .padding(.medium)
    }
}
