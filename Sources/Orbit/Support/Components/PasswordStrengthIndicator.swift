import SwiftUI

/// Orbit support component that displays password strength indicator.
public struct PasswordStrengthIndicator: View {

    private let passwordStrength: PasswordStrength

    public var body: some View {
        if text.isEmpty == false {
            HStack(spacing: .medium) {
                indicator
                    .animation(.easeOut, value: passwordStrength)

                Text(text)
                    .textSize(.small)
                    .textColor(color)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .accessibility(.passwordStrengthIndicator)
        }
    }

    private var indicator: some View {
        Capsule()
            .fill(.cloudNormal)
            .overlay(bar)
            .frame(height: .xxSmall)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var bar: some View {
        HStack(spacing: 0) {
            Capsule()
                .fill(color)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(0 ..< spacers, id: \.self) { _ in
                Spacer()
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var text: String {
        switch passwordStrength {
            case .weak(let title):     return title
            case .medium(let title):   return title
            case .strong(let title):   return title
        }
    }

    private var spacers: Int {
        switch passwordStrength {
            case .weak:     return 3
            case .medium:   return 1
            case .strong:   return 0
        }
    }

    private var color: Color {
        switch passwordStrength {
            case .weak:     return .redNormal
            case .medium:   return .orangeNormal
            case .strong:   return .greenNormal
        }
    }

    /// Creates Orbit ``PasswordStrengthIndicator`` component.
    public init(passwordStrength: PasswordStrengthIndicator.PasswordStrength) {
        self.passwordStrength = passwordStrength
    }
}

// MARK: - Types
public extension PasswordStrengthIndicator {

    /// Orbit ``PasswordStrengthIndicator`` strength.
    enum PasswordStrength: Equatable {
        case weak(title: String)
        case medium(title: String)
        case strong(title: String)
    }
}

// MARK: - Identifiers
public extension AccessibilityID {

    static let passwordStrengthIndicator = Self(rawValue: "orbit.passwordstrengthindicator")
}

// MARK: - Previews
struct PasswordStrengthIndicatorPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            interactive
        }
        .previewLayout(.sizeThatFits)
        .padding(.medium)
    }

    static var standalone: some View {
        VStack(spacing: .medium) {
            PasswordStrengthIndicator(passwordStrength: .weak(title: "Weak"))
            PasswordStrengthIndicator(passwordStrength: .medium(title: "Medium"))
            PasswordStrengthIndicator(passwordStrength: .strong(title: "Strong"))
        }
        .previewDisplayName()
    }

    static var interactive: some View {
        StateWrapper(PasswordStrengthIndicator.PasswordStrength.weak(title: "weak")) { strength in
            VStack {
                PasswordStrengthIndicator(passwordStrength: strength.wrappedValue)

                HStack {
                    Button("weak", type: .critical) {
                        strength.wrappedValue = .weak(title: "Weak")
                    }
                    Button("medium", type: .status(.warning)) {
                        strength.wrappedValue = .medium(title: "Medium")
                    }
                    Button("strong", type: .status(.success)) {
                        strength.wrappedValue = .strong(title: "Strong")
                    }
                }
            }
        }
        .previewDisplayName()
    }
}
