import SwiftUI
import Orbit

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }

    init() {
        Font.orbitFonts = [
            .regular: Bundle.main.url(forResource: "CircularPro-Book.otf", withExtension: nil),
            .medium: Bundle.main.url(forResource: "CircularPro-Medium.otf", withExtension: nil),
            .bold: Bundle.main.url(forResource: "CircularPro-Bold.otf", withExtension: nil)
        ]
        Font.registerOrbitFonts()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
