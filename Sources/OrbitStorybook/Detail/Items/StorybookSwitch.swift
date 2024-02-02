import SwiftUI
import Orbit

struct StorybookSwitch {

    static var basic: some View {
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

    static func switchView(isOn: Bool, hasIcon: Bool = false) -> some View {
        StateWrapper(isOn) { isOnState in
            Switch(isOn: isOnState, icon: hasIcon ? .airplaneUp : nil)
        }
    }
}

struct StorybookSwitchPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookSwitch.basic
        }
    }
}
