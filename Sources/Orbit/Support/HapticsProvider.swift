import UIKit

public enum HapticsProvider {

    public enum HapticFeedbackType {
        case selection
        case light(_ intensity: CGFloat = 1.0)
        case medium(_ intensity: CGFloat = 1.0)
        case heavy(_ intensity: CGFloat = 1.0)
        case notification(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType)
    }

    private static let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    private static let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private static let heavyImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private static let mediumImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private static let notificationFeedbackGenerator = UINotificationFeedbackGenerator()

    public static func prepareHapticFeedbackGenerator(_ type: HapticFeedbackType) {
        switch type {
            case .selection:                selectionFeedbackGenerator.prepare()
            case .light:                    lightImpactFeedbackGenerator.prepare()
            case .medium:                   mediumImpactFeedbackGenerator.prepare()
            case .heavy:                    heavyImpactFeedbackGenerator.prepare()
            case .notification:             notificationFeedbackGenerator.prepare()
        }
    }

    public static func sendHapticFeedback(_ type: HapticFeedbackType) {
        prepareHapticFeedbackGenerator(type)

        switch type {
            case .selection:                Self.selectionFeedbackGenerator.selectionChanged()
            case .light(let intensity):     Self.lightImpactFeedbackGenerator.impactOccurred(intensity: intensity)
            case .medium(let intensity):    Self.mediumImpactFeedbackGenerator.impactOccurred(intensity: intensity)
            case .heavy(let intensity):     Self.heavyImpactFeedbackGenerator.impactOccurred(intensity: intensity)
            case .notification(let type):   Self.notificationFeedbackGenerator.notificationOccurred(type)
        }
    }
}
