import SwiftUI

public struct Storybook: View {

    static var foundationItems: [Item] {
        Self.Item.allCases.filter { $0.section == .foundation }
    }

    static var componentItems: [Item] {
        Self.Item.allCases.filter { $0.section == .components }
    }

    @State var selectedItem: Item? = nil
    @State var darkMode: Bool = false

    public var body: some View {
        NavigationView {
            ScrollView {
                content
            }
            .navigationBarItems(trailing: darkModeSwitch)
            .navigationBarTitle("Orbit Storybook", displayMode: .large)
        }
        .accentColor(.inkNormal)
        .environment(\.colorScheme, darkMode ? .dark : .light)
    }

    @ViewBuilder var darkModeSwitch: some View {
        BarButton(.sun) {
            darkMode.toggle()
        }
    }

    @ViewBuilder var foundation: some View {
        Heading("Foundation", style: .title1)
            .padding(.vertical, .small)
            .padding(.horizontal, .medium)
        tileStack(items: Self.foundationItems)
    }

    @ViewBuilder var components: some View {
        Heading("Components", style: .title1)
            .padding(.vertical, .small)
            .padding(.horizontal, .medium)
        tileStack(items: Self.componentItems)
    }

    @ViewBuilder var content: some View {
        VStack(alignment: .leading, spacing: .medium) {
            foundation
            components
        }
    }

    public init() {}

    @ViewBuilder func tileStack(items: [Item]) -> some View {
        ForEach(0 ..< items.count / 2, id: \.self) { rowIndex in
            HStack(alignment: .top, spacing: .small) {
                tile(items[rowIndex * 2])
                tile(items[rowIndex * 2 + 1])
            }
            .padding(.horizontal, .medium)
            .padding(.top, .xxxSmall)
            .padding(.bottom, .small)
        }
    }

    @ViewBuilder func tile(_ item: Item) -> some View {
        Tile(
            String(describing: item).titleCased,
            icon: item.tabs.isEmpty ? .timelapse : .sfSymbol(item.sfSymbol),
            disclosure: .none,
            titleStyle: .title5
        ) {
            selectedItem = item
        }
        .opacity(item.tabs.isEmpty ? 0.4 : 1)
        .disabled(item.tabs.isEmpty)
        .frame(maxWidth: .infinity)
        .background(
            NavigationLink(
                tag: item,
                selection: $selectedItem,
                destination: {
                    StorybookDetail(menuItem: item, darkMode: $darkMode)
                },
                label: {
                    EmptyView()
                }
            )
            .hidden()
        )
    }
}

extension String {

    var titleCased: String {
        (first?.uppercased() ?? "") + dropFirst()
    }
}

struct StorybookMenuPreviews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper {
            Storybook()

            VStack {
                Storybook().foundation
                Storybook().components
            }
            .previewLayout(.sizeThatFits)
        }
    }
}
