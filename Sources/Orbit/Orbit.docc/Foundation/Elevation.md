# Elevation

Use elevation to bring content closer to users.

## Overview

Elevation makes a view stand out by adding a shadow in light mode.

Note: [Orbit definition](https://orbit.kiwi/foundation/elevation/)

## Adding elevation to a view

Use the `View.elevation(_:)` modifier to add elevation to a view:

```swift
// Level 3 elevation
Color.red
    .frame(width: 100, height: 100)
    .elevation(.level3)

// Pre-rendered level 3 elevation
RoundedRectangle(cornerRadius: .small)
    .fill(Color.blue)
    .frame(width: 100, height: 100)
    .elevation(.level3, shape: .roundedRectangle(background: Color.blue, borderRadius: .small))
```

The higher the elevation level, the more the view stands out.

Multiple views can be elevated at once by using this modifier on a container view.
Either for performance reasons, but also to be able to use `compositingGroup()` modifier
to decide whether the elevation will be applied on each view separately or on their merged composition.

The ``ElevationShape`` specifies whether to apply the elevation on the content itself or whether to apply it
on the `RoundedRectangle` shape with the shadow effect being pre-rendered (enabled by default) 
in order to achieve better performance.

## Suppressing existing elevation

Elevation in child views can be optionally disabled by using ``IsElevationEnabledKey`` environment key,
typically in order to disable elevation that is present by default on some Orbit components,
to be able to apply the elevation for a subset of components at once.

```swift
Switch(...)
    .environment(\.isElevationEnabled, false)
```
