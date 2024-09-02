import SwiftUI

/// Orbit input component that displays a binary toggle control.
/// A counterpart of the native `SwiftUI.Toggle`. 
///
/// A ``Switch`` consists of a binding to a boolean value and an optional icon.
///
/// ```swift
/// Switch(isOn: $isOn, icon: .airplaneUp)
/// ```
/// 
/// The component can be disabled by ``disabled(_:)`` modifier:
/// 
/// ```swift
/// Switch(isOn: $isOn)
///     .disabled(isDisabled)
/// ```
/// 
/// A default ``Status/info`` status can be modified by ``status(_:)`` modifier:
///
/// ```swift
/// Switch(isOn: $isOn)
///     .status(.critical)
/// ```
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/interaction/switch/)
public struct Switch<Icon: View>: View {

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled
    @Environment(\.status) private var status
    
    @ViewBuilder private let icon: Icon
    @Binding private var isOn: Bool

    public var body: some View {
        Rectangle()
            .frame(width: 50, height: 32)
            .foregroundColor(tint)
            .opacity(isEnabled ? 1 : 0.3)
            .overlay(
                knob,
                alignment: isOn ? .trailing : .leading
            )
            .animation(.easeInOut(duration: 0.15), value: isOn)
            // FIXME: Replace with a SwitchButtonStyle
            .accessibility(addTraits: [.isButton])
            .accessibility(value: SwiftUI.Text(isOn ? "1" : "0"))
            .onTapGesture {
                if isHapticsEnabled {
                    HapticsProvider.sendHapticFeedback(.light(0.5))
                }
                
                isOn.toggle()
            }
            .disabled(isEnabled == false)
            .mask(capsuleMask)
            .overlay(
                outline
            )
    }

    @ViewBuilder private var knob: some View {
        Circle()
            .foregroundColor(indicatorColor)
            .elevation(isEnabled ? .level3 : nil)
            .overlay(knobIcon)
            .padding(.xxxSmall)
    }

    @ViewBuilder private var knobIcon: some View {
        icon
            .iconSize(.small)
            .iconColor(iconTint)
            .opacity(isEnabled ? 1 : 0.3)
            .environment(\.sizeCategory, .large)
            .animation(.easeIn(duration: 0.15), value: isOn)
    }
    
    @ViewBuilder private var outline: some View {
        if let status {
            Capsule(style: .circular)
                .strokeBorder(lineWidth: .xxxSmall)
                .foregroundColor(status.color)
        }
    }
    
    @ViewBuilder private var capsuleMask: some View {
        Capsule(style: .circular)
            .padding(status == nil ? 0 : 1)
    }

    private var tint: Color {
        isOn ? .blueNormal : .cloudDark
    }

    private var iconTint: Color {
        isOn ? .blueDark : .inkLight
    }

    private var indicatorColor: Color {
        colorScheme == .light ? .whiteNormal : .cloudNormal
    }
    
    /// Creates Orbit ``Switch`` component with custom icon.
    public init(
        isOn: Binding<Bool>, 
        @ViewBuilder icon: () -> Icon = { EmptyView() }
    ) {
        self._isOn = isOn
        self.icon = icon()
    }
}

// MARK: - Convenience Inits
public extension Switch {
    
    /// Creates Orbit ``Switch`` component with Orbit ``Icon/Symbol``.
    init(isOn: Binding<Bool>, icon: Icon.Symbol?) where Icon == Orbit.Icon {
        self.init(isOn: isOn) {
            Icon(icon)
        }
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
            Switch(isOn: state, icon: .airplaneUp)
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
            .padding(.bottom, .xLarge)
            
            HStack(spacing: .large) {
                switchView(isOn: true)
                switchView(isOn: true, hasIcon: true)
                switchView(isOn: true)
                    .disabled(true)
                switchView(isOn: true, hasIcon: true)
                    .disabled(true)
            }
            .status(.critical)
            
            HStack(spacing: .large) {
                switchView(isOn: false)
                switchView(isOn: false, hasIcon: true)
                switchView(isOn: false)
                    .disabled(true)
                switchView(isOn: false, hasIcon: true)
                    .disabled(true)
            }
            .status(.critical)
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        states
            .padding(.medium)
    }

    static func switchView(isOn: Bool, hasIcon: Bool = false) -> some View {
        StateWrapper(isOn) { isOnState in
            Switch(isOn: isOnState, icon: hasIcon ? .airplaneUp : nil)
        }
    }
}
