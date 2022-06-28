import SwiftUI

/// Orbit accessibility identifier for use in wrapper components.
public enum AccessibilityID: String {
    case alertButtonPrimary             = "orbit.alert.button.primary"
    case alertButtonSecondary           = "orbit.alert.button.secondary"
    case alertTitle                     = "orbit.alert.title"
    case alertIcon                      = "orbit.alert.icon"
    case alertDescription               = "orbit.alert.description"
    case cardTitle                      = "orbit.card.title"
    case cardIcon                       = "orbit.card.icon"
    case cardDescription                = "orbit.card.description"
    case cardActionButtonLink           = "orbit.card.action.buttonLink"
    case checkboxTitle                  = "orbit.checkbox.title"
    case checkboxDescription            = "orbit.checkbox.description"
    case choiceTileTitle                = "orbit.choicetile.title"
    case choiceTileIcon                 = "orbit.choicetile.icon"
    case choiceTileDescription          = "orbit.choicetile.description"
    case choiceTileBadge                = "orbit.choicetile.badge"
    case dialogTitle                    = "orbit.dialog.title"
    case dialogDescription              = "orbit.dialog.description"
    case dialogButtonPrimary            = "orbit.dialog.button.primary"
    case dialogButtonSecondary          = "orbit.dialog.button.secondary"
    case dialogButtonTertiary           = "orbit.dialog.button.tertiary"
    case emptyStateTitle                = "orbit.emptystate.title"
    case emptyStateDescription          = "orbit.emptystate.description"
    case emptyStateButton               = "orbit.emptystate.button"
    case fieldLabel                     = "orbit.field.label"
    case fieldMessage                   = "orbit.field.message"
    case fieldMessageIcon               = "orbit.field.message.icon"
    case inputPrefix                    = "orbit.input.prefix"
    case inputSuffix                    = "orbit.input.suffix"
    case inputValue                     = "orbit.input.value"
    case inputFieldPasswordToggle       = "orbit.inputfield.password.toggle"
    case keyValueKey                    = "orbit.keyvalue.key"
    case keyValueValue                  = "orbit.keyvalue.value"
    case listChoiceTitle                = "orbit.listchoice.title"
    case listChoiceIcon                 = "orbit.listchoice.icon"
    case listChoiceDescription          = "orbit.listchoice.description"
    case listChoiceValue                = "orbit.listchoice.value"
    case passwordStrengthIndicator      = "orbit.passwordstrengthindicator"
    case radioTitle                     = "orbit.radio.title"
    case radioDescription               = "orbit.radio.description"
    case tileTitle                      = "orbit.tile.title"
    case tileIcon                       = "orbit.tile.icon"
    case tileDescription                = "orbit.tile.description"
    case tileDisclosureButtonLink       = "orbit.tile.disclosure.buttonlink"
    case tileDisclosureIcon             = "orbit.tile.disclosure.icon"
}

extension View {

    /// Uses the specified Orbit identifier to identify the view inside a component.
    func accessibility(_ identifier: AccessibilityID) -> some View {
        self.accessibility(identifier: identifier.rawValue)
    }
}
