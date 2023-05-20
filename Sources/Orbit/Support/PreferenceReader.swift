import SwiftUI

/// A view that reads the given preference value and makes it available to the content.
struct PreferenceReader<Preference: PreferenceKey, Content: View>: View where Preference.Value: Equatable {

    @State var preference: Preference.Value = Preference.defaultValue
    let content: (Preference.Value) -> Content

    var body: some View {
        content(preference)
            .onPreferenceChange(Preference.self) { value in
                preference = value
            }
    }

    init(_: Preference.Type, content: @escaping (Preference.Value) -> Content) {
        self.content = content
    }
}
