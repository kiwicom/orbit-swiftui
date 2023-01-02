import SwiftUI

/// An Orbit sub-component for constructing ``Tabs`` component.
///
/// - Important: The Tab can only be used as a part of ``Tabs`` component, not standalone.
public struct Tab: View {

    let label: String
    let iconContent: Icon.Content
    let style: TabStyle

    public var body: some View {
        // FIXME: Convert to Button with .title4 style for a background touch feedback
        HStack(spacing: .xSmall) {
            Icon(content: iconContent)
            Text(label, color: nil, weight: .medium, alignment: .center)
        }
        .padding(.vertical, 6) // = 32 height @ normal size
        .padding(.horizontal, .small)
        .contentShape(Rectangle())
        .anchorPreference(key: PreferenceKey.self, value: .bounds) {
            [TabPreference(label: label, style: style, bounds: $0)]
        }
    }

    /// Creates Orbit Tab component, a building block for Tabs component.
    public init(_ label: String, icon: Icon.Content = .none, style: TabStyle = .default) {
        self.label = label
        self.iconContent = icon
        self.style = style
    }
}

// MARK: - Types
extension Tab {

    public enum TabStyle {
        case `default`
        case underlined(Color)
        case underlinedGradient(Orbit.Gradient)

        public var textColor: Color {
            switch self {
                case .default:                              return .inkDark
                case .underlined(let color):                return color
                case .underlinedGradient(let gradient):     return gradient.color
            }
        }

        public var startColor: Color {
            switch self {
                case .default:                              return .whiteDarker
                case .underlined(let color):                return color
                case .underlinedGradient(let gradient):     return gradient.startColor
            }
        }

        public var endColor: Color {
            switch self {
                case .default:                              return .whiteDarker
                case .underlined(let color):                return color
                case .underlinedGradient(let gradient):     return gradient.endColor
            }
        }
    }

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
    let style: Tab.TabStyle
    let bounds: Anchor<CGRect>
}

// MARK: - Previews
struct TabPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            styles
            sizing
            gradients
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Tab("Light", icon: .grid)
            .padding(.medium)
            .previewDisplayName()
    }

    static var styles: some View {
        HStack(spacing: 0) {
            Group {
                Tab("Default", style: .default)
                Tab("Underlined", style: .underlined(.inkDark))
            }
            .border(Color.cloudNormal)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        Tab("Tab")
            .border(Color.cloudNormal)
            .measured()
            .padding(.medium)
            .previewDisplayName()
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
            .border(Color.cloudNormal)
        }
        .padding(.medium)
        .previewDisplayName()
    }
}
