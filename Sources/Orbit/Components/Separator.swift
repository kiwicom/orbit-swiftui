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
                            gradient: Gradient(colors: [.white.opacity(0), .white]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: Spacing.large)

                        Text(label, size: .small, weight: .medium)
                            .padding(.horizontal, Spacing.xxSmall)
                            .background(Color.white)
                    }

                    if label.isEmpty == false {
                        LinearGradient(
                            gradient: Gradient(colors: [.white.opacity(0), .white]),
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
            orbit
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Separator()
    }

    static var orbit: some View {
        VStack {
            standalone
            Separator("Label")
        }
    }
}
