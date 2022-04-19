import SwiftUI

public struct StorybookMenu: View {

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
                    .background(
                        VStack {
                            ForEach(Item.allCases, id: \.rawValue) { item in
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
                            }
                        }
                    )
            }
            .navigationBarItems(trailing: darkModeSwitch)
            .navigationBarTitle("Orbit Storybook", displayMode: .large)
        }
        .accentColor(.inkNormal)
        .environment(\.colorScheme, darkMode ? .dark : .light)
    }

    @ViewBuilder var darkModeSwitch: some View {
        BarButton(.sun) {
            withAnimation(.easeIn(duration: 1)) {
                darkMode.toggle()
            }
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

    @ViewBuilder var stackContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            foundation
        }

        VStack(alignment: .leading, spacing: 0) {
            components
        }
    }

    @available(iOS 14, *)
    @ViewBuilder var lazyStackContent: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            foundation
        }

        LazyVStack(alignment: .leading, spacing: 0) {
            components
        }
    }

    @ViewBuilder var content: some View {
        if #available(iOS 14, *) {
            LazyVStack(alignment: .leading, spacing: .medium) {
                lazyStackContent
            }
        } else {
            VStack(alignment: .leading, spacing: .medium) {
                stackContent
            }
        }
    }

    public init() {}

    @ViewBuilder func tileStack(items: [Item]) -> some View {
        ForEach(0 ..< items.count / 2, id: \.self) { rowIndex in
            HStack(alignment: .top, spacing: .xSmall) {
                tile(items[rowIndex * 2])
                tile(items[rowIndex * 2 + 1])
            }
            .padding(.horizontal, .medium)
            .padding(.top, .xxxSmall)
            .padding(.bottom, .xSmall)
            .drawingGroup()
        }
    }

    @ViewBuilder func tile(_ item: Item) -> some View {
        Tile(String(describing: item).titleCased,  iconContent: .sfSymbol(item.sfSymbol), disclosure: .none, titleStyle: .title5) { selectedItem = item
        }
        .frame(maxWidth: .infinity)
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
            StorybookMenu()
            
            StorybookMenu().content
                .previewLayout(.sizeThatFits)

        }
    }
}
