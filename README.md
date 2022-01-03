<div align="center">
  <a href="https://orbit.kiwi" target="_blank">
    <img alt="orbit-components" src="https://images.kiwi.com/common/orbit-logo-full.png" srcset="https://images.kiwi.com/common/orbit-logo-full@2x.png 2x" />
  </a>
</div>
<br />
<div align="center">

![Kiwi.com library](https://img.shields.io/badge/Kiwi.com-library-00A991)
[![swiftui-version](https://img.shields.io/badge/swiftui-1.0-blue)](https://developer.apple.com/documentation/swiftui)
[![swift-version](https://img.shields.io/badge/swift-5.5-orange)](https://github.com/apple/swift)
[![swift-package-manager](https://img.shields.io/badge/package%20manager-compatible-brightgreen.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB3aWR0aD0iNjJweCIgaGVpZ2h0PSI0OXB4IiB2aWV3Qm94PSIwIDAgNjIgNDkiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8IS0tIEdlbmVyYXRvcjogU2tldGNoIDYzLjEgKDkyNDUyKSAtIGh0dHBzOi8vc2tldGNoLmNvbSAtLT4KICAgIDx0aXRsZT5Hcm91cDwvdGl0bGU+CiAgICA8ZGVzYz5DcmVhdGVkIHdpdGggU2tldGNoLjwvZGVzYz4KICAgIDxnIGlkPSJQYWdlLTEiIHN0cm9rZT0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIxIiBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPgogICAgICAgIDxnIGlkPSJHcm91cCIgZmlsbC1ydWxlPSJub256ZXJvIj4KICAgICAgICAgICAgPHBvbHlnb24gaWQ9IlBhdGgiIGZpbGw9IiNEQkI1NTEiIHBvaW50cz0iNTEuMzEwMzQ0OCAwIDEwLjY4OTY1NTIgMCAwIDEzLjUxNzI0MTQgMCA0OSA2MiA0OSA2MiAxMy41MTcyNDE0Ij48L3BvbHlnb24+CiAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJQYXRoIiBmaWxsPSIjRjdFM0FGIiBwb2ludHM9IjI3IDI1IDMxIDI1IDM1IDI1IDM3IDI1IDM3IDE0IDI1IDE0IDI1IDI1Ij48L3BvbHlnb24+CiAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJQYXRoIiBmaWxsPSIjRUZDNzVFIiBwb2ludHM9IjEwLjY4OTY1NTIgMCAwIDE0IDYyIDE0IDUxLjMxMDM0NDggMCI+PC9wb2x5Z29uPgogICAgICAgICAgICA8cG9seWdvbiBpZD0iUmVjdGFuZ2xlIiBmaWxsPSIjRjdFM0FGIiBwb2ludHM9IjI3IDAgMzUgMCAzNyAxNCAyNSAxNCI+PC9wb2x5Z29uPgogICAgICAgIDwvZz4KICAgIDwvZz4KPC9zdmc+)](https://github.com/apple/swift-package-manager)

  <strong>Orbit is a SwiftUI component library which provides developers the easiest possible way of building Kiwi.com’s products.</strong>

</div>

## Orbit Mission

[Orbit](https://orbit.kiwi) aims to bring order and consistency to all of our products and processes. We elevate user experience and increase the speed and efficiency of how we design and build products.

Orbit is an open-source design system created for specific needs of Kiwi.com and together with that – for needs of travel projects.

This library allows you to integrate the Orbit design system into your iOS SwiftUI project.

## Requirements

- iOS 13
- Swift 5.5
- Xcode 13
- Swift Package Manager

## Installation

Add Orbit package to your project by adding the package dependency:

```swift
.package(name: "Orbit", url: "https://github.com/kiwicom/orbit-swiftui.git", .upToNextMajor(from: "0.8.0")),
```

## Usage

1. Import fonts that are used in orbit-components.

```swift
Font.registerOrbitFonts()
```

2. Include any of our components in your project and use it.

```swift
HStack {
	Text("Hello Orbit!")
	Button("Continue")
}
```

You can also check the `OrbitStorybookComponentsScreen` preview to see all supported components.

### File structure and naming conventions

File structure and component names reflect the Orbit design system structure.

As some Orbit components already exist in standard SwiftUI library (`Text` for example), Orbit components shadows them. In order to access standard component, a `SwifUI.` prefix can be used.

- [Components](https://github.com/kiwicom/orbit-swiftui/tree/main/Sources/Orbit/Components/)
- [Colors](https://github.com/kiwicom/orbit-swiftui/tree/main/Sources/Orbit/Foundation/Colors/)
- [Icons](https://github.com/kiwicom/orbit-swiftui/tree/main/Sources/Orbit/Foundation/Icons/)
- [Illustrations](https://github.com/kiwicom/orbit-swiftui/tree/main/Sources/Orbit/Foundation/Illustrations)
- [Spacing](https://github.com/kiwicom/orbit-swiftui/tree/main/Sources/Orbit/Foundation/Spacing/)

### Components

To use Orbit components in SwiftUI, import Orbit library and use the components using their matching Orbit name.

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

### Foundation

Most Foundation types and values are accessed using extension on related types.

#### Spacing

Use `Spacing` enum with `CGFloat` extensions to access values.

```swift
VStack(spacing: .medium) {
	...
}
.padding(.large)
```

#### Colors

Use `Color` and `UIColor` extensions to access values.

```swift
.foregroundColor(.cloudDarker)
```

#### Borders

Use `BorderRadius` and `BorderWidth` enums.

#### Typography

Use `Font` and `UIFont` extensions. 
Orbit components use Orbit font automatically.
