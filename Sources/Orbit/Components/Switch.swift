import SwiftUI

/// Offers a control to toggle a setting on or off.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/interaction/switch/)
public struct Switch: View {

    public static let size = CGSize(width: 50, height: 28)
    public static let circleDiameter: CGFloat = 30
    public static let dotDiameter: CGFloat = 10
    
    static let borderColor = Color(white: 0.2, opacity: 0.25)
    static let animation = Animation.spring(response: 0.25, dampingFraction: 0.6)

    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.colorScheme) var colorScheme
    @Binding private var isOn: Bool

    let hasIcon: Bool
    let isEnabled: Bool

    public var body: some View {
        capsule
            .overlay(indicator)
            .accessibility(addTraits: [.isButton])
            .onTapGesture {
                HapticsProvider.sendHapticFeedback(.light(0.5))
                isOn.toggle()
            }
            .disabled(isEnabled == false)
    }

    @ViewBuilder var capsule: some View {
        Capsule(style: .circular)
            .frame(width: width, height: height)
            .foregroundColor(tint)
            .animation(Self.animation, value: isOn)
    }

    @ViewBuilder var indicator: some View {
        Circle()
            .frame(width: circleDiameter, height: circleDiameter)
            .foregroundColor(indicatorColor)
            .elevation(
                isEnabled ? .custom(opacity: 0.25, radius: 1.4, y: 1.2) : nil,
                shape: .roundedRectangle(borderRadius: circleDiameter / 2)
            )
            .overlay(
                Circle()
                    .strokeBorder(Self.borderColor, lineWidth: BorderWidth.hairline)
            )
            .overlay(indicatorSymbol)
            .offset(x: isOn ? width / 5 : -width / 5)
            .animation(Self.animation, value: isOn)
    }

    @ViewBuilder var indicatorSymbol: some View {
        if hasIcon {
            Icon(
                isOn ? .lock : .lockOpen,
                size: .custom(Icon.Size.small.value * sizeCategory.controlRatio),
                color: iconTint
            )
            .environment(\.sizeCategory, .large)
        } else {
            Circle()
                .foregroundColor(tint)
                .frame(width: dotDiameter, height: dotDiameter)
        }
    }

    var tint: Color {
        (isOn ? .blueNormal : capsuleBackgroundColor)
            .opacity(isEnabled ? 1 : 0.5)
    }

    var iconTint: Color {
        (isOn ? Color.blueNormal : Color.inkNormal)
            .opacity(isEnabled ? 1 : 0.5)
    }

    var capsuleBackgroundColor: Color {
        colorScheme == .light ? .cloudDark : .cloudDark
    }

    var indicatorColor: Color {
        colorScheme == .light ? .whiteNormal : .cloudNormal
    }

    var width: CGFloat {
        Self.size.width * sizeCategory.controlRatio
    }

    var height: CGFloat {
        Self.size.height * sizeCategory.controlRatio
    }

    var circleDiameter: CGFloat {
        Self.circleDiameter * sizeCategory.controlRatio
    }

    var dotDiameter: CGFloat {
        Self.dotDiameter * sizeCategory.controlRatio
    }

    /// Creates Orbit Switch component.
    public init(isOn: Binding<Bool>, hasIcon: Bool = false, isEnabled: Bool = true) {
        self._isOn = isOn
        self.hasIcon = hasIcon
        self.isEnabled = isEnabled
    }
}

// MARK: - Previews
struct SwitchPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            storybook
            storybook
                .preferredColorScheme(.dark)
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        StateWrapper(initialState: true) { state in
            Switch(isOn: state)
        }
    }

    static var storybook: some View {
        VStack(spacing: .large) {
            HStack(spacing: .large) {
                switchView(isOn: true)
                switchView(isOn: true, hasIcon: true)
                switchView(isOn: true, isEnabled: false)
                switchView(isOn: true, hasIcon: true, isEnabled: false)
            }
            HStack(spacing: .large) {
                switchView(isOn: false)
                switchView(isOn: false, hasIcon: true)
                switchView(isOn: false, isEnabled: false)
                switchView(isOn: false, hasIcon: true, isEnabled: false)
            }
        }
    }

    static var snapshot: some View {
        storybook
            .padding(.medium)
    }

    static func switchView(isOn: Bool, hasIcon: Bool = false, isEnabled: Bool = true) -> some View {
        StateWrapper(initialState: isOn) { isOnState in
            Switch(isOn: isOnState, hasIcon: hasIcon, isEnabled: isEnabled)
        }
    }
}

struct SwitchDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")
            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        SwitchPreviews.storybook
    }
}
