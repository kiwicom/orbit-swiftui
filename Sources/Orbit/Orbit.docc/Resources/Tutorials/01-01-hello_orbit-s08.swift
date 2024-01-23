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
        
        // Register above custom fonts for use in Orbit textual components
        Font.registerOrbitFonts()
        
        // Register custom font for use in Orbit `Icon` component
        Font.registerOrbitIconFont()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
