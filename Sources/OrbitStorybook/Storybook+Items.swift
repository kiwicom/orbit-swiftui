import SwiftUI

extension Storybook {

    enum Section {
        case foundation
        case components
    }

    enum Item: Int, CaseIterable {
        case colors
        case icons
        case illustrations
        case typography

        case accordion
        case airportIllustration
        case alert
        case badge
        case badgeList
        case button
        case buttonLink
        case callOutBanner
        case card
        case carrierLogo
        case checkbox
        case choiceGroup
        case choiceTile
        case collapse
        case countryFlag
        case coupon
        case dialog
        case emptyState
        case featureIcon
        case heading
        case horizontalScroll
        case icon
        case illustration
        case inputField
        case inputFile
        case inputGroup
        case inputStepper
        case itinerary
        case keyValue
        case list
        case listChoice
        case loading
        case navigationBar
        case notificationBadge
        case pictureCard
        case radio
        case ratingStars
        case seat
        case select
        case separator
        case serviceLogo
        case skeleton
        case slider
        case socialButton
        case stepper
        case `switch`
        case tabs
        case tag
        case text
        case textarea
        case textLink
        case tile
        case tileGroup
        case timeline
        case toast
        case wizard

        var tabs: [String] {
            switch self {
                case .colors:               return ["Basic", "Status", "Product", "Bundle"]
                case .icons:                return ["Basic"]
                case .illustrations:        return ["Basic"]
                case .typography:           return ["Text", "Heading"]

                case .alert:                return ["Basic", "Inline", "Mix", "Live"]
                case .badge:                return ["Basic", "Gradient", "Mix"]
                case .badgeList:            return ["Basic", "Mix"]
                case .button:               return ["Basic", "Status", "Gradient", "Mix"]
                case .buttonLink:           return ["Basic", "Status", "Sizes"]
                case .card:                 return ["Basic"]
                case .carrierLogo:          return ["Basic"]
                case .checkbox:             return ["Basic"]
                case .choiceTile:           return ["Basic", "Centered", "Mix"]
                case .countryFlag:          return ["Basic"]
                case .dialog:               return ["Basic"]
                case .emptyState:           return ["Basic"]
                case .heading:              return ["Basic"]
                case .horizontalScroll:     return ["Basic"]
                case .icon:                 return ["Basic", "Mix"]
                case .illustration:         return ["Basic"]
                case .inputField:           return ["Basic", "Inline", "Password", "Mix"]
                case .keyValue:             return ["Basic"]
                case .list:                 return ["Basic", "Mix"]
                case .listChoice:           return ["Basic", "Button", "Checkbox", "Mix"]
                case .notificationBadge:    return ["Basic", "Gradient", "Mix"]
                case .radio:                return ["Basic"]
                case .select:               return ["Basic", "Mix"]
                case .separator:            return ["Basic", "Mix"]
                case .skeleton:             return ["Basic", "Atomic"]
                case .socialButton:         return ["Basic"]
                case .`switch`:             return ["Basic"]
                case .tabs:                 return ["Basic", "Live"]
                case .tag:                  return ["Basic"]
                case .text:                 return ["Basic"]
                case .textLink:             return ["Basic", "Live"]
                case .tile:                 return ["Basic", "Mix"]
                case .tileGroup:            return ["Basic"]
                case .timeline:             return ["Basic", "Mix"]
                case .toast:                return ["Basic", "Live"]
                default:                    return []
            }
        }

        var sfSymbol: String {
            switch self {
                case .colors:               return "paintpalette.fill"
                case .icons:                return "info.circle.fill"
                case .illustrations:        return "photo.on.rectangle.angled"
                case .typography:           return "textformat.size"

                case .alert:                return "exclamationmark.triangle.fill"
                case .badge:                return "capsule.inset.filled"
                case .badgeList:            return "checklist"
                case .button:               return "rectangle.and.hand.point.up.left.fill"
                case .buttonLink:           return "character.textbox"
                case .card:                 return "list.dash.header.rectangle"
                case .carrierLogo:          return "airplane.circle.fill"
                case .checkbox:             return "checkmark.square"
                case .choiceTile:           return "rectangle.badge.checkmark"
                case .countryFlag:          return "flag.fill"
                case .dialog:               return "text.bubble.fill"
                case .emptyState:           return "icloud.slash"
                case .heading:              return "textformat.size.larger"
                case .horizontalScroll:     return "rectangle.lefthalf.inset.filled.arrow.left"
                case .icon:                 return "info.circle.fill"
                case .illustration:         return "photo.on.rectangle.angled"
                case .inputField:           return "rectangle.and.pencil.and.ellipsis"
                case .keyValue:             return "textformat.123"
                case .list:                 return "list.bullet"
                case .listChoice:           return "rectangle.grid.1x2"
                case .notificationBadge:    return "3.circle.fill"
                case .radio:                return "smallcircle.filled.circle.fill"
                case .select:               return "rectangle.arrowtriangle.2.outward"
                case .separator:            return "directcurrent"
                case .skeleton:             return "rectangle.dashed"
                case .socialButton:         return "lock.icloud"
                case .`switch`:             return "switch.2"
                case .tabs:                 return "menubar.rectangle"
                case .tag:                  return "123.rectangle.fill"
                case .text:                 return "text.alignleft"
                case .textLink:             return "text.redaction"
                case .tile:                 return "rectangle"
                case .tileGroup:            return "rectangle.grid.2x2"
                case .timeline:             return "calendar.day.timeline.left"
                case .toast:                return "ellipsis.rectangle.fill"
                default:                    return ""
            }
        }

        var section: Storybook.Section {
            rawValue <= Self.typography.rawValue ? .foundation : .components
        }

        var isSearchable: Bool {
            switch self {
                case .icons:                return true
                case .illustrations:        return true
                default:                    return false
            }
        }
    }
}
