import SwiftUI

/// An icon-based bar button for suitable for actions inside toolbar or navigation bar.
public struct BarButton<Icon: View>: View {

    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

    private let size: Orbit.Icon.Size
    private let alignment: HorizontalAlignment
    private let action: () -> Void
    @ViewBuilder private let icon: Icon

    public var body: some View {
        SwiftUI.Button {
            if isHapticsEnabled {
                HapticsProvider.sendHapticFeedback(.light(0.5))
            }

            action()
        } label: {
            icon
                .padding(.vertical, .xSmall)
                .padding(horizontalEdges, .xSmall)
                .contentShape(Rectangle())
        }
        .buttonStyle(IconButtonStyle())
    }

    var horizontalEdges: Edge.Set {
        switch alignment {
            case .leading:      return .trailing
            case .trailing:     return .leading
            default:            return .horizontal
        }
    }

    /// Creates Orbit BarButton component.
    public init(
        _ icon: Icon.Symbol,
        size: Icon.Size = .large,
        alignment: HorizontalAlignment = .center,
        action: @escaping () -> Void
    ) where Icon == Orbit.Icon {
        self.init(
            size: size,
            alignment: alignment
        ) {
            action()
        } icon: {
            Icon(icon, size: size)
        }
    }

    /// Creates Orbit BarButton component with custom icon.
    public init(
        size: Orbit.Icon.Size = .large,
        alignment: HorizontalAlignment = .center,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> Icon
    ) {
        self.size = size
        self.alignment = alignment
        self.action = action
        self.icon = icon()
    }
}

// MARK: - Previews
struct BarButtonPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            navigationView
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        VStack{
            BarButton(.grid, action: {})
        }
        .previewDisplayName()
    }

    static var navigationView: some View {
        NavigationView {
            Color.cloudNormal
                .navigationBarTitle("Title", displayMode: .inline)
                .navigationBarItems(
                    leading: HStack(spacing: 0) {
                        Group {
                            BarButton(.grid, alignment: .leading, action: {})
                            BarButton(.questionCircle, action: {})
                                .iconColor(.blueDark)
                            BarButton {
                                // No action
                            } icon: {
                                Icon("questionmark.circle.fill")
                                    .iconColor(.greenDark)
                            }
                            BarButton {
                                // No action
                            } icon: {
                                CountryFlag("cz", size: .large)
                            }
                        }
                        .border(.cloudNormal.opacity(0.4))
                    }
                )
                .navigationBarItems(
                    trailing: HStack(spacing: 0) {
                        Group {
                            BarButton {
                                // No action
                            } icon: {
                                Icon("square.and.arrow.up")
                                    .fontWeight(.medium)
                            }

                            BarButton(.shareIos, action: {})
                            BarButton(.grid, alignment: .trailing, action: {})
                        }
                        .border(.cloudNormal.opacity(0.4))
                    }
                )
        }
        .navigationViewStyle(.stack)
        .previewDisplayName()
    }
}
