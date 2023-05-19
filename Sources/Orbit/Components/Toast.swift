import Combine
import SwiftUI

/// Toast shows a brief message that’s clear & understandable.
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
    ///
    /// Apply ``Toast`` as a `.top` overlay to an existing view.
    /// Provide an instance of ``ToastQueue``, which manages a queue of toasts.
    ///
    /// The following example shows a ``Toast`` applied to a view:
    ///
    ///    ```swift
    ///    let toastQueue = ToastQueue()
    ///
    ///    var body: some View {
    ///        VStack {
    ///            // content over which to display Toasts
    ///        }
    ///        .overlay(Toast(toastQueue: toastQueue), alignment: .top)
    ///    }
    ///    ```
    /// Alternatively:
    /// - ``ToastWrapper`` can be used when gesture handling is needed, but no queue management.
    /// - ``ToastContent`` when neither gesture handling or queue management is needed.
    public init(toastQueue: ToastQueue) {
        self.toastQueue = toastQueue
    }
}

/// Variant of Orbit `Toast` component with no gesture handling or queue management.
public struct ToastContent: View {

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.textColor) private var textColor

    let description: String
    let icon: Icon.Content?
    let progress: CGFloat
    
    public var body: some View {
        HStack(alignment: .top, spacing: .xSmall) {
            Icon(icon)
            Text(description)
            Spacer(minLength: 0)
        }
        .textColor(textColor ?? foregroundColor)
        .padding(.small)
        .contentShape(Rectangle())
        .background(background)
    }
    
    @ViewBuilder var background: some View {
        backgroundColor
            .overlay(progressIndicator, alignment: .leading)
            .clipShape(shape)
            .elevation(.level3, shape: .roundedRectangle())
    }
    
    @ViewBuilder var progressIndicator: some View {
        GeometryReader { geometry in
            progressColor
                .opacity(max(0, progress * 2 - 0.5) * 0.3)
                .clipShape(shape)
                .frame(width: geometry.size.width * progress, alignment: .bottomLeading)
                .animation(ToastQueue.animationIn, value: progress)
        }
    }

    var foregroundColor: Color {
        colorScheme == .light ? .whiteNormal : .inkDark
    }

    var backgroundColor: Color {
        colorScheme == .light ? .inkDark : .whiteDarker
    }

    var progressColor: Color {
        colorScheme == .light ? .inkNormal : .cloudNormal
    }
    
    var shape: some Shape {
        RoundedRectangle(cornerRadius: BorderRadius.default, style: .continuous)
    }
    
    /// Creates Orbit `Toast` component variant with no gesture handling or queue management.
    public init(_ description: String, icon: Icon.Content? = nil, progress: CGFloat = 0) {
        self.description = description
        self.icon = icon
        self.progress = progress
    }
}

/// Variant of Orbit `Toast` component with gesture handling, but no queue management.
public struct ToastWrapper: View {
    
    static let minOffsetY: CGFloat = -10
    static let maxOffsetY: CGFloat = 10

    @Environment(\.isHapticsEnabled) private var isHapticsEnabled
    
    let description: String
    let icon: Icon.Content?
    let progress: CGFloat
    let pauseAction: () -> Void
    let resumeAction: () -> Void
    let dismissAction: () -> Void
    
    @State private var offsetY: CGFloat = 0
    @State private var gaveFeedback: Bool = false
    
    public var body: some View {
        ToastContent(description, icon: icon, progress: progress)
            .opacity(opacity)
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
                        } else {
                            resumeAction()
                            withAnimation(ToastQueue.animationIn) {
                                offsetY = 0
                            }
                        }
                    }
            )
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
        icon: Icon.Content? = nil,
        progress: CGFloat = 0,
        pauseAction: @escaping () -> Void,
        resumeAction: @escaping() -> Void,
        dismissAction: @escaping () -> Void
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
            if isHapticsEnabled {
                HapticsProvider.sendHapticFeedback(.notification(.warning))
            }
            
            gaveFeedback = true
        }
        
        if dismissProgress == 0 {
            gaveFeedback = false
        }
    }
}

// MARK: - Previews
struct ToastPreviews: PreviewProvider {

    static let description = "Toast shows a brief message that's clear & understandable."
    static let toastQueue = ToastQueue()
    static let toastLiveQueue = ToastQueue()
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            standaloneWrapper
            progress
        }
        .padding(.xLarge)
        .previewLayout(.sizeThatFits)

        PreviewWrapper {
            interactive
        }
    }

    static var standalone: some View {
        ToastContent(description, icon: .grid)
            .previewDisplayName()

    }

    static var standaloneWrapper: some View {
        ToastWrapper(description, icon: .checkCircle, progress: 0.6, pauseAction: {}, resumeAction: {}, dismissAction: {})
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

    static var interactive: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: .medium) {
                Spacer()

                Button("Add toast 1") { toastLiveQueue.add(description) }
                Button("Add toast 2") { toastLiveQueue.add("Another toast message.") }
            }
            .padding(.medium)
            .navigationBarTitle("Toast screen")
            .overlay(toast, alignment: .top)
        }
        .navigationViewStyle(.stack)
        .previewDisplayName()
    }

    static var toast: some View {
        Toast(toastQueue: toastLiveQueue)
    }

    static var snapshot: some View {
        progress
            .padding(.medium)
    }
}
