# Getting Started

Set up Orbit to work with your project.

### Register Icon font

In order to display Orbit Icons that use Orbit icon symbols, 
register Orbit icon font once during the app start (or by using the ``OrbitPreviewWrapper`` for previews).

```swift
Font.registerOrbitIconFont()
```

### Register Orbit or custom fonts (Optional)

If you omit this optional step, Orbit components will use the default iOS system fonts for all textual components.

Define `Circular Pro` or any custom font to be used for each font weight variant. [Circular Pro must be licensed](https://orbit.kiwi/foundation/typography/circular-pro/#circular-pro-in-non-kiwicom-projects). 

```swift
Font.orbitFonts = [
    ...
    .regular: Bundle.main.url(forResource: "Circular20-Book.otf", withExtension: nil),
    .medium: Bundle.main.url(forResource: "Circular20-Medium.otf", withExtension: nil),
    .bold: Bundle.main.url(forResource: "Circular20-Bold.otf", withExtension: nil),
    .black: Bundle.main.url(forResource: "Circular20-Black.otf", withExtension: nil),
]
```

Register these fonts once during the app start (or by using the ``OrbitPreviewWrapper`` for previews).

```swift
Font.registerOrbitFonts()
```

### Import the Orbit package

Include Orbit package in your package or project and add `import Orbit` to a SwiftUI file to access Orbit foundations and components.

![Usage in code](usage.png)

### Storybook catalogue screen

The `OrbitStorybook` target contains views that can be checked (using previews or an empty app) to browse a catalogue of all components. 
The storybook is also available as an app on the [AppStore](https://apps.apple.com/us/app/orbit-storybook/id1622225639).

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
