import SwiftUI

/// Orbit support component that displays icon-based button suitable for actions in a toolbar or navigation bar.
public struct BarButton<Icon: View>: View {

    @Environment(\.iconSize) private var iconSize
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled

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
                .iconSize(custom: resolvedIconSize)
                .font(.system(size: resolvedIconSize))
                .foregroundColor(.inkDark)
                .padding(.vertical, .xSmall)
                .padding(horizontalEdges, .xSmall)
                .contentShape(Rectangle())
        }
        .buttonStyle(IconButtonStyle())
    }

    private var resolvedIconSize: CGFloat {
        iconSize ?? Orbit.Icon.Size.large.value
    }

    private var horizontalEdges: Edge.Set {
        switch alignment {
            case .leading:      return .trailing
            case .trailing:     return .leading
            default:            return .horizontal
        }
    }

    /// Creates Orbit ``BarButton`` component.
    public init(
        _ icon: Icon.Symbol,
        alignment: HorizontalAlignment = .center,
        action: @escaping () -> Void
    ) where Icon == Orbit.Icon {
        self.init(alignment: alignment) {
            action()
        } icon: {
            Icon(icon)
        }
    }

    /// Creates Orbit ``BarButton`` component with custom icon.
    public init(
        alignment: HorizontalAlignment = .center,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> Icon
    ) {
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
            sizing
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

    static var sizing: some View {
        VStack(alignment: .leading, spacing: .xSmall) {
            Group {
                BarButton(.grid, action: {})

                BarButton(.grid, action: {})
                    .iconSize(.small)
                BarButton(action: {}) {
                    Icon(.grid)
                        .iconSize(.small)
                }

                BarButton(action: {}) {
                    Icon("questionmark.circle.fill")
                }
                BarButton(action: {}) {
                    Icon("questionmark.circle.fill")
                        .iconSize(.small)
                }
                BarButton(action: {}) {
                    Icon("questionmark.circle.fill")
                }
                .iconSize(.small)
            }
            .background(Color.redLight)
            .measured()

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
                                    .iconSize(.normal)
                                    .iconColor(.greenDark)
                            }
                            BarButton {
                                // No action
                            } icon: {
                                CountryFlag("cz")
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
                                    .iconSize(.normal)
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
