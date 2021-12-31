import SwiftUI

/// Offers a control to toggle a setting on or off.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/interaction/switch/)
public struct Switch: View {

    public static let size = CGSize(width: 50, height: 28)
    public static let circleDiameter: CGFloat = 30
    public static let dotDiameter: CGFloat = 10
    
    static let borderColor = SwiftUI.Color(white: 0.5, opacity: 0.4)
    
    @Binding private var isOn: Bool
    let isEnabled: Bool

    public var body: some View {
        ZStack {
            Capsule(style: .circular)
                .frame(width: Self.size.width, height: Self.size.height)
                .foregroundColor(tint)

            Circle()
                .frame(width: Self.circleDiameter, height: Self.circleDiameter)
                .foregroundColor(.white)
                .shadow(color: Self.borderColor.opacity(isEnabled ? 0.4 : 0), radius: 2, y: 1.5)
                .overlay(
                    Circle()
                        .strokeBorder(Self.borderColor, lineWidth: BorderWidth.hairline)
                )
                .overlay(
                    Circle()
                        .foregroundColor(tint)
                        .frame(width: Self.dotDiameter, height: Self.dotDiameter)
                )
                .offset(x: isOn ? Self.size.width / 5 : -Self.size.width / 5)
        }
        .accessibility(addTraits: [.isButton])
        .onTapGesture {
            HapticsProvider.sendHapticFeedback(.light(0.5))
            withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                isOn.toggle()
            }
        }
        .disabled(isEnabled == false)
    }

    var tint: Color {
        (isOn ? Color.blueNormal : Color.cloudDarker)
            .opacity(isEnabled ? 1 : 0.5)
    }

    /// Creates Orbit Switch component.
    public init(isOn: Binding<Bool>, isEnabled: Bool = true) {
        self._isOn = isOn
        self.isEnabled = isEnabled
    }
}

// MARK: - Previews
struct SwitchPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone

            VStack {
                orbit
                    .padding()
            }
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        PreviewWrapperWithState(initialState: true) { state in
            Switch(isOn: state)
        }
    }

    @ViewBuilder static var orbit: some View {
        HStack(spacing: .large) {
            Switch(isOn: .constant(true))
            Switch(isOn: .constant(false))
        }
        HStack(spacing: .large) {
            Switch(isOn: .constant(true), isEnabled: false)
            Switch(isOn: .constant(false), isEnabled: false)
        }
    }

    static var snapshots: some View {
        orbit
    }
}
