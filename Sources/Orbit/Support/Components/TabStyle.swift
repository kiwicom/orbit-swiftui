import SwiftUI

/// Style applied to the active tab in ``Tabs``.
///
/// To apply a style, use the `.activeTabStyle` modifier.
public enum TabStyle: Equatable {
    case `default`
    case underlined(Color)
    case underlinedGradient(Orbit.Gradient)

    var textColor: Color? {
        switch self {
            case .default:                              return nil
            case .underlined(let color):                return color
            case .underlinedGradient(let gradient):     return gradient.textColor
        }
    }

    var underline: LinearGradient {
        switch self {
            case .default:
                return .linearGradient(colors: [.whiteDarker, .whiteDarker], startPoint: .bottom, endPoint: .top)
            case .underlined(let color):
                return .linearGradient(colors: [color, color], startPoint: .bottom, endPoint: .top)
            case .underlinedGradient(let gradient):
                return gradient.background
        }
    }
}

public extension View {

    /// Applies the given style to the active tab in ``Tabs``.
    func activeTabStyle(_ style: TabStyle) -> some View {
        modifier(ActiveTabStyleModifier(style: style))
    }
}
