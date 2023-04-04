import SwiftUI

/// Orbit password strength indicator.
public struct PasswordStrengthIndicator: View {

    let passwordStrength: PasswordStrength

    public var body: some View {
        if text.isEmpty == false {
            HStack(spacing: .medium) {

                indicator

                Text(text, size: .small)
                    .foregroundColor(color)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .animation(.easeOut, value: passwordStrength)
            .accessibility(.passwordStrengthIndicator)
        }
    }

    var indicator: some View {
        Capsule()
            .fill(Color.cloudNormal)
            .overlay(bar)
            .frame(height: .xxSmall)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    var bar: some View {
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

    var text: String {
        switch passwordStrength {
            case .empty:               return ""
            case .weak(let title):     return title
            case .medium(let title):   return title
            case .strong(let title):   return title
        }
    }

    var spacers: Int {
        switch passwordStrength {
            case .empty:    return 4
            case .weak:     return 3
            case .medium:   return 1
            case .strong:   return 0
        }
    }

    var color: Color {
        switch passwordStrength {
            case .empty:    return .clear
            case .weak:     return .redNormal
            case .medium:   return .orangeNormal
            case .strong:   return .greenNormal
        }
    }

    public init(passwordStrength: PasswordStrengthIndicator.PasswordStrength) {
        self.passwordStrength = passwordStrength
    }
}

// MARK: - Types
public extension PasswordStrengthIndicator {

    enum PasswordStrength: Equatable {
        case empty
        case weak(title: String)
        case medium(title: String)
        case strong(title: String)
    }
}

// MARK: - Identifiers
public extension AccessibilityID {

    static let passwordStrengthIndicator    = Self(rawValue: "orbit.passwordstrengthindicator")
}

// MARK: - Previews
struct PasswordStrengthIndicatorPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            PasswordStrengthIndicator(passwordStrength: .empty)
            PasswordStrengthIndicator(passwordStrength: .weak(title: "Weak"))
            PasswordStrengthIndicator(passwordStrength: .medium(title: "Medium"))
            PasswordStrengthIndicator(passwordStrength: .strong(title: "Strong"))
        }
        .previewLayout(.sizeThatFits)
        .padding()

        StateWrapper(PasswordStrengthIndicator.PasswordStrength.weak(title: "weak")) { strength in
            VStack {
                PasswordStrengthIndicator(passwordStrength: strength.wrappedValue)

                HStack {
                    Button("weak", style: .critical) {
                        strength.wrappedValue = .weak(title: "Weak")
                    }
                    Button("medium", style: .status(.warning, subtle: false)) {
                        strength.wrappedValue = .medium(title: "Medium")
                    }
                    Button("strong", style: .status(.success, subtle: false)) {
                        strength.wrappedValue = .strong(title: "Strong")
                    }
                }
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
