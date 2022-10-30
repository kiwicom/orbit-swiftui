# Getting Started

Set up Orbit to work with your project.

### Register fonts

If you omit this optional step, Orbit components will use default iOS system fonts.

Define `Circular Pro` or any custom font to be used for each font weight variant. [Circular Pro must be licensed](https://orbit.kiwi/foundation/typography/circular-pro/#circular-pro-in-non-kiwicom-projects). 

```swift
Font.orbitFonts = [
    .regular: Bundle.main.url(forResource: "CircularPro-Book.otf", withExtension: nil),
    .medium: Bundle.main.url(forResource: "CircularPro-Medium.otf", withExtension: nil),
    .bold: Bundle.main.url(forResource: "CircularPro-Bold.otf", withExtension: nil)
]
```

Register those fonts once at app start (or use ``OrbitPreviewWrapper`` for previews).

```swift
Font.registerOrbitFonts()
```

### Import the Orbit package

Include Orbit package in your package or project and include `import Orbit` in SwiftUI file to access Orbit foundations and components.

![Usage in code](usage.png)

### Storybook catalogue screen

The `OrbitStorybook` target contains views that can be checked (using previews or an empty app) to browse a catalogue of all components. The storybook is also available for download on the [AppStore](https://apps.apple.com/us/app/orbit-storybook/id1622225639).

```swift
import OrbitStorybook

@main struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            PreviewWrapper {
                Storybook()
            }
        }
    }
}
```

![image](storybook.png)
