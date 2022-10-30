import SwiftUI
import Orbit

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
            case .toast:            StorybookToast.toast
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
            case (.colors, 0):              StorybookBasicColors()
            case (.colors, 1):              StorybookStatusColors()
            case (.colors, 2):              StorybookProductColors()
            case (.colors, 3):              StorybookBundleColors()
            case (.icons, _):               StorybookIcons.storybook(filter: filter)
            case (.illustrations, _):       StorybookIllustrations.storybook(filter: filter)
            case (.typography, 0):          StorybookTypography.storybook
            case (.typography, 1):          StorybookTypography.storybookHeading
            default:                        HStack { Heading("🚧 WIP 🚧", style: .title3) }.padding(.large)
        }
    }

    @ViewBuilder var detailFirstHalfContent: some View {
        switch(menuItem, selectedTab) {
            case (.alert, 0):               StorybookAlert.basic
            case (.alert, 2):               StorybookAlert.mix
            case (.alert, 3):               StorybookAlert.live
            case (.badge, 0):               StorybookBadge.basic
            case (.badge, 1):               StorybookBadge.gradient
            case (.badge, 2):               StorybookBadge.mix
            case (.badgeList, 0):           StorybookBadgeList.basic
            case (.badgeList, 1):           StorybookBadgeList.mix
            case (.button, 0):              StorybookButton.basic
            case (.button, 1):              StorybookButton.status
            case (.button, 2):              StorybookButton.gradient
            case (.button, 3):              StorybookButton.mix
            case (.buttonLink, 0):          StorybookButtonLink.basic
            case (.buttonLink, 1):          StorybookButtonLink.status
            case (.buttonLink, 2):          StorybookButtonLink.sizes
            case (.card, _):                StorybookCard.basic
            case (.carrierLogo, _):         StorybookCarrierLogo.basic
            case (.checkbox, _):            StorybookCheckbox.basic
            case (.choiceTile, 0):          StorybookChoiceTile.basic
            case (.choiceTile, 1):          StorybookChoiceTile.centered
            case (.choiceTile, 2):          StorybookChoiceTile.mix
            case (.countryFlag, _):         StorybookCountryFlag.basic
            case (.dialog, _):              StorybookDialog.basic
            case (.emptyState, _):          StorybookEmptyState.basic
            case (.heading, _):             StorybookTypography.storybookHeading
            case (.horizontalScroll, _):    StorybookHorizontalScroll.basic
            case (.icon, 0):                StorybookIcon.basic
            case (.icon, 1):                StorybookIcon.mix
            case (.illustration, _):        StorybookIllustration.basic
            case (.inputField, 0):          StorybookInputField.basic
            case (.inputField, 2):          StorybookInputField.password
            case (.inputField, 3):          StorybookInputField.mix
            case (.keyValue, _):            StorybookKeyValue.basic
            default:                        HStack { Heading("🚧 WIP 🚧", style: .title3) }.padding(.large)
        }
    }

    @ViewBuilder var detailSecondHalfContent: some View {
        switch(menuItem, selectedTab) {
            case (.list, 0):                StorybookList.basic
            case (.list, 1):                StorybookList.mix
            case (.listChoice, 0):          StorybookListChoice.basic
            case (.listChoice, 1):          StorybookListChoice.button
            case (.listChoice, 2):          StorybookListChoice.checkbox
            case (.listChoice, 3):          StorybookListChoice.mix
            case (.notificationBadge, 0):   StorybookNotificationBadge.basic
            case (.notificationBadge, 1):   StorybookNotificationBadge.gradient
            case (.notificationBadge, 2):   StorybookNotificationBadge.mix
            case (.radio, _):               StorybookRadio.basic
            case (.select, 0):              StorybookSelect.basic
            case (.select, 1):              StorybookSelect.mix
            case (.separator, 0):           StorybookSeparator.basic
            case (.separator, 1):           StorybookSeparator.mix
            case (.skeleton, 0):            StorybookSkeleton.basic
            case (.skeleton, 1):            StorybookSkeleton.atomic
            case (.socialButton, _):        StorybookSocialButton.basic
            case (.`switch`, _):            StorybookSwitch.basic
            case (.tabs, 0):                StorybookTabs.basic
            case (.tabs, 1):                StorybookTabs.live
            case (.tag, _):                 StorybookTag.basic
            case (.text, _):                StorybookText.basic
            case (.textLink, 0):            StorybookTextLink.basic
            case (.textLink, 1):            StorybookTextLink.live
            case (.tile, 0):                StorybookTile.basic
            case (.tile, 1):                StorybookTile.mix
            case (.tileGroup, _):           StorybookTileGroup.basic
            case (.timeline, 0):            StorybookTimeline.basic
            case (.timeline, 1):            StorybookTimeline.mix
            case (.toast, 0):               StorybookToast.basic
            case (.toast, 1):               StorybookToast.live
            default:                        HStack { Heading("🚧 WIP 🚧", style: .title3) }.padding(.large)
        }
    }

    var background: Color {
        switch(menuItem, selectedTab) {
            case (.card, _):                return .screen
            case (.horizontalScroll, _):    return .screen
            case (.icons, _):               return .screen
            case (.illustrations, _):       return .screen
            default:                        return .whiteNormal
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
        OrbitPreviewWrapper {
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
