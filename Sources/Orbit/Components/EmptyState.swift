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
            Illustration(illustration, size: .intrinsic(maxHeight: 120))
                .padding(.top, .large)
        
            texts
            
            actions
        }
    }
    
    @ViewBuilder var texts: some View {
        if title.isEmpty == false || description.isEmpty == false {
            VStack(spacing: .xSmall) {
                Heading(title, style: .title3, alignment: .center)
                Text(description, color: .inkLight, alignment: .center)
            }
        }
    }
    
    @ViewBuilder var actions: some View {
        switch action {
            case .none:
                EmptyView()
            case .button(let label, let style, let action):
                Button(label, style: style, action: action)
                    .fixedSize(horizontal: true, vertical: true)
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

// MARK: - Previews
struct EmptyStatePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            snapshot
            snapshotSubtle
            snapshotNoAction
        }
        .previewLayout(.sizeThatFits)
    }

    static var snapshot: some View {
        EmptyState(
            "No results",
            description: "Empty state very long and multiline description",
            illustration: .noResults,
            action: .button("Back to search")
        )
        .padding()
    }
    
    static var snapshotSubtle: some View {
        EmptyState(
            "Error",
            illustration: .error404,
            action: .button("Back to search", style: .primarySubtle)
        )
        .padding()
    }
    
    static var snapshotNoAction: some View {
        EmptyState(
            "Offline",
            description: "Empty state very long and multiline description",
            illustration: .offline
        )
        .padding()
    }
}
