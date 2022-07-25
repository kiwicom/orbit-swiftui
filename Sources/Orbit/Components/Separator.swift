import SwiftUI

/// Separates content.
/// 
/// - Important: Component expands horizontally to infinity.
public struct Separator: View {

    let label: String
    let labelColor: Text.Color
    let color: Color
    let thickness: CGFloat

    public var body: some View {
        if label.isEmpty {
            line
        } else {
            HStack(spacing: .xxxSmall) {
                leadingLine

                Text(label, size: .small, color: labelColor, weight: .medium, alignment: .center)
                    .layoutPriority(1)

                trailingLine
            }
        }
    }

    @ViewBuilder var line: some View {
        color
            .frame(height: thickness)
    }

    @ViewBuilder var leadingLine: some View {
        HStack(spacing: 0) {
            line
            LinearGradient(colors: [color, color.opacity(0)], startPoint: .leading, endPoint: .trailing)
                .frame(width: .large)
                .frame(height: thickness)
        }
    }

    @ViewBuilder var trailingLine: some View {
        HStack(spacing: 0) {
            LinearGradient(colors: [color, color.opacity(0)], startPoint: .trailing, endPoint: .leading)
                .frame(width: .large)
                .frame(height: thickness)
            line
        }
    }
}

// MARK: - Inits
public extension Separator {
    
    /// Creates Orbit Separator component.
    init(
        _ label: String = "",
        labelColor: Text.Color = .inkLight,
        color: Color = .cloudDark,
        thickness: Thickness = .default
    ) {
        self.label = label
        self.labelColor = labelColor
        self.color = color
        self.thickness = thickness.value
    }
}

// MARK: - Types
public extension Separator {

    enum Thickness {
        case `default`
        case hairline
        case custom(CGFloat)

        var value: CGFloat {
            switch self {
                case .`default`:            return 1
                case .hairline:             return .hairline
                case .custom(let value):    return value
            }
        }
    }
}

// MARK: - Previews
struct SeparatorPreviews: PreviewProvider {

    public static var previews: some View {
        PreviewWrapper {
            standalone
            storybook
            storybookMix
        }
        .padding(.vertical, .medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Separator()
    }

    static var storybook: some View {
        VStack(spacing: .xLarge) {
            Separator()
            Separator("Separator with label")
        }
    }

    static var storybookMix: some View {
        VStack(spacing: .xLarge) {
            Separator("Custom colors", labelColor: .custom(.productDark), color: .blueNormal)
            Separator("Separator with very very very very very long and multiline label")
            Separator("Hairline thickness", thickness: .hairline)
            Separator("Custom thickness", thickness: .custom(.xSmall))
        }
    }

    static var snapshot: some View {
        storybook
            .padding(.vertical, .medium)
    }
}

struct SeparatorDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")
            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .padding(.vertical, .medium)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        SeparatorPreviews.storybook
    }
}
