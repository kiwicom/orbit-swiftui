import SwiftUI

struct CardLayoutKey: EnvironmentKey {
    static let defaultValue: CardLayout = .default
}

public extension EnvironmentValues {

    /// An Orbit ``CardLayout`` value stored in a view’s environment.
    var cardLayout: CardLayout {
        get { self[CardLayoutKey.self] }
        set { self[CardLayoutKey.self] = newValue }
    }
}

public extension View {

    /// Set the Orbit ``CardLayout`` for this view.
    ///
    /// - Parameters:
    ///   - layout: A layout that will be used by all ``Card`` components in the view hierarchy.
    func cardLayout(_ layout: CardLayout) -> some View {
        environment(\.cardLayout, layout)
    }
    
    /// Set the Orbit ``CardLayout`` for this view using custom values.
    func cardLayout(
        alignment: HorizontalAlignment = .leading, 
        padding: CGFloat = .medium, 
        spacing: CGFloat = .medium
    ) -> some View {
        cardLayout(.init(alignment: alignment, padding: padding, spacing: spacing))
    }
}
