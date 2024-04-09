import SwiftUI
import Orbit

public extension EmptyState where Title == Heading, Description == Orbit.Text, Illustration == OrbitIllustrations.Illustration {

    /// Creates Orbit ``EmptyState`` component with illustration.
    @_disfavoredOverload
    init(
        _ title: some StringProtocol = String(""),
        description: some StringProtocol = String(""),
        illustration: OrbitIllustrations.Illustration.Asset?,
        @ButtonStackBuilder buttons: () -> Buttons = { EmptyView() }
    ) {
        self.init(title, description: description, buttons: buttons) {
            Illustration(illustration, layout: .frame(height: 160))
        }
    }
}
