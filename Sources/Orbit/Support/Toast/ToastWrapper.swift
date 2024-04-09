import SwiftUI

/// Orbit ``ToastWrapper`` component with gesture handling, but no queue management.
public struct ToastWrapper<Description: View, Icon: View>: View {
    
    @Environment(\.isHapticsEnabled) private var isHapticsEnabled
    
    private let minOffsetY: CGFloat = -10
    private let maxOffsetY: CGFloat = 10
    private let progress: CGFloat
    private let pauseAction: () -> Void
    private let resumeAction: () -> Void
    private let dismissAction: () -> Void
    
    @ViewBuilder private let icon: Icon
    @ViewBuilder private let description: Description
    
    @State private var offsetY: CGFloat = 0
    @State private var gaveFeedback: Bool = false
    
    public var body: some View {
        ToastContent(progress: progress) {
            description
        } icon: {
            icon
        }
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
        offsetY < minOffsetY
    }
    
    private var dismissProgress: CGFloat {
        min(0, cappedOffsetY) / minOffsetY
    }
    
    private var opacity: CGFloat {
        return 1 - dismissProgress * 0.2
    }
    
    private var cappedOffsetY: CGFloat {
        min(maxOffsetY, offsetY)
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

    /// Creates Orbit ``ToastWrapper`` component with custom content.
    public init(
        progress: CGFloat = 0,
        pauseAction: @escaping () -> Void,
        resumeAction: @escaping() -> Void,
        dismissAction: @escaping () -> Void,
        @ViewBuilder description: () -> Description,
        @ViewBuilder icon: () -> Icon = { EmptyView() }
    ) {
        self.progress = progress
        self.pauseAction = pauseAction
        self.resumeAction = resumeAction
        self.dismissAction = dismissAction
        self.description = description()
        self.icon = icon()
    }
}

// MARK: - Convenience Inits
public extension ToastWrapper where Description == Text, Icon == Orbit.Icon {
    
    /// Creates Orbit ``ToastWrapper`` component.
    @_disfavoredOverload
    init(
        _ description: some StringProtocol = String(""),
        icon: Icon.Symbol? = nil,
        progress: CGFloat = 0,
        pauseAction: @escaping () -> Void,
        resumeAction: @escaping() -> Void,
        dismissAction: @escaping () -> Void
    ) {
        self.init(
            progress: progress,
            pauseAction: pauseAction,
            resumeAction: resumeAction,
            dismissAction: dismissAction
        ) {
            Text(description)
        } icon: {
            Icon(icon)
        }
    }
    
    /// Creates Orbit ``ToastWrapper`` component with localized description.
    @_semantics("swiftui.init_with_localization")
    init(
        _ description: LocalizedStringKey,
        icon: Icon.Symbol? = nil,
        progress: CGFloat = 0,
        tableName: String? = nil,
        bundle: Bundle? = nil,
        comment: StaticString? = nil,
        pauseAction: @escaping () -> Void,
        resumeAction: @escaping() -> Void,
        dismissAction: @escaping () -> Void
    ) {
        self.init(
            progress: progress,
            pauseAction: pauseAction,
            resumeAction: resumeAction,
            dismissAction: dismissAction
        ) {
            Text(description, tableName: tableName, bundle: bundle)
        } icon: {
            Icon(icon)
        }
    }
}

// MARK: - Previews
struct ToastWrapperPreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .padding(.xLarge)
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        ToastWrapper(
            ToastContentPreviews.description, 
            icon: .checkCircle, 
            progress: 0.6, 
            pauseAction: {}, 
            resumeAction: {}, 
            dismissAction: {}
        )
        .previewDisplayName()
    }
}
