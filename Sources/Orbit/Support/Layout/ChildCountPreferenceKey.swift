import SwiftUI

/// Preference key for calculating number of child views.
struct ChildCountPreferenceKey: PreferenceKey {

    static var defaultValue: Int { 0 }

    static func reduce(value: inout Int, nextValue _: () -> Int) {
        value += 1
    }
}
