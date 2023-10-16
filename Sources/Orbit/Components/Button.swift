import SwiftUI

/// Displays a single important action a user can take.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/button/)
/// - Important: Component expands horizontally unless prevented by `fixedSize` or `idealSize` modifier.
public struct Button<LeadingIcon: View, TrailingIcon: View>: View, PotentiallyEmptyView {

    @Environment(\.suppressButtonStyle) private var suppressButtonStyle

    private let label: String
    private let type: ButtonType
    private let isTrailingIconSeparated: Bool
    private let action: () -> Void
    @ViewBuilder private let leadingIcon: LeadingIcon
    @ViewBuilder private let trailingIcon: TrailingIcon

    public var body: some View {
        if suppressButtonStyle {
            button
        } else {
            button
                .buttonStyle(
                    OrbitButtonStyle(type: type, isTrailingIconSeparated: isTrailingIconSeparated) {
                        leadingIcon
                    } trailingIcon: {
                        trailingIcon
                    }
                )
        }
    }

    @ViewBuilder var button: some View {
        if isEmpty == false {
            SwiftUI.Button() {
                action()
            } label: {
                Text(label)
            }
        }
    }

    var isEmpty: Bool {
        label.isEmpty && leadingIcon.isEmpty && trailingIcon.isEmpty
    }
}

// MARK: - Inits
public extension Button {

    /// Creates Orbit Button component.
    ///
    /// Button size can be specified using `.buttonSize()` modifier.
    ///
    /// - Parameters:
    ///   - type: A visual style of component. A style can be optionally modified using `status()` modifier when `nil` status value is provided.
    init(
        _ label: String = "",
        icon: Icon.Symbol? = nil,
        disclosureIcon: Icon.Symbol? = nil,
        type: ButtonType = .primary,
        isTrailingIconSeparated: Bool = false,
        action: @escaping () -> Void
    ) where LeadingIcon == Icon, TrailingIcon == Icon {
        self.init(
            label,
            type: type,
            isTrailingIconSeparated: isTrailingIconSeparated
        ) {
            action()
        } icon: {
            Icon(icon)
        } disclosureIcon: {
            Icon(disclosureIcon)
        }
    }

    /// Creates Orbit Button component with custom icons.
    ///
    /// Button size can be specified using `.buttonSize()` modifier.
    ///
    /// - Parameters:
    ///   - type: A visual style of component. A style can be optionally modified using `status()` modifier when `nil` status value is provided.
    init(
        _ label: String = "",
        type: ButtonType = .primary,
        isTrailingIconSeparated: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> LeadingIcon,
        @ViewBuilder disclosureIcon: () -> TrailingIcon = { EmptyView() }
    ) {
        self.label = label
        self.type = type
        self.isTrailingIconSeparated = isTrailingIconSeparated
        self.action = action
        self.leadingIcon = icon()
        self.trailingIcon = disclosureIcon()
    }
}

// MARK: - Types

public enum ButtonType {
    case primary
    case primarySubtle
    case secondary
    case critical
    case criticalSubtle
    case status(Status?, isSubtle: Bool = false)
}

// MARK: - Previews
struct ButtonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            combinations
            sizing

            styles
            statuses
            gradients
            mix
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack {
            Button("Button", icon: .grid, action: {})
            Button(action: {}) // Results in EmptyView
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var combinations: some View {
        VStack(spacing: .medium) {
            Button("Button", icon: .grid, action: {})
            Button("Button", icon: .grid, disclosureIcon: .grid, action: {})
            Button("Button", action: {})
            Button(icon: .grid, action: {})
            Button(icon: .grid, action: {})
                .idealSize()
            Button(icon: .arrowUp, action: {})
                .idealSize()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            Group {
                Button(" ", action: {})
                Button("Button", action: {})
                Button("Button", icon: .grid, action: {})
                Button("Button\nmultiline", icon: .grid, action: {})
                Button(icon: .grid, action: {})
                Group {
                    Button("Button small", action: {})
                    Button("Button small", icon: .grid, action: {})
                    Button(icon: .grid, action: {})
                    Button("Button\nmultiline", action: {})
                }
                .buttonSize(.compact)
            }
            .measured()
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var styles: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            buttons(.primary)
            buttons(.primarySubtle)
            buttons(.secondary)
            buttons(.critical)
            buttons(.criticalSubtle)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var statuses: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            statusButtonStack(.info)
            statusButtonStack(.success)
            statusButtonStack(.warning)
            statusButtonStack(.critical)
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var gradients: some View {
        LazyVStack(alignment: .leading, spacing: .xLarge) {
            buttons(.primary)
                .backgroundColor(Gradient.bundleBasic.background, active: Gradient.bundleBasic.startColor)
                .previewDisplayName("Bundle Basic")
            buttons(.primary)
                .backgroundColor(Gradient.bundleMedium.background, active: Gradient.bundleMedium.startColor)
                .previewDisplayName("Bundle Medium")
            buttons(.primary)
                .backgroundColor(Gradient.bundleTop.background, active: Gradient.bundleTop.startColor)
                .previewDisplayName("Bundle Top")
        }
        .padding(.medium)
        .previewDisplayName()
    }

    @ViewBuilder static var mix: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            Button("Button with SF Symbol") {
                // No action
            } icon: {
                Icon("info.circle.fill")
            }
            Button("Button with Flag", type: .secondary) {
                // No action
            } icon: {
                CountryFlag("us")
            }
        }
        .padding(.medium)
        .previewDisplayName()
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .xLarge) {
            buttons(.primary)
            buttons(.primarySubtle)
            buttons(.secondary)
            buttons(.critical)
            buttons(.criticalSubtle)
        }
        .padding(.medium)
    }

    @ViewBuilder static func buttons(_ type: ButtonType) -> some View {
        VStack(spacing: .small) {
            HStack(spacing: .small) {
                Button("Label", type: type, action: {})
                Button("Label", icon: .grid, type: type, action: {})
            }
            HStack(spacing: .small) {
                Button("Label", disclosureIcon: .chevronForward, type: type, action: {})
                Button("Label", icon: .grid, disclosureIcon: .chevronForward, type: type, action: {})
            }
            HStack(spacing: .small) {
                Button("Label", type: type, action: {})
                    .idealSize()
                Button(icon: .grid, type: type, action: {})
                Spacer()
            }
            HStack(spacing: .small) {
                Button("Label", type: type, action: {})
                    .idealSize()
                Button(icon: .grid, type: type, action: {})
                Spacer()
            }
            .buttonSize(.compact)
        }
    }

    @ViewBuilder static func statusButtonStack(_ status: Status) -> some View {
        VStack(spacing: .xSmall) {
            statusButtons(.status(status))
            statusButtons(.status(status, isSubtle: true))
        }
    }

    @ViewBuilder static func statusButtons(_ type: ButtonType) -> some View {
        HStack(spacing: .xSmall) {
            Button("Label", type: type, action: {})
            Button("Label", icon: .grid, disclosureIcon: .chevronForward, type: type, action: {})
            Button("Label", disclosureIcon: .chevronForward, type: type, action: {})
            Button(icon: .grid, type: type, action: {})

            Spacer(minLength: 0)
        }
        .buttonSize(.compact)
    }
}
