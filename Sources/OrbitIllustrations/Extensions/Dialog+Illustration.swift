import SwiftUI
import Orbit

public extension Dialog where Title == Heading, Description == Orbit.Text, Illustration == OrbitIllustrations.Illustration {

    /// Creates Orbit ``Dialog`` component with an illustration.
    @_disfavoredOverload
    init(
        _ title: some StringProtocol = String(""),
        description: some StringProtocol = String(""),
        illustration: OrbitIllustrations.Illustration.Asset?,
        @ButtonStackBuilder buttons: () -> Buttons
    ) {
        self.init(title, description: description, buttons: buttons) {
            Illustration(illustration, layout: .frame(height: 120, alignment: .leading))
        }
    }
}
