import SwiftUI

extension View {

    var isEmpty: Bool {
        self is EmptyView || (self as? Orbit.Icon)?.isEmpty == true || (self as? Orbit.Text)?.isEmpty == true
    }
}
