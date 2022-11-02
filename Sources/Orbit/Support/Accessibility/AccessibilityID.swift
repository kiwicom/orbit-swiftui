import SwiftUI

/// Orbit accessibility identifier for use in wrapper components.
///
/// Can be extended to provide custom accessibility identifiers.
public struct AccessibilityID: RawRepresentable {

    static let alertButtonPrimary           = Self(rawValue: "orbit.alert.button.primary")
    static let alertButtonSecondary         = Self(rawValue: "orbit.alert.button.secondary")
    static let alertTitle                   = Self(rawValue: "orbit.alert.title")
    static let alertIcon                    = Self(rawValue: "orbit.alert.icon")
    static let alertDescription             = Self(rawValue: "orbit.alert.description")
    static let cardTitle                    = Self(rawValue: "orbit.card.title")
    static let cardIcon                     = Self(rawValue: "orbit.card.icon")
    static let cardDescription              = Self(rawValue: "orbit.card.description")
    static let cardActionButtonLink         = Self(rawValue: "orbit.card.action.buttonLink")
    static let checkboxTitle                = Self(rawValue: "orbit.checkbox.title")
    static let checkboxDescription          = Self(rawValue: "orbit.checkbox.description")
    static let choiceTileTitle              = Self(rawValue: "orbit.choicetile.title")
    static let choiceTileIcon               = Self(rawValue: "orbit.choicetile.icon")
    static let choiceTileDescription        = Self(rawValue: "orbit.choicetile.description")
    static let choiceTileBadge              = Self(rawValue: "orbit.choicetile.badge")
    static let dialogTitle                  = Self(rawValue: "orbit.dialog.title")
    static let dialogDescription            = Self(rawValue: "orbit.dialog.description")
    static let dialogButtonPrimary          = Self(rawValue: "orbit.dialog.button.primary")
    static let dialogButtonSecondary        = Self(rawValue: "orbit.dialog.button.secondary")
    static let dialogButtonTertiary         = Self(rawValue: "orbit.dialog.button.tertiary")
    static let emptyStateTitle              = Self(rawValue: "orbit.emptystate.title")
    static let emptyStateDescription        = Self(rawValue: "orbit.emptystate.description")
    static let emptyStateButton             = Self(rawValue: "orbit.emptystate.button")
    static let fieldLabel                   = Self(rawValue: "orbit.field.label")
    static let fieldMessage                 = Self(rawValue: "orbit.field.message")
    static let fieldMessageIcon             = Self(rawValue: "orbit.field.message.icon")
    static let inputPrefix                  = Self(rawValue: "orbit.input.prefix")
    static let inputSuffix                  = Self(rawValue: "orbit.input.suffix")
    static let inputValue                   = Self(rawValue: "orbit.input.value")
    static let inputFieldPasswordToggle     = Self(rawValue: "orbit.inputfield.password.toggle")
    static let keyValueKey                  = Self(rawValue: "orbit.keyvalue.key")
    static let keyValueValue                = Self(rawValue: "orbit.keyvalue.value")
    static let listChoiceTitle              = Self(rawValue: "orbit.listchoice.title")
    static let listChoiceIcon               = Self(rawValue: "orbit.listchoice.icon")
    static let listChoiceDescription        = Self(rawValue: "orbit.listchoice.description")
    static let listChoiceValue              = Self(rawValue: "orbit.listchoice.value")
    static let passwordStrengthIndicator    = Self(rawValue: "orbit.passwordstrengthindicator")
    static let radioTitle                   = Self(rawValue: "orbit.radio.title")
    static let radioDescription             = Self(rawValue: "orbit.radio.description")
    static let tileTitle                    = Self(rawValue: "orbit.tile.title")
    static let tileIcon                     = Self(rawValue: "orbit.tile.icon")
    static let tileDescription              = Self(rawValue: "orbit.tile.description")
    static let tileDisclosureButtonLink     = Self(rawValue: "orbit.tile.disclosure.buttonlink")
    static let tileDisclosureIcon           = Self(rawValue: "orbit.tile.disclosure.icon")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension View {

    /// Uses the specified identifier to identify the view inside a component.
    @available(iOS 14.0, *)
    func accessibilityIdentifier(_ accessibilityID: AccessibilityID) -> some View {
        self.accessibilityIdentifier(accessibilityID.rawValue)
    }

    /// Uses the specified identifier to identify the view inside a component.
    @available(iOS, introduced: 13.0, deprecated: 16.1, renamed: "accessibilityIdentifier(_:)")
    func accessibility(_ accessibilityID: AccessibilityID) -> some View {
        self.accessibility(identifier: accessibilityID.rawValue)
    }
}
