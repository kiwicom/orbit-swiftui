import SwiftUI

//protocol StorybookMenuItem {
//    var sfSymbol: String { get }
//    @ViewBuilder var screen: some View { get }
//}

extension Storybook {

//    enum FoundationMenuItem: Int, CaseIterable {
//        case colors
//        case icons
//        case illustrations
//        case typography
//
//        var sfSymbol: String {
//            switch self {
//                case .colors:           return "paintpalette.fill"
//                case .icons:            return "info.circle.fill"
//                case .illustrations:    return "photo.on.rectangle.angled"
//                case .typography:       return "textformat.size"
//            }
//        }
//
//        @ViewBuilder var screen: some View {
//            switch self {
//                case .colors:           StorybookColors()
//                case .icons:            StorybookIcons()
//                case .illustrations:    StorybookIllustrations()
//                case .typography:       StorybookTypography()
//        }
//    }

    enum Section {
        case foundation
        case components
    }

    enum Item: Int, CaseIterable {
        case colors
        case icons
        case illustrations
        case typography

        case alert
        case badge
        case badgeList
        case button
        case buttonLink
        case card
        case carrierLogo
        case countryFlag
        case dialog
        case emptyState
        case heading
        case horizontalScroll
        case checkbox
        case choiceTile
        case icon
        case illustration
        case inputField
        case keyValue
        case list
        case listChoice
        case radio
        case select
        case separator
        case skeleton
        case socialButton
        case `switch`
        case tabs
        case tag
        case text
        case textLink
        case tile
        case tileGroup
        case timeline
        case toast

        var tabs: [String] {
            switch self {
                case .colors:           return ["Basic", "Status", "Gradient"]
                case .icons:            return []
                case .illustrations:    return []
                case .typography:       return ["Text", "Heading"]

                case .alert:            return ["Basic", "Inline", "Mix", "Live"]
                case .badge:            return ["Basic", "Gradient", "Mix"]
                case .badgeList:        return []
                case .button:           return ["Basic", "Status", "Gradient"]
                case .buttonLink:       return ["Basic", "Status", "Sizes"]
                case .card:             return []
                case .carrierLogo:      return []
                case .countryFlag:      return []
                case .dialog:           return []
                case .emptyState:       return []
                case .heading:          return []
                case .horizontalScroll: return []
                case .checkbox:         return []
                case .choiceTile:       return ["Basic", "Centered", "Mix"]
                case .icon:             return ["Basic", "Mix"]
                case .illustration:     return []
                case .inputField:       return ["Basic", "Inline", "Password", "Mix"]
                case .keyValue:         return []
                case .list:             return ["Basic", "Mix"]
                case .listChoice:       return ["Basic", "Button", "Checkbox", "Mix"]
                case .radio:            return []
                case .select:           return ["Basic", "Mix"]
                case .separator:        return ["Basic", "Mix"]
                case .skeleton:         return ["Basic", "Atomic"]
                case .socialButton:     return []
                case .`switch`:         return []
                case .tabs:             return ["Basic", "Live"]
                case .tag:              return []
                case .text:             return []
                case .textLink:         return ["Basic", "Live"]
                case .tile:             return ["Basic", "Mix"]
                case .tileGroup:        return []
                case .timeline:         return ["Basic", "Mix"]
                case .toast:            return ["Basic", "Live"]
            }
        }

