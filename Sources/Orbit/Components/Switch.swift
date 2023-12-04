import SwiftUI

/// Orbit input component that displays a binary toggle control.
/// A counterpart of the native `SwiftUI.Toggle`. 
///
/// ```swift
/// Switch(isOn: $isOn)
/// ```
/// 
/// The component can be disabled by ``disabled(_:)`` modifier.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/interaction/switch/)
public struct Switch: View {

    private static let size = CGSize(width: 50, height: 28)
    private static let circleDiameter: CGFloat = 30
    private static let dotDiameter: CGFloat = 10
    private static let borderColor = Color(white: 0.2, opacity: 0.25)
    private static let animation = Animation.spring(response: 0.25, dampingFraction: 0.6)

    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled
    
    private let hasIcon: Bool
    @Binding private var isOn: Bool

    public var body: some View {
        capsule
            .overlay(indicator)
            .accessibility(addTraits: [.isButton])
            .onTapGesture {
                if isHapticsEnabled {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                }
                
                isOn.toggle()
            }
            .disabled(isEnabled == false)
    }

    @ViewBuilder private var capsule: some View {
        Capsule(style: .circular)
            .frame(width: width, height: height)
            .foregroundColor(tint)
            .animation(Self.animation, value: isOn)
    }

    @ViewBuilder private var indicator: some View {
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

    @ViewBuilder private var indicatorSymbol: some View {
        if hasIcon {
            Icon(isOn ? .lock : .lockOpen)
                .iconSize(.small)
                .iconColor(iconTint)
                .environment(\.sizeCategory, .large)
        } else {
            Circle()
                .foregroundColor(tint)
                .frame(width: dotDiameter, height: dotDiameter)
        }
    }

    private var tint: Color {
        (isOn ? .blueNormal : capsuleBackgroundColor)
            .opacity(isEnabled ? 1 : 0.5)
    }

    private var iconTint: Color {
        (isOn ? Color.blueNormal : Color.inkNormal)
            .opacity(isEnabled ? 1 : 0.5)
    }

    private var capsuleBackgroundColor: Color {
        colorScheme == .light ? .cloudDark : .cloudDark
    }

    private var indicatorColor: Color {
        colorScheme == .light ? .whiteNormal : .cloudNormal
    }

    private var width: CGFloat {
        Self.size.width * sizeCategory.controlRatio
    }

    private var height: CGFloat {
        Self.size.height * sizeCategory.controlRatio
    }

    private var circleDiameter: CGFloat {
        Self.circleDiameter * sizeCategory.controlRatio
    }

    private var dotDiameter: CGFloat {
        Self.dotDiameter * sizeCategory.controlRatio
    }
}

// MARK: - Previews
public extension Switch {
    
    /// Creates Orbit ``Switch`` component.
    init(isOn: Binding<Bool>, hasIcon: Bool = false) {
        self._isOn = isOn
        self.hasIcon = hasIcon
    }
}

// MARK: - Previews
struct SwitchPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            states
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        StateWrapper(true) { state in
            Switch(isOn: state)
        }
        .previewDisplayName()
    }

    static var states: some View {
        VStack(spacing: .large) {
            HStack(spacing: .large) {
                switchView(isOn: true)
                switchView(isOn: true, hasIcon: true)
                switchView(isOn: true)
                    .disabled(true)
                switchView(isOn: true, hasIcon: true)
                    .disabled(true)
            }
            HStack(spacing: .large) {
                switchView(isOn: false)
                switchView(isOn: false, hasIcon: true)
                switchView(isOn: false)
                    .disabled(true)
                switchView(isOn: false, hasIcon: true)
                    .disabled(true)
            }
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        states
            .padding(.medium)
    }

    static func switchView(isOn: Bool, hasIcon: Bool = false) -> some View {
        StateWrapper(isOn) { isOnState in
            Switch(isOn: isOnState, hasIcon: hasIcon)
        }
    }
}
