import SwiftUI
import Orbit

public extension Dialog {

    /// Creates Orbit ``Dialog`` component with an illustration.
    init(
        _ title: String = "",
        description: String = "",
        illustration: OrbitIllustrations.Illustration.Asset?,
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ButtonStackBuilder buttons: () -> Buttons
    ) where Illustration == OrbitIllustrations.Illustration {
        self.init(title, description: description, content: content, buttons: buttons) {
            Illustration(illustration, layout: .frame(height: 120, alignment: .leading))
        }
    }
}