        @ViewBuilder func preview(_ tabIndex: Int) -> some View {
            switch(self, tabIndex) {
                case (.colors, 0):              StorybookColors.storybook
                case (.colors, 1):              StorybookColors.storybookStatus
                case (.colors, 2):              StorybookColors.storybookGradient
                case (.icons, 0):               StorybookIcons.storybook
                case (.icons, 1):               StorybookIcons.storybook
                case (.illustrations, _):       StorybookIllustrations.storybook
                case (.typography, 0):          StorybookTypography.storybook
                case (.typography, 1):          StorybookTypography.storybookHeading
                case (.alert, 0):               AlertPreviews.storybook
                case (.alert, 2):               AlertPreviews.storybookMix
                case (.alert, 3):               AlertPreviews.storybookLive
                case (.badge, 0):               BadgePreviews.storybook
                case (.badge, 1):               BadgePreviews.storybookGradient
                case (.badge, 2):               BadgePreviews.storybookMix
                case (.badgeList, _):           BadgeListPreviews.storybook
                case (.button, 0):              ButtonPreviews.storybook
                case (.button, 1):              ButtonPreviews.storybookStatus
                case (.button, 2):              ButtonPreviews.storybookGradient
                case (.buttonLink, 0):          ButtonLinkPreviews.storybook
                case (.buttonLink, 1):          ButtonLinkPreviews.storybookStatus
                case (.buttonLink, 2):          ButtonLinkPreviews.storybookSizes
                case (.card, _):                CardPreviews.storybook
                case (.carrierLogo, _):         CarrierLogoPreviews.storybook
                case (.countryFlag, _):         CountryFlagPreviews.storybook
                case (.dialog, _):              DialogPreviews.content
                case (.emptyState, _):          EmptyStatePreviews.storybook
                case (.heading, _):             StorybookTypography.storybookHeading
                case (.horizontalScroll, _):    HorizontalScrollPreviews.storybook
                case (.checkbox, _):            CheckboxPreviews.storybook
                case (.choiceTile, 0):          ChoiceTilePreviews.storybook
                case (.choiceTile, 1):          ChoiceTilePreviews.storybookCentered
                case (.choiceTile, 2):          ChoiceTilePreviews.storybookMix
                case (.icon, 0):                IconPreviews.storybook
                case (.icon, 1):                IconPreviews.storybookMix
                case (.illustration, _):        IllustrationPreviews.storybook
                case (.inputField, 0):          InputFieldPreviews.storybook
                case (.inputField, 3):          InputFieldPreviews.storybookMix
                case (.keyValue, _):            KeyValuePreviews.storybook
                case (.list, 0):                ListPreviews.storybook
                case (.list, 1):                ListPreviews.storybookMix
                case (.listChoice, 0):          ListChoicePreviews.storybook
                case (.listChoice, 1):          ListChoicePreviews.storybookButton
                case (.listChoice, 2):          ListChoicePreviews.storybookCheckbox
                case (.listChoice, 3):          ListChoicePreviews.storybookMix
                case (.radio, _):               RadioPreviews.storybook
                case (.select, 0):              SelectPreviews.storybook
                case (.select, 1):              SelectPreviews.storybookMix
                case (.separator, 0):           SeparatorPreviews.storybook
                case (.separator, 1):           SeparatorPreviews.storybookMix
                case (.skeleton, 0):            SkeletonPreviews.storybook
                case (.skeleton, 1):            SkeletonPreviews.storybookAtomic
                case (.socialButton, _):        SocialButtonPreviews.storybook
                case (.`switch`, _):            SwitchPreviews.storybook
                case (.tabs, 0):                TabsPreviews.storybook
                case (.tabs, 1):                TabsPreviews.storybookLive
                case (.tag, _):                 TagPreviews.storybook
                case (.text, _):                TextPreviews.storybook
                case (.textLink, 0):            TextLinkPreviews.storybook
                case (.textLink, 1):            TextLinkPreviews.storybookLive
                case (.tile, 0):                TilePreviews.storybook
                case (.tile, 1):                TilePreviews.storybookMix
                case (.tileGroup, _):           TileGroupPreviews.storybook
                case (.timeline, 0):            TimelinePreviews.storybook
                case (.timeline, 1):            TimelinePreviews.storybookMix
                case (.toast, 0):               ToastPreviews.storybook
                case (.toast, 1):               ToastPreviews.storybookLive
                default:                        HStack { Heading("🚧 WIP 🚧", style: .title3) }.padding(.large)
            }
        }

        var sfSymbol: String {
            switch self {
                case .colors:           return "paintpalette.fill"
                case .icons:            return "info.circle.fill"
                case .illustrations:    return "photo.on.rectangle.angled"
                case .typography:       return "textformat.size"

                case .alert:            return "exclamationmark.triangle.fill"
                case .badge:            return "capsule.inset.filled"
                case .badgeList:        return "checklist"
                case .button:           return "rectangle.and.hand.point.up.left.fill"
                case .buttonLink:       return "character.textbox"
                case .card:             return "list.dash.header.rectangle"
                case .carrierLogo:      return "airplane.circle.fill"
                case .countryFlag:      return "flag.fill"
                case .dialog:           return "text.bubble.fill"
                case .emptyState:       return "icloud.slash"
                case .heading:          return "textformat.size.larger"
                case .horizontalScroll: return "rectangle.lefthalf.inset.filled.arrow.left"
                case .checkbox:         return "checkmark.square"
                case .choiceTile:       return "rectangle.badge.checkmark"
                case .icon:             return "info.circle.fill"
                case .illustration:     return "photo.on.rectangle.angled"
                case .inputField:       return "rectangle.and.pencil.and.ellipsis"
                case .keyValue:         return "textformat.123"
                case .list:             return "list.bullet"
                case .listChoice:       return "rectangle.grid.1x2"
                case .radio:            return "smallcircle.filled.circle.fill"
                case .select:           return "rectangle.arrowtriangle.2.outward"
                case .separator:        return "directcurrent"
                case .skeleton:         return "rectangle.dashed"
                case .socialButton:     return "applelogo"
                case .`switch`:         return "switch.2"
                case .tabs:             return "menubar.rectangle"
                case .tag:              return "123.rectangle.fill"
                case .text:             return "text.alignleft"
                case .textLink:         return "text.redaction"
                case .tile:             return "rectangle"
                case .tileGroup:        return "rectangle.grid.2x2"
                case .timeline:         return "calendar.day.timeline.left"
                case .toast:            return "ellipsis.rectangle.fill"
            }
        }

        @ViewBuilder var topOverlay: some View {
            switch self {
                case .toast:            ToastPreviews.standalone
                default:                EmptyView()
            }
        }

        var section: Storybook.Section {
            rawValue < Self.alert.rawValue ? .foundation : .components
        }
    }
}
