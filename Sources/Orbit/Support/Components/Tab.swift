import SwiftUI

public enum TabStyle {
    case `default`
    case product
    case underlined(Color)
    case underlinedGradient(Orbit.Gradient)

    public var textColor: Color {
        switch self {
            case .default:                              return .inkNormal
            case .product:                              return .inkNormal
            case .underlined(let color):                return color
            case .underlinedGradient(let gradient):     return gradient.color
        }
    }

    public var startColor: Color {
        switch self {
            case .default:                              return .whiteNormal
            case .product:                              return .productNormal
            case .underlined(let color):                return color
            case .underlinedGradient(let gradient):     return gradient.startColor
        }
    }

    public var endColor: Color {
        switch self {
            case .default:                              return .whiteNormal
            case .product:                              return .productNormal
            case .underlined(let color):                return color
            case .underlinedGradient(let gradient):     return gradient.endColor
        }
    }
}

/// An Orbit sub-component for constructing ``Tabs`` component.
///
/// - Important: The Tab can only be used as a part of ``Tabs`` component, not standalone.
public struct Tab: View {

    let label: String
    let style: TabStyle

    public var body: some View {
        // FIXME: Convert to Button with .title4 style for a background touch feedback
        Text(label, color: .none, weight: .medium, alignment: .center)
            .padding(.horizontal, .medium)
            .padding(.vertical, .xSmall)
            .contentShape(Rectangle())
            .anchorPreference(key: PreferenceKey.self, value: .bounds) {
                [TabPreference(label: label, style: style, bounds: $0)]
            }
    }

    /// Creates Orbit Tab component, a building block for Tabs component.
    public init(_ label: String, style: TabStyle = .default) {
        self.label = label
        self.style = style
    }
}

// MARK: - Types
extension Tab {

    struct PreferenceKey: SwiftUI.PreferenceKey {
        typealias Value = [TabPreference]

        static var defaultValue: Value = []

        static func reduce(value: inout Value, nextValue: () -> Value) {
            value.append(contentsOf: nextValue())
        }
    }
}

struct TabPreference {
    let label: String
    let style: TabStyle
    let bounds: Anchor<CGRect>
}

// MARK: - Previews
struct TabPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            styles
            gradients
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Tab("Light", style: .underlinedGradient(.bundleBasic))
            .padding(.medium)
    }

    static var styles: some View {
        HStack(spacing: 0) {
            Group {
                Tab("Default", style: .default)
                Tab("Product", style: .product)
                Tab("Underlined", style: .underlined(.inkNormal))
            }
            .border(Color.cloudDark)
        }
        .padding(.medium)
        .previewDisplayName("TabStyle")
    }

    static var gradients: some View {
        HStack(spacing: 0) {
            Group {
                Tab("Light", style: .underlinedGradient(.bundleBasic))
                    .foregroundColor(.bundleBasic)
                Tab("Comfort longer option", style: .underlinedGradient(.bundleMedium))
                    .foregroundColor(.bundleMedium)
                Tab("All", style: .underlinedGradient(.bundleTop))
            }
            .border(Color.cloudDark)
        }
        .padding(.medium)
        .previewDisplayName("TabStyle - Gradients")
    }
}
