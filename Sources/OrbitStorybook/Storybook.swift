import SwiftUI
import Orbit

public struct Storybook: View {

    static var userInterfaceStyleOverride : UIUserInterfaceStyle  {
        get {
            UIApplication.shared.firstKeyWindow?.overrideUserInterfaceStyle ?? .unspecified
        }
        set {
            UIApplication.shared.firstKeyWindow?.overrideUserInterfaceStyle = newValue
        }
    }

    static var foundationItems: [Item] {
        Self.Item.allCases.filter { $0.section == .foundation }
    }

    static var componentItems: [Item] {
        Self.Item.allCases.filter { $0.section == .components }
    }

    @Environment(\.colorScheme) var colorScheme
    @State var selectedItem: Item? = nil
    @State var isColorSchemeInverted: Bool = Self.userInterfaceStyleOverride != .unspecified

    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: .large) {
                    foundation
                    components
                }
            }
            .background(
                NavigationLink(
                    "",
                    isActive: .init(
                        get: { selectedItem != nil },
                        set: { value in
                            if value == false {
                                selectedItem = nil
                            }
                        }
                    )
                ) {
                    AnyView(
                        StorybookDetail(
                            menuItem: selectedItem ?? .colors,
                            isColorSchemeInverted: $isColorSchemeInverted.onUpdate(invertColorScheme)
                        )
                    )
                }
                .hidden()
            )
            .background(Color.whiteNormal.edgesIgnoringSafeArea(.all))
            .navigationBarItems(trailing: darkModeSwitch)
            .navigationBarTitle("Orbit Storybook", displayMode: .large)
        }
        .navigationViewStyle(.stack)
        .accentColor(.inkDark)
    }

    @ViewBuilder var darkModeSwitch: some View {
        BarButton(.sun) {
            isColorSchemeInverted.toggle()
            invertColorScheme()
        }
    }

    @ViewBuilder var foundation: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            Heading("Foundation", style: .title1)
                .padding(.vertical, .small)
                .padding(.horizontal, .medium)
            tileStack(items: Self.foundationItems)
        }
    }

    @ViewBuilder var components: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            Heading("Components", style: .title1)
                .padding(.vertical, .small)
                .padding(.horizontal, .medium)
            tileStack(items: Self.componentItems)
        }
    }

    public init() {}

    @ViewBuilder func tileStack(items: [Item]) -> some View {
        ForEach(0 ..< items.count / 2, id: \.self) { rowIndex in
            HStack(alignment: .top, spacing: .medium) {
                tile(items[rowIndex * 2])
                tile(items[rowIndex * 2 + 1])
            }
            .padding(.horizontal, .medium)
            .padding(.top, .xxSmall)
            .padding(.bottom, .small)
        }
    }

    @ViewBuilder func tile(_ item: Item) -> some View {
        if item.tabs.isEmpty {
            tileContent(item)
                .padding(.vertical, .xxSmall)
                .opacity(0.5)
        } else {
            Tile(disclosure: .none, showBorder: item.tabs.isEmpty == false) {
                selectedItem = item
            } content: {
                tileContent(item)
            }
        }
    }

    @ViewBuilder func tileContent(_ item: Item) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            if item.tabs.isEmpty {
                Icon(.timelapse)
            } else {
                Icon(item.sfSymbol)
            }

            Heading(String(describing: item).titleCased, style: .title6)
                .padding(.leading, .xSmall)
            
            Spacer(minLength: 0)
        }
        .iconSize(.small)
        .padding(.small)
    }

    func invertColorScheme() {
        if isColorSchemeInverted {
            Self.userInterfaceStyleOverride = (colorScheme == .dark ? .light : .dark)
        } else {
            Self.userInterfaceStyleOverride = .unspecified
        }
    }
}

extension UIApplication {

    var firstKeyWindow: UIWindow? {
        windows.first { $0.isKeyWindow }
    }
}

extension Binding {

    /// When the `Binding`'s `wrappedValue` changes, the given closure is executed.
    /// - Parameter closure: Chunk of code to execute whenever the value changes.
    /// - Returns: New `Binding`.
    func onUpdate(_ closure: @escaping () -> Void) -> Binding<Value> {
        .init(
            get: {
                wrappedValue
            },
            set: { newValue in
                wrappedValue = newValue
                closure()
            }
        )
    }
}

struct StorybookMenuPreviews: PreviewProvider {
    static var previews: some View {
        OrbitPreviewWrapper {
            Storybook()

            VStack {
                Storybook().foundation
                Storybook().components
            }
            .previewLayout(.sizeThatFits)
        }
    }
}
