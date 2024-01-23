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
[![swift-package-manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-green)](https://github.com/apple/swift-package-manager)
[![Build](https://github.com/kiwicom/orbit-swiftui/actions/workflows/ci.yml/badge.svg)](https://github.com/kiwicom/orbit-swiftui/actions/workflows/ci.yml)

<strong>Orbit SwiftUI is a component library that provides developers an easy way of building Kiwi.com’s products.</strong>

</div>

## Orbit Mission

[Orbit](https://orbit.kiwi) aims to bring consistency to our products and processes. 

Orbit is an open-source design system created for specific needs of Kiwi.com.

This library allows you to integrate it into your iOS SwiftUI project.

## Requirements

- iOS 13
- Xcode 15
- Swift Package Manager

## Installation

Add Orbit package to your project by adding the package dependency:

```swift
.package(name: "Orbit", url: "https://github.com/kiwicom/orbit-swiftui.git", .upToNextMajor(from: "0.10.0")),
```

## Documentation

[![DocC](Documentation/docc.png)](https://kiwicom.github.io/orbit-swiftui/documentation/orbit/)
<br>
[DocC documentation](https://kiwicom.github.io/orbit-swiftui/documentation/orbit/)

The online documentation contains instructions on how to get started with the library as well as examples and pages for individual components.

You can also build the documentation locally in Xcode (Product -> Build Documentation).

## App Store

The Orbit Storybook that contains a showcase of Orbit foundation and components can be built in Xcode or downloaded as a standalone app in the App Store.

<a href="https://apps.apple.com/us/app/orbit-storybook/id1622225639?itsct=apps_box_badge&amp;itscg=30200" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 150px; height: 50px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=150x50&amp;releaseDate=1651708800&h=19b81a69aa959af2af398c51dc84737a" alt="Download on the App Store" style="border-radius: 13px; width: 150px; height: 50px;"></a>

## Contributing

Feel free to create bug reports and feature requests via the Issues tab.

If you want to directly contribute by fixing a bug or implementing a feature or enhancement, you are welcome to do so. 
Pull request review has following priorities to check:

1) API consistency with other components (similar components should have similar API)
2) Component variants matching design variants (components should have same properties as design)
3) Visual match to designs
4) Internal code structure consistency (button-like components should use consistent mechanism, haptics etc.)
5) Previews / Storybook consistency (a new component needs to be added to the Storybook)

## Feedback

We want to provide high quality and easy to use components. We can’t do that without your feedback. 
If you have any suggestions about what we can do to improve, please report it as an issue.
