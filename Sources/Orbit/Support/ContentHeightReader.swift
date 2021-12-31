import SwiftUI

struct ContentHeightReader<Content: View>: View {

    @Binding var height: CGFloat
    let content: () -> Content

    var body: some View {
        ZStack {
            content()
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: HeightPreferenceKey.self, value: proxy.size.height)
                    }
                )
        }
        .onPreferenceChange(HeightPreferenceKey.self) { preferences in
            self.height = preferences
        }
    }
}

struct HeightPreferenceKey: PreferenceKey {

    static var defaultValue: CGFloat = 0

    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}
