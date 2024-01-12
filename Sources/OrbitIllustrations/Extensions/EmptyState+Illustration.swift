import SwiftUI
import Orbit

public extension EmptyState {

    /// Creates Orbit ``EmptyState`` component with illustration.
    init(
        _ title: String = "",
        description: String = "",
        illustration: OrbitIllustrations.Illustration.Asset?,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ButtonStackBuilder buttons: () -> Buttons
    ) where Illustration == OrbitIllustrations.Illustration {
        self.init(title, description: description, content: content, buttons: buttons) {
            Illustration(illustration, layout: .frame(height: 160))
        }
    }

    /// Creates Orbit ``EmptyState`` component with illustration and no action.
    init(
        _ title: String = "",
        description: String = "",
        illustration: Illustration.Asset? = nil
    ) where Content == EmptyView, Buttons == EmptyView, Illustration == OrbitIllustrations.Illustration {
        self.init(title, description: description, illustration: illustration) {
            EmptyView()
        } buttons: {
            EmptyView()
        }
    }
}
