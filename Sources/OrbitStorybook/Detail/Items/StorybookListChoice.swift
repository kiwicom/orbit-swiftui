import SwiftUI
import Orbit

struct StorybookListChoice {

    static let title = "ListChoice tile"
    static let description = "Further description"
    static let value = "Value"
    static let badge = Badge("3", style: .status(.info, inverted: false))
    static let addButton = ListChoiceDisclosure.button(type: .add)
    static let removeButton = ListChoiceDisclosure.button(type: .remove)
    static let uncheckedCheckbox = ListChoiceDisclosure.checkbox(isChecked: false)
    static let checkedCheckbox = ListChoiceDisclosure.checkbox(isChecked: true)

    static var basic: some View {
        Card(contentLayout: .fill) {
            ListChoice(title)
            ListChoice(title, value: "10")
            ListChoice(title, description: description)
            ListChoice(title, description: "Multiline\ndescription", value: "USD")
            ListChoice(title, icon: .airplane)
            ListChoice(title, icon: .airplane, value: value)
            ListChoice(title, description: description, icon: .airplane)
            ListChoice(title, description: description, icon: .airplane, value: value)
            ListChoice(title, description: description, headerContent: {
                badge
            })
            ListChoice(title, description: description, icon: .grid, headerContent: {
                badge
            })
        }
    }

    static var button: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, disclosure: addButton)
            ListChoice(title, disclosure: removeButton)
            ListChoice(title, description: description, disclosure: addButton)
            ListChoice(title, description: description, disclosure: removeButton)
            ListChoice(title, icon: .airplane, disclosure: addButton)
            ListChoice(title, icon: .airplane, disclosure: removeButton)
            ListChoice(title, description: description, icon: .airplane, disclosure: addButton)
            ListChoice(title, description: description, icon: .airplane, disclosure: removeButton)
            ListChoice(title, description: description, icon: .airplane, value: value, disclosure: addButton)
            ListChoice(title, description: description, icon: .airplane, disclosure: removeButton) {
                contentPlaceholder
            } headerContent: {
                headerContent
            }
        }
        .previewDisplayName("Button")
    }

    static var checkbox: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, disclosure: uncheckedCheckbox)
            ListChoice(title, disclosure: checkedCheckbox)
            ListChoice(title, description: description, disclosure: .checkbox(state: .error))
            ListChoice(title, description: description, disclosure: .checkbox(state: .disabled))
            ListChoice(title, icon: .airplane, disclosure: .checkbox(isChecked: false, state: .error))
            ListChoice(title, icon: .airplane, disclosure: .checkbox(isChecked: false, state: .disabled))
            ListChoice(title, description: description, icon: .airplane, disclosure: uncheckedCheckbox)
            ListChoice(title, description: description, icon: .airplane, disclosure: checkedCheckbox)
            ListChoice(title, description: description, icon: .airplane, value: value, disclosure: uncheckedCheckbox)
            ListChoice(title, description: description, icon: .airplane, disclosure: checkedCheckbox) {
                contentPlaceholder
            } headerContent: {
                headerContent
            }
        }
        .previewDisplayName("Checkbox")
    }

    static var mix: some View {
        VStack(alignment: .leading, spacing: .large) {
            plain
            radio
        }
    }

    static var plain: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, disclosure: .none)
            ListChoice(title, description: description, disclosure: .none)
            ListChoice(title, description: "No Separator", disclosure: .none, showSeparator: false)
            ListChoice(title, icon: .airplane, disclosure: .none)
            ListChoice(title, icon: .symbol(.airplane, color: .blueNormal), disclosure: .none)
            ListChoice(title, description: description, icon: .countryFlag("cs"), disclosure: .none)
            ListChoice(title, description: description, icon: .grid, value: value, disclosure: .none)
            ListChoice(title, description: description, disclosure: .none, headerContent: {
                badge
            })
            ListChoice(disclosure: .none) {
                contentPlaceholder
            } headerContent: {
                headerContent
            }
        }
    }

    static var radio: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, description: description, disclosure: .radio(isChecked: false))
            ListChoice(title, description: description, disclosure: .radio(isChecked: true))
            ListChoice(title, description: description, disclosure: .radio(state: .error))
            ListChoice(title, description: description, disclosure: .radio(state: .disabled))
            ListChoice(title, icon: .airplane, disclosure: .radio(isChecked: false, state: .error))
            ListChoice(title, icon: .airplane, disclosure: .radio(isChecked: false, state: .disabled))
            ListChoice(
                title,
                description: description,
                icon: .airplane,
                disclosure: .radio(isChecked: false),
                action: {}
            ) {
                contentPlaceholder
            } headerContent: {
                headerContent
            }
        }
        .previewDisplayName("Radio")
    }

    static var headerContent: some View {
        Text("Custom\nheader content")
            .padding(.vertical, .medium)
            .frame(maxWidth: .infinity)
            .background(Color.blueLightActive)
    }
}

struct StorybookListChoicePreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookListChoice.basic
            StorybookListChoice.button
            StorybookListChoice.checkbox
            StorybookListChoice.mix
        }
    }
}
