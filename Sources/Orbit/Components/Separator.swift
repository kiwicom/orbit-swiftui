import SwiftUI

/// Orbit component that displays vertical separator between content.
///
/// A ``Separator`` consists of an optional label.
///
/// ```swift
/// Separator("OR", thickness: .hairline)
/// ```
/// 
/// ### Customizing appearance
///
/// The label color can be modified by ``textColor(_:)`` modifier.
///
/// ```swift
/// Separator("OR")
///     .textColor(.blueLight)
/// ```
///
/// ### Layout
///
/// Component expands horizontally.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/structure/separator/)
public struct Separator<Label: View>: View {

    @Environment(\.textColor) private var textColor

    private let color: Color
    private let thickness: CGFloat
    @ViewBuilder private let label: Label

    public var body: some View {
        if label.isEmpty {
            line
        } else {
            HStack(spacing: .xxxSmall) {
                leadingLine

                label
                    .textSize(.small)
                    .textColor(textColor ?? .inkNormal)
                    .textFontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .layoutPriority(1)

                trailingLine
            }
        }
    }

    @ViewBuilder private var line: some View {
        color
            .frame(height: thickness)
    }

    @ViewBuilder private var leadingLine: some View {
        HStack(spacing: 0) {
            line
            LinearGradient(colors: [color, color.opacity(0)], startPoint: .leading, endPoint: .trailing)
                .frame(width: .large)
                .frame(height: thickness)
        }
    }

    @ViewBuilder private var trailingLine: some View {
        HStack(spacing: 0) {
            LinearGradient(colors: [color, color.opacity(0)], startPoint: .trailing, endPoint: .leading)
                .frame(width: .large)
                .frame(height: thickness)
            line
        }
    }
    
    /// Creates Orbit ``Separator`` component with custom label.
    public init(
        color: Color = .cloudNormal,
        thickness: CGFloat = 1,
        @ViewBuilder label: () -> Label
    ) {
        self.color = color
        self.thickness = thickness
        self.label = label()
    }
}

// MARK: - Convenience Inits
public extension Separator where Label == Text {

    /// Creates Orbit ``Separator`` component.
    @_disfavoredOverload
    init(
        _ label: some StringProtocol = String(""),
        color: Color = .cloudNormal,
        thickness: CGFloat = 1
    ) {
        self.init(color: color, thickness: thickness) {
            Text(label)
        }
    }
    
    /// Creates Orbit ``Separator`` component with localizable label.
    @_semantics("swiftui.init_with_localization")
    init(
        _ label: LocalizedStringKey = "",
        color: Color = .cloudNormal,
        thickness: CGFloat = 1,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil
    ) {
        self.init(color: color, thickness: thickness) {
            Text(label, tableName: tableName, bundle: bundle)
        }
    }
}

// MARK: - Previews
struct SeparatorPreviews: PreviewProvider {

    public static var previews: some View {
        PreviewWrapper {
            standalone
            labels
            mix
        }
        .padding(.vertical, .medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Separator()
            .previewDisplayName()
    }

    static var labels: some View {
        VStack(spacing: .xLarge) {
            Separator()
            Separator("Separator with label")
        }
        .previewDisplayName()
    }

    static var mix: some View {
        VStack(spacing: .xLarge) {
            Separator("Custom colors", color: .blueNormal)
                .textColor(.productDark)
            Separator("Separator with very very very very very long and multiline label")
            Separator("Hairline thickness", thickness: .hairline)
            Separator("Custom thickness", thickness: .xSmall)
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        labels
            .padding(.vertical, .medium)
    }
}
