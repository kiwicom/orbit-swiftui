<div align="center">
  <a href="https://orbit.kiwi" target="_blank">
    <img alt="orbit-components" src="https://images.kiwi.com/common/orbit-logo-full.png" srcset="https://images.kiwi.com/common/orbit-logo-full@2x.png 2x" />
  </a>
</div>
<br />
<div align="center">

[![Kiwi.com library](https://img.shields.io/badge/Kiwi.com-library-00A991)](https://code.kiwi.com)
[![swiftui-version](https://img.shields.io/badge/swiftui-1.0-blue)](https://developer.apple.com/documentation/swiftui)
[![swift-version](https://img.shields.io/badge/swift-5.5-orange)](https://github.com/apple/swift)
[![swift-package-manager](https://img.shields.io/badge/package%20manager-compatible-brightgreen.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB3aWR0aD0iNjJweCIgaGVpZ2h0PSI0OXB4IiB2aWV3Qm94PSIwIDAgNjIgNDkiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8IS0tIEdlbmVyYXRvcjogU2tldGNoIDYzLjEgKDkyNDUyKSAtIGh0dHBzOi8vc2tldGNoLmNvbSAtLT4KICAgIDx0aXRsZT5Hcm91cDwvdGl0bGU+CiAgICA8ZGVzYz5DcmVhdGVkIHdpdGggU2tldGNoLjwvZGVzYz4KICAgIDxnIGlkPSJQYWdlLTEiIHN0cm9rZT0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIxIiBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPgogICAgICAgIDxnIGlkPSJHcm91cCIgZmlsbC1ydWxlPSJub256ZXJvIj4KICAgICAgICAgICAgPHBvbHlnb24gaWQ9IlBhdGgiIGZpbGw9IiNEQkI1NTEiIHBvaW50cz0iNTEuMzEwMzQ0OCAwIDEwLjY4OTY1NTIgMCAwIDEzLjUxNzI0MTQgMCA0OSA2MiA0OSA2MiAxMy41MTcyNDE0Ij48L3BvbHlnb24+CiAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJQYXRoIiBmaWxsPSIjRjdFM0FGIiBwb2ludHM9IjI3IDI1IDMxIDI1IDM1IDI1IDM3IDI1IDM3IDE0IDI1IDE0IDI1IDI1Ij48L3BvbHlnb24+CiAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJQYXRoIiBmaWxsPSIjRUZDNzVFIiBwb2ludHM9IjEwLjY4OTY1NTIgMCAwIDE0IDYyIDE0IDUxLjMxMDM0NDggMCI+PC9wb2x5Z29uPgogICAgICAgICAgICA8cG9seWdvbiBpZD0iUmVjdGFuZ2xlIiBmaWxsPSIjRjdFM0FGIiBwb2ludHM9IjI3IDAgMzUgMCAzNyAxNCAyNSAxNCI+PC9wb2x5Z29uPgogICAgICAgIDwvZz4KICAgIDwvZz4KPC9zdmc+)](https://github.com/apple/swift-package-manager)
[![Build](https://github.com/kiwicom/orbit-swiftui/actions/workflows/ci.yml/badge.svg)](https://github.com/kiwicom/orbit-swiftui/actions/workflows/ci.yml)

  <strong>Orbit is a SwiftUI component library which provides developers the easiest possible way of building Kiwi.com’s products.</strong>

</div>

## Orbit Mission

[Orbit](https://orbit.kiwi) aims to bring order and consistency to all of our products and processes. We elevate user experience and increase the speed and efficiency of how we design and build products.

Orbit is an open-source design system created for specific needs of Kiwi.com and together with that – for needs of travel projects.

This library allows you to integrate the Orbit design system into your iOS SwiftUI project.

## Requirements

- iOS 13
- Xcode 13
- Swift Package Manager

## Installation

Add Orbit package to your project by adding the package dependency:

```swift
.package(name: "Orbit", url: "https://github.com/kiwicom/orbit-swiftui.git", .upToNextMajor(from: "0.8.0")),
```

## Documentation

[![DocC](Documentation/docc.png)](https://kiwicom.github.io/orbit-swiftui/documentation/orbit/)
<br>
[DocC documentation](https://kiwicom.github.io/orbit-swiftui/documentation/orbit/)

The online documentation contains instructions on how to get started with the library once you integrate it into your project, as well as examples and pages for individual components.

You can also build this documentation locally in Xcode (Product -> Build Documentation).

## App Store

The app can also be downloaded from the App Store.

<a href="https://apps.apple.com/us/app/orbit-storybook/id1622225639?itsct=apps_box_badge&amp;itscg=30200" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 150px; height: 50px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=150x50&amp;releaseDate=1651708800&h=19b81a69aa959af2af398c51dc84737a" alt="Download on the App Store" style="border-radius: 13px; width: 150px; height: 50px;"></a>

## Contributing

Feel free to create bug reports and feature requests via the Issues tab.

If you want to directly contribute by fixing a bug or implementing a feature or enhancement, you are welcome to do so. Pull request review has following priorities to check:

1) API consistency with other components (similar components should have similar API)
2) Component variants matching design variants (components should have same properties as design)
3) Visual match to designs
4) Internal code structure consistency (button-like components should use consistent mechanism, haptics etc.)
5) Previews / Storybook consistency (a new component needs to be added to the Storybook)

## Feedback

We want to provide high quality and easy to use components. We can’t do that without your feedback. If you have any suggestions about what we can do to improve, please report it directly as an issue or write to us at #orbit-components on Slack.
