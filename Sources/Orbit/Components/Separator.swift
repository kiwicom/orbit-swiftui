import SwiftUI

/// Separates content.
/// 
/// - Important: Component expands horizontally to infinity.
public struct Separator: View {

    let label: String
    let color: Color
    let height: CGFloat
    let verticalPadding: CGFloat

    public var body: some View {
        color
            .frame(height: height)
            .frame(minWidth: .small)
            .padding(.vertical, verticalPadding)
            .overlay(
                HStack(spacing: 0) {
                    if label.isEmpty == false {
                        LinearGradient(
                            colors: [.whiteNormal.opacity(0), .whiteNormal],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: Spacing.large)

                        Text(label, size: .small, weight: .medium)
                            .padding(.horizontal, Spacing.xxSmall)
                            .background(Color.whiteNormal)
                    }

                    if label.isEmpty == false {
                        LinearGradient(
                            colors: [.whiteNormal.opacity(0), .whiteNormal],
                            startPoint: .trailing,
                            endPoint: .leading
                        )
                        .frame(width: .large)
                    }
                }
            )
            .frame(minWidth: .small, maxWidth: .infinity)
    }
}

// MARK: - Inits
public extension Separator {
    
    /// Creates Orbit Separator component.
    init(
        _ label: String = "",
        color: Color = .cloudDark,
        height: CGFloat = 1,
        verticalPadding: CGFloat = Spacing.small
    ) {
        self.label = label
        self.color = color
        self.height = height
        self.verticalPadding = verticalPadding
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
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Separator()
            .padding(.medium)
    }

    static var storybook: some View {
        VStack {
            Separator()
            Separator("Separator with label")
        }
        .padding(.medium)
    }

    static var storybookMix: some View {
        VStack(spacing: .medium) {
            Group {
                Separator("Custom color", color: .inkNormal)
                Separator("Hairline", height: .hairline)
                Separator("Custom height", height: .xSmall)
                Separator("No vertical padding", verticalPadding: 0)
                Separator("Default vertical padding")
                Separator("Custom vertical padding", verticalPadding: .large)
            }
            .border(Color.redLight)
        }
        .padding(.medium)
    }
}
