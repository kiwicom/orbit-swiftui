![Kiwi.com library](https://img.shields.io/badge/Kiwi.com-library-00A991)
[![Latest version](https://img.shields.io/github/v/release/kiwicom/orbit-swiftui?sort=semver)](https://github.com/kiwicom/orbit-swiftui/releases)

## Orbit SwiftUI for iOS

[Orbit design system](https://orbit.kiwi) implemented in [SwiftUI](https://developer.apple.com/tutorials/swiftui) for iOS.

This library allows you to integrate the Orbit design system into your iOS SwiftUI project.

Orbit is an open-source design system created for specific needs of Kiwi.com and together with that – for needs of travel projects.
Read more about Orbit design system at https://orbit.kiwi.

## Requirements

- iOS 13
- Swift 5.5
- Xcode 13
- Swift Package Manager

### File structure and naming conventions

File structure and component names reflect the Orbit design system structure.

As some Orbit components already exist in standard SwiftUI library (for example a `Text` component), Orbit components will shadow them. In order to access standard component, a `SwifUI.` prefix can be used.

