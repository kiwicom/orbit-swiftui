import SwiftUI

struct StorybookDetail: View {

    @State var selectedTab: Int = 0
    @Binding var darkMode: Bool

    let menuItem: Storybook.Item

    var body: some View {
        ScrollView {
            content
        }
        .overlay(menuItem.topOverlay, alignment: .top)
        .navigationBarItems(trailing: darkModeSwitch)
        .navigationBarTitle("\(String(describing: menuItem).titleCased)", displayMode: .large)
    }

    @ViewBuilder var content: some View {
        VStack(alignment: .leading, spacing: 0) {

            if menuItem.tabs.count > 1 {
                VStack(alignment: .leading, spacing: .large) {
                    Tabs(selectedIndex: $selectedTab) {
                        ForEach(menuItem.tabs, id: \.self) { tab in
                            Tab(tab)
                        }
                    }
                }
                .padding(.medium)
            }

            menuItem.preview(selectedTab)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder var darkModeSwitch: some View {
        BarButton(.sun) {
            withAnimation(.easeIn(duration: 1)) {
                darkMode.toggle()
            }
        }
    }

    init(menuItem: Storybook.Item, darkMode: Binding<Bool> = .constant(false)) {
        self.menuItem = menuItem
        self._darkMode = darkMode
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
