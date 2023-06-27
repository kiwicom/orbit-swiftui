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

    enum LiveButtonConfiguration {
        case primary
        case primaryAndSecondary
    }

    static var basic: some View {
        LazyVStack(alignment: .leading, spacing: .large) {
            alerts(showIcons: true, isSuppressed: false)
            alerts(showIcons: false, isSuppressed: false)
            alerts(showIcons: true, isSuppressed: true)
            alerts(showIcons: false, isSuppressed: true)
        }
        .previewDisplayName()
    }

    static var inline: some View {
        LazyVStack(alignment: .leading, spacing: .large) {
            inlineAlerts(showIcon: true, isSuppressed: false)
            inlineAlerts(showIcon: false, isSuppressed: false)
            inlineAlerts(showIcon: true, isSuppressed: true)
            inlineAlerts(showIcon: false, isSuppressed: true)
        }
        .previewDisplayName()
    }

    static var mix: some View {
        LazyVStack(alignment: .leading, spacing: .large) {
            alertPrimaryButtonOnly
            alertNoButtons
        }
        .previewDisplayName()
    }

    static var live: some View {
        StateWrapper(LiveButtonConfiguration?.some(.primaryAndSecondary)) { buttons in
            VStack(spacing: .large) {
                Alert(title, description: description, icon: .informationCircle) {
                    switch buttons.wrappedValue {
                        case nil:
                            EmptyView()
                        case .primary:
                            Button("Primary") {}
                        case .primaryAndSecondary:
                            Button("Primary") {}
                            Button("Secondary") {}
                    }
                }

                Button("Toggle buttons") {
                    withAnimation(.spring()) {
                        switch buttons.wrappedValue {
                            case nil:                       buttons.wrappedValue = .primary
                            case .primary:                  buttons.wrappedValue = .primaryAndSecondary
                            case .primaryAndSecondary:      buttons.wrappedValue = nil
                        }
                    }
                }
            }
            .animation(.default, value: buttons.wrappedValue == nil)
        }
        .previewDisplayName()
    }

    static var alertPrimaryButtonOnly: some View {
        VStack(spacing: .medium) {
            Alert(title, description: description, icon: .informationCircle) {
                Button("Primary") {}
            }
            Alert(description: description, icon: .informationCircle) {
                Button("Primary") {}
            }
            Alert(title, description: description) {
                Button("Primary") {}
            }
            Alert(description: description) {
                Button("Primary") {}
            }
            Alert(title, icon: .informationCircle) {
                Button("Primary") {}
            }
            Alert(title) {
                Button("Primary") {}
            }
            Alert(icon: .informationCircle) {
                Button("Primary") {}
            }
            Alert {
                Button("Primary") {}
            }
            Alert("Intrinsic width") {
                Button("Primary") {}
            }
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

    static func alert(_ title: String, status: Status, icon: Icon.Symbol?, isSuppressed: Bool) -> some View {
        Alert(title, description: description, icon: icon, isSubtle: isSuppressed) {
            Button("Primary") {}
            Button("Secondary") {}
        }
        .status(status)
    }

    static func alerts(showIcons: Bool, isSuppressed: Bool) -> some View {
        VStack(spacing: .medium) {
            alert("Informational message", status: .info, icon: showIcons ? .informationCircle : nil, isSuppressed: isSuppressed)
            alert("Success message", status: .success, icon: showIcons ? .checkCircle : .none, isSuppressed: isSuppressed)
            alert("Warning message", status: .warning, icon: showIcons ? .alertCircle : .none, isSuppressed: isSuppressed)
            alert("Critical message", status: .critical, icon: showIcons ? .alertCircle : .none, isSuppressed: isSuppressed)
        }
    }

    static func inlineAlerts(showIcon: Bool, isSuppressed: Bool) -> some View {
        VStack(spacing: .medium) {
            AlertInline("Informational message", icon: showIcon ? .informationCircle : .none, isSubtle: isSuppressed) {
                Button("Primary") {}
            }

            AlertInline("Success message", icon: showIcon ? .checkCircle : .none, isSubtle: isSuppressed) {
                Button("Primary") {}
            }
            .status(.success)

            AlertInline("Warning message", icon: showIcon ? .alertCircle : .none, isSubtle: isSuppressed) {
                Button("Primary") {}
            }
            .status(.warning)

            AlertInline("Critical message", icon: showIcon ? .alertCircle : .none, isSubtle: isSuppressed) {
                Button("Primary") {}
            }
            .status(.critical)
        }
    }
}

struct StorybookAlertPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookAlert.basic
            StorybookAlert.inline
            StorybookAlert.mix
            StorybookAlert.live
        }
    }
}
