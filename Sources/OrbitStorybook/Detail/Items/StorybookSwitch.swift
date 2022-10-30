import SwiftUI
import Orbit

struct StorybookSwitch {

    static var basic: some View {
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

    static func switchView(isOn: Bool, hasIcon: Bool = false, isEnabled: Bool = true) -> some View {
        StateWrapper(initialState: isOn) { isOnState in
            Switch(isOn: isOnState, hasIcon: hasIcon, isEnabled: isEnabled)
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
