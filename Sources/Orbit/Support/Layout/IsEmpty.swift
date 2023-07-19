import SwiftUI

extension View {

    var isEmpty: Bool {
        switch self {
            case let view as PotentiallyEmptyView:     return view.isEmpty
            case is EmptyView:                      return true
            default:                                return false
        }
    }
}
