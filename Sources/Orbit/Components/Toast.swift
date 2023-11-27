import Combine
import SwiftUI

/// Orbit component that shows a brief overlay message on top of the content.
/// 
/// Each displayed ``ToastWrapper`` (an interactive wrapper over ``ToastContent``) can be dismissed by a gesture.
/// 
/// A ``Toast`` queue is managed by a ``ToastQueue`` that resolves what message will be displayed at which time:
///
/// ```swift
/// @State var toastQueue = ToastQueue()
/// 
/// var body: some View {
///     VStack {
///         // content over which to display Toasts
///     }
///     .overlay(alignment: .top) {
///         Toast(toastQueue: toastQueue)
///     }
/// }
/// ```
/// 
/// ### Layout
///
/// Component expands horizontally unless prevented by the native `fixedSize()` modifier.
/// 
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/information/toast/)
public struct Toast: View {
    
    @ObservedObject private var toastQueue: ToastQueue

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
    
    /// Creates Orbit ``Toast`` component.
    public init(toastQueue: ToastQueue) {
        self.toastQueue = toastQueue
    }
}

/// Orbit ``Toast`` with no gesture handling or queue management.
public struct ToastContent: View {

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.textColor) private var textColor

    private let description: String
    private let icon: Icon.Symbol?
    private let progress: CGFloat
    
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
    
    /// Creates Orbit ``ToastContent`` component with no gesture handling or queue management.
    public init(_ description: String, icon: Icon.Symbol? = nil, progress: CGFloat = 0) {
        self.description = description
        self.icon = icon
        self.progress = progress
    }
}

/// Orbit ``ToastWrapper`` component with gesture handling, but no queue management.
public struct ToastWrapper: View {
    
    static let minOffsetY: CGFloat = -10
    static let maxOffsetY: CGFloat = 10

    @Environment(\.isHapticsEnabled) private var isHapticsEnabled
    
    private let description: String
    private let icon: Icon.Symbol?
    private let progress: CGFloat
    private let pauseAction: () -> Void
    private let resumeAction: () -> Void
    private let dismissAction: () -> Void
    
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
    
    private var isOffsetDismiss: Bool {
        offsetY < Self.minOffsetY
    }
    
    private var dismissProgress: CGFloat {
        min(0, cappedOffsetY) / Self.minOffsetY
    }
    
    private var opacity: CGFloat {
        return 1 - dismissProgress * 0.2
    }
    
    private var cappedOffsetY: CGFloat {
        min(Self.maxOffsetY, offsetY)
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

    /// Creates Orbit ``ToastWrapper`` component.
    public init(
        _ description: String,
        icon: Icon.Symbol? = nil,
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
