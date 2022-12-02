import SwiftUI
import Orbit

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }

    init() {
        Font.orbitFonts = [
            .regular: Bundle.main.url(forResource: "Circular20-Book.otf", withExtension: nil),
            .medium: Bundle.main.url(forResource: "Circular20-Medium.otf", withExtension: nil),
            .bold: Bundle.main.url(forResource: "Circular20-Bold.otf", withExtension: nil),
            .black: Bundle.main.url(forResource: "Circular20-Black.otf", withExtension: nil),
        ]
        Font.registerOrbitFonts()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
