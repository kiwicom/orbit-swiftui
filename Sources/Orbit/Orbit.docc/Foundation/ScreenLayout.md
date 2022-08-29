# Screen Layout

Wrap content in a unified screen layout to get consistently looking screens on iPhone or iPad of various sizes.

## Overview

Screen layout gives content unified padding and frame behaviour that can be dynamic based on compact or regular width environment.

## Adding screen layout to a content

Use the `View.screenLayout()` modifier to add screen layout to a view:

```swift
VStack {
    illustration
    text
    Spacer()
    button
}
.screenLayout()
```

The screen layout modifier adds specified maximum width (``Layout/readableMaxWidth`` by default) and padding behaviour for the provided content.

### Supporting Types

- ``ScreenLayoutPadding``

## Suppressing screen layout

Child views can use `View.ignoreScreenLayoutHorizontalPadding()` to suppress the horizontal padding from screen layout.
