# File structure and naming conventions

## Overview

File structure and component names reflect the Orbit design system structure.

- Components
- Colors
- Icons
- Illustrations
- Spacing

### Components

To use Orbit components in SwiftUI, import the `Orbit` library and use the components using their matching Orbit name.

```swift
import Orbit

...

VStack(spacing: .medium) {
    Heading("Messages", style: .title2)
    Illustration(.mailbox)
    Text("...<strong>...</strong>...<a href="...">here</a>.")
    Button("Continue", style: .secondary)
}
```

As some Orbit components already exist in standard SwiftUI library (`Text` and `List` for example), you can create a typealias for Orbit components to shadow these. In order to access standard components where needed, a `SwifUI.` prefix can be used to specify the native component.

```swift
// Add these lines to prefer Orbit components over SwiftUI ones
typealias Text = Orbit.Text
typealias List = Orbit.List
```

### Foundation

Most Foundation types and values are accessed using extensions on related types.

#### Spacing

Use the ``Spacing`` enum with `CGFloat` extensions to access values.

```swift
VStack(spacing: .medium) {
    ...
}
.padding(.large)
```

#### Colors

Use `Color` and `UIColor` extensions to access values.

```swift
.foregroundColor(.cloudDark)
```

#### Borders

Use ``BorderRadius`` and ``BorderWidth`` enums.

#### Typography

Use `Font` extensions. 

All Orbit components use the Orbit font (see <doc:GettingStarted>) automatically.
