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
                progress: toast.progress,
                pauseAction: toastQueue.pause,
                resumeAction: toastQueue.resume,
                dismissAction: toastQueue.dismiss
            ) {
                toast.description
            } icon: {
                toast.icon
            }
            .id(toast.id)
            .padding(.xSmall)
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.spring)
        }
    }
    
    /// Creates Orbit ``Toast`` component.
    public init(toastQueue: ToastQueue) {
        self.toastQueue = toastQueue
    }
}

// MARK: - Previews
struct ToastPreviews: PreviewProvider {

    static let toastQueue = ToastQueue()
    static let toastLiveQueue = ToastQueue()
    
    static var previews: some View {
        PreviewWrapper {
            interactive
        }
    }

    static var interactive: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: .medium) {
                Spacer()

                Button("Add toast 1") { toastLiveQueue.add(ToastContentPreviews.description) }
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
}
