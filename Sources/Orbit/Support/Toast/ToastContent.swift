import SwiftUI

/// Orbit ``Toast`` with no gesture handling or queue management.
public struct ToastContent<Description: View, Icon: View>: View {

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.textColor) private var textColor

    private let progress: CGFloat
    @ViewBuilder private let icon: Icon
    @ViewBuilder private let description: Description
    
    public var body: some View {
        HStack(alignment: .top, spacing: .xSmall) {
            icon
            description
            Spacer(minLength: 0)
        }
        .textColor(textColor ?? foregroundColor)
        .padding(.small)
        .contentShape(Rectangle())
        .background(background)
    }
    
    @ViewBuilder private var background: some View {
        backgroundColor
            .overlay(progressIndicator, alignment: .leading)
            .clipShape(shape)
            .elevation(.level3, shape: .roundedRectangle())
    }
    
    @ViewBuilder private var progressIndicator: some View {
        GeometryReader { geometry in
            progressColor
                .opacity(max(0, progress * 2 - 0.5) * 0.3)
                .clipShape(shape)
                .frame(width: geometry.size.width * progress, alignment: .bottomLeading)
                .animation(ToastQueue.animationIn, value: progress)
        }
    }

    private var foregroundColor: Color {
        colorScheme == .light ? .whiteNormal : .inkDark
    }

    private var backgroundColor: Color {
        colorScheme == .light ? .inkDark : .whiteDarker
    }

    private var progressColor: Color {
        colorScheme == .light ? .inkNormal : .cloudNormal
    }
    
    private var shape: some Shape {
        RoundedRectangle(cornerRadius: BorderRadius.default, style: .continuous)
    }
    
    /// Creates Orbit ``ToastContent`` component with custom content.
    public init(
        progress: CGFloat = 0,
        @ViewBuilder description: () -> Description,
        @ViewBuilder icon: () -> Icon = { EmptyView() }
    ) {
        self.progress = progress
        self.description = description()
        self.icon = icon()
    }
}

// MARK: - Convenience Inits
public extension ToastContent where Description == Text, Icon == Orbit.Icon {
    
    /// Creates Orbit ``ToastContent`` component.
    @_disfavoredOverload
    init(
        _ description: some StringProtocol = String(""),
        icon: Icon.Symbol? = nil,
        progress: CGFloat = 0
    ) {
        self.init(progress: progress) {
            Text(description)
        } icon: {
            Icon(icon)
        }
    }
    
    /// Creates Orbit ``ToastContent`` component with localized description.
    @_semantics("swiftui.init_with_localization")
    init(
        _ description: LocalizedStringKey,
        icon: Icon.Symbol? = nil,
        progress: CGFloat = 0,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil
    ) {
        self.init(progress: progress) {
            Text(description, tableName: tableName, bundle: bundle)
        } icon: {
            Icon(icon)
        }
    }
}

// MARK: - Previews
struct ToastContentPreviews: PreviewProvider {

    static let description = "Toast shows a brief message that's clear & understandable."
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            progress
        }
        .padding(.xLarge)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        ToastContent(description, icon: .grid)
            .previewDisplayName()

    }

    static var progress: some View {
        VStack(alignment: .leading, spacing: .xxxLarge) {
            ToastContent(description, progress: 0.01)
            ToastContent(description, progress: 0.2)
            ToastContent(description, progress: 0.8)
            ToastContent(description, progress: 1.1)
            ToastContent("Toast shows a brief message that's clear & understandable.", icon: .checkCircle, progress: 0.6)
        }
        .padding(.top, .large)
        .padding(.bottom, .xxxLarge)
        .previewDisplayName()
    }

    static var snapshot: some View {
        progress
            .padding(.medium)
    }
}
