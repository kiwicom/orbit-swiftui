import SwiftUI

struct StorybookDetail: View {

    @State var selectedTab: Int = 0
    @Binding var isColorSchemeInverted: Bool
    @State var filter: String = ""

    let menuItem: Storybook.Item

    var body: some View {
        if menuItem.isSearchable, #available(iOS 15.0, *) {
            detailView
                .searchable(text: $filter, prompt: "Search")
        } else {
            detailView
        }
    }

    @ViewBuilder var detailView: some View {
        VStack(alignment: .leading, spacing: 0) {
            if menuItem.tabs.count > 1 {
                Tabs(selectedIndex: $selectedTab) {
                    ForEach(menuItem.tabs, id: \.self) { tab in
                        Tab(tab)
                    }
                }
                .padding(.medium)
                .overlay(Separator(), alignment: .bottom)
            }

            // Erase required to fix runtime issues
            AnyView(
                ScrollView {
                    detailContent
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .screenLayout(screenLayoutEdges)
                }
            )
        }
        .background(background.edgesIgnoringSafeArea(.all))
        .overlay(topOverlay, alignment: .top)
        .navigationBarItems(trailing: darkModeSwitch)
        .navigationBarTitle("\(String(describing: menuItem).titleCased)", displayMode: .large)
    }

    @ViewBuilder var darkModeSwitch: some View {
        BarButton(.sun) {
            isColorSchemeInverted.toggle()
        }
    }

    @ViewBuilder var topOverlay: some View {
        switch menuItem {
            case .toast:            ToastPreviews.toast
            default:                EmptyView()
        }
    }

    @ViewBuilder var detailContent: some View {
        if menuItem.section == .foundation {
            foundationContent
        } else {
            if menuItem.rawValue < Storybook.Item.list.rawValue {
                detailFirstHalfContent
            } else {
                detailSecondHalfContent
            }
        }
    }

    @ViewBuilder var foundationContent: some View {
        switch(menuItem, selectedTab) {
            case (.colors, 0):              StorybookColors.storybook
            case (.colors, 1):              StorybookColors.storybookStatus
            case (.colors, 2):              StorybookColors.storybookGradient
            case (.icons, _):               StorybookIcons.storybook(filter: filter)
            case (.illustrations, _):       StorybookIllustrations.storybook(filter: filter)
            case (.typography, 0):          StorybookTypography.storybook
            case (.typography, 1):          StorybookTypography.storybookHeading
            default:                        HStack { Heading("🚧 WIP 🚧", style: .title3) }.padding(.large)
        }
    }

    @ViewBuilder var detailFirstHalfContent: some View {
        switch(menuItem, selectedTab) {
            case (.alert, 0):               AlertPreviews.storybook
            case (.alert, 2):               AlertPreviews.storybookMix
            case (.alert, 3):               AlertPreviews.storybookLive
            case (.badge, 0):               BadgePreviews.storybook
            case (.badge, 1):               BadgePreviews.storybookGradient
            case (.badge, 2):               BadgePreviews.storybookMix
            case (.badgeList, 0):           BadgeListPreviews.storybook
            case (.badgeList, 1):           BadgeListPreviews.storybookMix
            case (.button, 0):              ButtonPreviews.storybook
            case (.button, 1):              ButtonPreviews.storybookStatus
            case (.button, 2):              ButtonPreviews.storybookGradient
            case (.button, 3):              ButtonPreviews.storybookMix
            case (.buttonLink, 0):          ButtonLinkPreviews.storybook
            case (.buttonLink, 1):          ButtonLinkPreviews.storybookStatus
            case (.buttonLink, 2):          ButtonLinkPreviews.storybookSizes
            case (.card, _):                CardPreviews.storybook
            case (.carrierLogo, _):         CarrierLogoPreviews.storybook
            case (.checkbox, _):            CheckboxPreviews.storybook
            case (.choiceTile, 0):          ChoiceTilePreviews.storybook
            case (.choiceTile, 1):          ChoiceTilePreviews.storybookCentered
            case (.choiceTile, 2):          ChoiceTilePreviews.storybookMix
            case (.countryFlag, _):         CountryFlagPreviews.storybook
            case (.dialog, _):              DialogPreviews.storybook
            case (.emptyState, _):          EmptyStatePreviews.storybook
            case (.heading, _):             StorybookTypography.storybookHeading
            case (.horizontalScroll, _):    HorizontalScrollPreviews.storybook
            case (.icon, 0):                IconPreviews.storybook
            case (.icon, 1):                IconPreviews.storybookMix
            case (.illustration, _):        IllustrationPreviews.storybook
            case (.inputField, 0):          InputFieldPreviews.storybook
            case (.inputField, 2):          InputFieldPreviews.storybookPassword
            case (.inputField, 3):          InputFieldPreviews.storybookMix
            case (.keyValue, _):            KeyValuePreviews.storybook
            default:                        HStack { Heading("🚧 WIP 🚧", style: .title3) }.padding(.large)
        }
    }

    @ViewBuilder var detailSecondHalfContent: some View {
        switch(menuItem, selectedTab) {
            case (.list, 0):                ListPreviews.storybook
            case (.list, 1):                ListPreviews.storybookMix
            case (.listChoice, 0):          ListChoicePreviews.storybook
            case (.listChoice, 1):          ListChoicePreviews.storybookButton
            case (.listChoice, 2):          ListChoicePreviews.storybookCheckbox
            case (.listChoice, 3):          ListChoicePreviews.storybookMix
            case (.notificationBadge, 0):   NotificationBadgePreviews.storybook
            case (.notificationBadge, 1):   NotificationBadgePreviews.storybookGradient
            case (.notificationBadge, 2):   NotificationBadgePreviews.storybookMix
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

    var background: Color {
        switch(menuItem, selectedTab) {
            case (.card, _):                return Color.screen
            case (.horizontalScroll, _):    return Color.screen
            case (.icons, _):               return Color.screen
            case (.illustrations, _):       return Color.screen
            default:                        return Color.whiteNormal
        }
    }

    var screenLayoutEdges: Edge.Set {
        switch(menuItem, selectedTab) {
            case (.dialog, _):              return []
            default:                        return .all
        }
    }

    init(menuItem: Storybook.Item, isColorSchemeInverted: Binding<Bool> = .constant(false)) {
        self.menuItem = menuItem
        self._isColorSchemeInverted = isColorSchemeInverted
    }
}

struct StorybookDetailPreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            NavigationView {
                StorybookDetail(menuItem: .text)
            }

            NavigationView {
                StorybookDetail(menuItem: .badge)
            }

            NavigationView {
                StorybookDetail(menuItem: .toast)
            }
        }
    }
}
