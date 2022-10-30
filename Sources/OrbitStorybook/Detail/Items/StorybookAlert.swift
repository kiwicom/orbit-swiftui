import SwiftUI
import Orbit

struct StorybookAlert {

    static let title = "Title"
    static let description = """
        The main description message of this Alert component should be placed here. If you need to use TextLink \
        in this component, please do it by using <a href="..">Normal Underline text style</a>.

        Description message can be <strong>formatted</strong>, but if more <ref>customizaton</ref> is needed a custom \
        description content can be provided instead.
        """
    static let primaryAndSecondaryConfiguration = AlertButtons.primaryAndSecondary("Primary", "Secondary")
    static let primaryConfiguration = AlertButtons.primary("Primary")
    static let secondaryConfiguration = AlertButtons.secondary("Secondary")

    static var basic: some View {
        LazyVStack(alignment: .leading, spacing: .large) {
            alerts(showIcons: true, isSuppressed: false)
            alerts(showIcons: false, isSuppressed: false)
            alerts(showIcons: true, isSuppressed: true)
            alerts(showIcons: false, isSuppressed: true)
        }
    }

    static var mix: some View {
        LazyVStack(alignment: .leading, spacing: .large) {
            alertPrimaryButtonOnly
            alertNoButtons
        }
    }

    static var live: some View {
        StateWrapper(initialState: primaryAndSecondaryConfiguration) { buttons in
            VStack(spacing: .large) {
                Alert(
                    title,
                    description: description,
                    icon: .informationCircle,
                    buttons: buttons.wrappedValue
                )

                Button("Toggle buttons") {
                    withAnimation(.spring()) {
                        switch buttons.wrappedValue {
                            case .none:                     buttons.wrappedValue = primaryConfiguration
                            case .primary:                  buttons.wrappedValue = secondaryConfiguration
                            case .secondary:                buttons.wrappedValue = primaryAndSecondaryConfiguration
                            case .primaryAndSecondary:      buttons.wrappedValue = .none
                        }
                    }
                }
            }
            .animation(.default, value: buttons.wrappedValue.isVisible)
        }
    }

    static var alertPrimaryButtonOnly: some View {
        VStack(spacing: .medium) {
            Alert(title, description: description, icon: .informationCircle, buttons: Self.primaryConfiguration)
            Alert(description: description, icon: .informationCircle, buttons: Self.primaryConfiguration)
            Alert(title, description: description, buttons: Self.primaryConfiguration)
            Alert(description: description, buttons: Self.primaryConfiguration)
            Alert( title, icon: .informationCircle, buttons: Self.primaryConfiguration)
            Alert(title, buttons: Self.primaryConfiguration)
            Alert(icon: .informationCircle, buttons: Self.primaryConfiguration)
            Alert(buttons: Self.primaryConfiguration)
            Alert("Intrinsic width", buttons: Self.primaryConfiguration)
                .idealSize(horizontal: true, vertical: false)
        }
    }

    static var alertNoButtons: some View {
        VStack(spacing: .medium) {
            Alert(title, description: description, icon: .informationCircle)
            Alert(title, description: description)
            Alert(title) {
                contentPlaceholder
            }
            Alert {
                contentPlaceholder
            }
            Alert(title, icon: .informationCircle)
            Alert(icon: .informationCircle)
            Alert(title)
            Alert()
            Alert("Intrinsic width")
                .idealSize(horizontal: true, vertical: false)
        }
    }

    static func alerts(showIcons: Bool, isSuppressed: Bool) -> some View {
        VStack(spacing: .medium) {
            alert("Informational message", status: .info, icon: showIcons ? .informationCircle : .none, isSuppressed: isSuppressed)
            alert("Success message", status: .success, icon: showIcons ? .checkCircle : .none, isSuppressed: isSuppressed)
            alert("Warning message", status: .warning, icon: showIcons ? .alertCircle : .none, isSuppressed: isSuppressed)
            alert("Critical message", status: .critical, icon: showIcons ? .alertCircle : .none, isSuppressed: isSuppressed)
        }
    }

    static func alert(_ title: String, status: Status, icon: Icon.Symbol, isSuppressed: Bool) -> some View {
        Alert(
            title,
            description: description,
            icon: .symbol(icon),
            buttons: primaryAndSecondaryConfiguration,
            status: status,
            isSuppressed: isSuppressed
        )
    }
}

struct StorybookAlertPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookAlert.basic
            StorybookAlert.mix
            StorybookAlert.live
        }
    }
}
