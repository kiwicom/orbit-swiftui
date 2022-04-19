import Combine
import SwiftUI

/// Toast shows a brief message that’s clear & understandable.
///
/// - Usage:
///   - Apply the `Toast` component as a `.top` overlay to existing view.
///   - Provide an instance of `ToastQueue` class which manages a queue of toasts
///
/// The following example shows a Toast applied on view:
///
///     let toastQueue = ToastQueue()
///
///     var body: some View {
///         VStack {
///             // content over which to display Toasts
///         }
///         .overlay(Toast(toastQueue: toastQueue))
///     }
///
/// For standalone usage with gesture handling, but no queue management, a ``ToastWrapper`` component can be used.
/// For standalone usage with no queue management and gesture handling, a ``ToastContent`` component can be used.
///
/// - Related components:
///   - ``Dialog``
///   - ``Alert``
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/information/toast/)
/// - Important: Component expands horizontally to infinity.
public struct Toast: View {
    
    @ObservedObject var toastQueue: ToastQueue

    public var body: some View {
        if let toast = toastQueue.toast {
            ToastWrapper(
                toast.description,
                icon: toast.icon,
                progress: toast.progress,
                pauseAction: toastQueue.pause,
                resumeAction: toastQueue.resume,
                dismissAction: toastQueue.dismiss
            )
            .id(toast.id)
            .padding(.xSmall)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
    
    /// Creates Orbit Toast component with queue management and gesture handling.
    public init(toastQueue: ToastQueue) {
        self.toastQueue = toastQueue
    }
}

/// Variant of Orbit `Toast` component with no gesture handling or queue management.
public struct ToastContent: View {
        
    let description: String
    let icon: Icon.Symbol
    let progress: CGFloat
    
    public var body: some View {
        HStack {
            Label(
                description,
                iconContent: .icon(icon, color: .white),
                style: .text(weight: .regular, color: .white),
                spacing: .xSmall
            )
            .padding(.small)
            
            Spacer()
        }
        .contentShape(Rectangle())
        .background(background)
    }
    
    @ViewBuilder var background: some View {
        Color.inkNormal
            .overlay(progressIndicator, alignment: .leading)
            .clipShape(shape)
            .shadow(
                color: .inkLight.opacity(0.5),
                radius: 50,
                x: 0,
                y: 25
            )
    }
    
    @ViewBuilder var progressIndicator: some View {
        GeometryReader { geometry in
            Color.inkLight
                .opacity(max(0, progress * 2 - 0.5) * 0.3)
                .clipShape(shape)
                .frame(width: geometry.size.width * progress, alignment: .bottomLeading)
                .animation(ToastQueue.animationIn, value: progress)
        }
    }
    
    var shape: some Shape {
        RoundedRectangle(cornerRadius: BorderRadius.default, style: .continuous)
    }
    
    /// Creates Orbit `Toast` component variant with no gesture handling or queue management.
    public init(_ description: String, icon: Icon.Symbol = .none, progress: CGFloat = 0) {
        self.description = description
        self.icon = icon
        self.progress = progress
    }
}

/// Variant of Orbit `Toast` component with gesture handling, but no queue management.
public struct ToastWrapper: View {
    
    static let minOffsetY: CGFloat = -10
    static let maxOffsetY: CGFloat = 10
    
    let description: String
    let icon: Icon.Symbol
    let progress: CGFloat
    let pauseAction: () -> Void
    let resumeAction: () -> Void
    let dismissAction: () -> Void
    
    @State private var offsetY: CGFloat = 0
    @State private var showDismissHint: Bool = false
    @State private var gaveFeedback: Bool = false
    
    public var body: some View {
        ToastContent(description, icon: icon, progress: progress)
            .padding(.bottom, 30)
            .opacity(opacity)
            .overlay(dismissIndicator, alignment: .bottom)
            .offset(y: cappedOffsetY)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        pauseAction()
                        offsetY = gesture.translation.height / 2
                        processDragChanged()
                    }
                    .onEnded { _ in
                        if isOffsetDismiss {
                            dismissAction()
                            showDismissHint = false
                        } else {
                            resumeAction()
                            withAnimation(ToastQueue.animationIn) {
                                offsetY = 0
                            }
                        }
                    }
            )
    }
    
    @ViewBuilder var dismissIndicator: some View {
        if showDismissHint {
            Icon(.closeCircle, color: .inkNormal)
                .background(
                    Color.white
                        .clipShape(Circle())
                        .padding(.xxxSmall)
                )
                .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
    
    var isOffsetDismiss: Bool {
        offsetY < Self.minOffsetY
    }
    
    var dismissProgress: CGFloat {
        min(0, cappedOffsetY) / Self.minOffsetY
    }
    
    var opacity: CGFloat {
        return 1 - dismissProgress * 0.2
    }
    
    var cappedOffsetY: CGFloat {
        min(Self.maxOffsetY, offsetY)
    }
    
    /// Creates Orbit `Toast` component variant with gesture handling.
    public init(
        _ description: String,
        icon: Icon.Symbol = .none,
        progress: CGFloat = 0,
        pauseAction: @escaping () -> Void = {},
        resumeAction: @escaping() -> Void = {},
        dismissAction: @escaping () -> Void = {}
    ) {
        self.description = description
        self.icon = icon
        self.progress = progress
        self.pauseAction = pauseAction
        self.resumeAction = resumeAction
        self.dismissAction = dismissAction
    }
    
    private func processDragChanged() {
        if dismissProgress >= 1, gaveFeedback == false {
            HapticsProvider.sendHapticFeedback(.notification(.warning))
            gaveFeedback = true
        }
        
        if dismissProgress == 0 {
            gaveFeedback = false
        }
        
        if isOffsetDismiss == false, showDismissHint {
            withAnimation(.easeOut(duration: 0.1)) {
                showDismissHint = false
            }
        }
        
        if isOffsetDismiss, showDismissHint == false {
            withAnimation(.easeOut(duration: 0.2).delay(0.4)) {
                showDismissHint = true
            }
        }
    }
}

// MARK: - Previews
struct ToastPreviews: PreviewProvider {

    static let description = "Toast shows a brief message that's clear & understandable."
    static let toastQueue = ToastQueue()
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            standaloneWrapper
            storybook
        }
        .previewLayout(.sizeThatFits)

        PreviewWrapper {
            storybookLive
                .overlay(Toast(toastQueue: toastQueue), alignment: .top)
        }
    }

    static var standalone: some View {
        Toast(toastQueue: toastQueue)
    }

    static var standaloneWrapper: some View {
        ToastWrapper(description, icon: .checkCircle, progress: 0.6)
            .padding(.medium)
            .previewDisplayName("ToastWrapper")
    }

    static var storybook: some View {
        VStack(alignment: .leading, spacing: .xxxLarge) {
            ToastContent(description, progress: 0.01)
            ToastContent(description, progress: 0.2)
            ToastContent(description, progress: 0.8)
            ToastContent(description, progress: 1.1)
            ToastContent("Toast shows a brief message that's clear & understandable.", icon: .checkCircle, progress: 0.6)
        }
        .padding(.medium)
        .padding(.top, .large)
        .padding(.bottom, .xxxLarge)
    }

    static var storybookLive: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Heading("Toast enabled screen", style: .title2)

            Spacer()

            Button("Add toast 1") { toastQueue.add(description)}
            Button("Add toast 2") { toastQueue.add("Another toast message.")}
        }
        .padding(.medium)
        .previewDisplayName("Live Preview")
    }
}
