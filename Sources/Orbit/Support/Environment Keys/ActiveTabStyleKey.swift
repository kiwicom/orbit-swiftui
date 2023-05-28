import SwiftUI

struct ActiveTabStyleKey: PreferenceKey {

    typealias Value = [ActiveTabStyle]

    static let defaultValue: Value = []

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct ActiveTabStyle: Equatable {
    let style: TabStyle
    let bounds: Anchor<CGRect>
}
