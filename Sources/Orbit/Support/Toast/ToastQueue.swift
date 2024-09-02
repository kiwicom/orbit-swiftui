import Combine
import SwiftUI

/// Serial queue for Orbit ``Toast`` component.
///
/// Allows adding new messages and dismissing or pausing the currently displayed message in a ``Toast``.
public final class ToastQueue: ObservableObject {

    public static let toastsBufferSize = 5
    public static let dismissTimeout: TimeInterval = 5
    public static let appearDelay: TimeInterval = 0.3
    public static let animationIn: Animation = .spring(response: 0.7, dampingFraction: 0.55)
    public static let animationOut: Animation = .easeIn(duration: 0.35)
    
    enum ToastAction {
        case run
        case pause
        case dismiss
    }
    
    /// View model for Orbit ``Toast`` component.
    public struct Toast: Identifiable {
        
        public let id: UUID
        let progress: Double
        
        @ViewBuilder let icon: AnyView
        @ViewBuilder let description: AnyView

        init(
            id: UUID = UUID(), 
            progress: Double,
            @ViewBuilder description: () -> AnyView,
            @ViewBuilder icon: () -> AnyView
        ) {
            self.id = id
            self.progress = progress
            self.description = description()
            self.icon = icon()
        }

        public init(
            @ViewBuilder description: () -> AnyView,
            @ViewBuilder icon: () -> AnyView = { AnyView(EmptyView()) }
        ) {
            self.init(progress: 0, description: description, icon: icon)
        }
        
        @_disfavoredOverload
        public init(
            _ description: some StringProtocol = String(""),
            icon: Icon.Symbol? = nil
        ) {
            self.init {
                AnyView(Text(description))
            } icon: {
                AnyView(Icon(icon))
            }
        }
        
        @_semantics("swiftui.init_with_localization")
        public init(
            _ description: LocalizedStringKey,
            icon: Icon.Symbol? = nil,
            tableName: String? = nil,
            bundle: Bundle? = nil,
            comment: StaticString? = nil
        ) {
            self.init {
                AnyView(Text(description, tableName: tableName, bundle: bundle))
            } icon: {
                AnyView(Icon(icon))
            }
        }

        func withProgress(_ progress: Double) -> Self {
            .init(id: id, progress: max(min(1, progress), 0)) {
                description
            } icon: {
                icon
            }
        }
    }
    
    /// Currently active Toast.
    @Published private(set) var toast: Toast?

    private var cancellable: AnyCancellable?
    private var toastsSubject = PassthroughSubject<Toast, Never>()
    private var currentToastActionSubject: CurrentValueSubject<ToastAction, Never>?

    /// Creates Orbit ``ToastQueue``.
    public init() {
        cancellable = toastsSubject
            .buffer(size: Self.toastsBufferSize, prefetch: .keepFull, whenFull: .dropOldest)
            .delay(for: .seconds(Self.appearDelay), scheduler: RunLoop.main)
            .flatMap(maxPublishers: .max(1)) { [weak self] toast in
                self?.toastPublisher(for: toast) ?? Just(nil).eraseToAnyPublisher()
            }
            .sink { [weak self] toast in
                self?.processToast(toast)
            }
    }

    /// Add a new Toast to be displayed as soon as there is no active Toast displayed.
    @_disfavoredOverload
    public func add(
        _ description: some StringProtocol = String(""), 
        icon: Icon.Symbol? = nil
    ) {
        add(
            Toast(description, icon: icon)
        )
    }
    
    /// Add a new Toast to be displayed as soon as there is no active Toast displayed.
    public func add(
        _ description: LocalizedStringKey, 
        icon: Icon.Symbol? = nil,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil
    ) {
        add(
            Toast(description, icon: icon)
        )
    }
    
    /// Add a new Toast to be displayed as soon as there is no active Toast displayed.
    public func add(_ toast: Toast) {
        toastsSubject.send(toast)
    }
    
    /// Pause the active Toast dismiss progress.
    public func pause() {
        currentToastActionSubject?.send(.pause)
    }
    
    /// Resume the active Toast dismiss progress.
    public func resume() {
        currentToastActionSubject?.send(.run)
    }
    
    /// Dismiss currently active Toast.
    public func dismiss() {
        currentToastActionSubject?.send(.dismiss)
    }
    
    private func toastPublisher(for toast: Toast) -> AnyPublisher<Toast?, Never> {
        let currentToastActionSubject = CurrentValueSubject<ToastAction, Never>(.run)
        self.currentToastActionSubject = currentToastActionSubject
     
        var timerPublisher: AnyPublisher<Void, Never> {
            Timer
                .publish(every: 0.1, on: RunLoop.main, in: .common)
                .autoconnect()
                .map { _ in () }
                .eraseToAnyPublisher()
        }

        var progressPublisher: AnyPublisher<TimeInterval, Never> {
            Publishers.CombineLatest(timerPublisher, currentToastActionSubject)
                .map(\.1.incrementProgress)
                .scan(0, +)
                .map { (progress: Double) -> Double in
                    progress / Self.dismissTimeout
                }
                .prepend(0)
                .eraseToAnyPublisher()
        }
        
        return Publishers.CombineLatest(progressPublisher, currentToastActionSubject)
            .prefix { (progress: Double, action: ToastAction) in
                progress <= 1 && action != .dismiss
            }
            .map(\.0)
            .map(toast.withProgress)
            .append(Just(nil))
            .eraseToAnyPublisher()
    }
    
    private func processToast(_ toast: Toast?) {
        if let toast = toast {
            if self.toast == nil {
                showToast(toast)
            } else {
                updateCurrentToastWith(toast)
            }
        } else {
            hideCurrentToast()
        }
    }
    
    private func showToast(_ toast: Toast) {
        withAnimation(Self.animationIn) {
            self.toast = toast
        }
    }
    
    private func updateCurrentToastWith(_ toast: Toast) {
        withAnimation(.linear(duration: 0.1)) {
            self.toast = toast
        }
    }
    
    private func hideCurrentToast() {
        withAnimation(Self.animationOut) {
            self.toast = nil
        }
    }
}

private extension ToastQueue.ToastAction {

    var incrementProgress: TimeInterval {
        switch self {
            case .run:          return 0.1
            case .pause:        return 0
            case .dismiss:      return 1
        }
    }
}
