import SwiftUI

/// Defines Orbit gradient styles.
public enum Gradient {
    case orange
    case purple
    case ink
    
    @ViewBuilder public var background: some View {
        switch self {
            case .orange:               LinearGradient.orange
            case .purple:               LinearGradient.purple
            case .ink:                  LinearGradient.ink
        }
    }
    
    public var outline: Color {
        switch self {
            case .orange:               return .orangeStart
            case .purple:               return .purpleStart
            case .ink:                  return .inkStart
        }
    }
}

public extension LinearGradient {

    static let orange = LinearGradient(
        colors: [.orangeStart, .orangeEnd], startPoint: .bottomLeading, endPoint: .topTrailing
    )
    
    static let purple = LinearGradient(
        colors: [.purpleStart, .purpleEnd], startPoint: .bottomLeading, endPoint: .topTrailing
    )
    
    static let ink = LinearGradient(
        colors: [.inkStart, .inkEnd], startPoint: .bottomLeading, endPoint: .topTrailing
    )
}

public extension Color {
    
    static let orangeStart = Color(red: 0.88, green: 0.24, blue: 0.23)
    static let orangeEnd = Color(red: 0.91, green: 0.49, blue: 0.04)
    static let purpleStart = Color(red: 0.22, green: 0.1, blue: 0.67)
    static let purpleEnd = Color(red: 0.49, green: 0.22, blue: 0.86)
    static let inkStart = Color(red: 0.17, green: 0.18, blue: 0.18)
    static let inkEnd = Color(red: 0.41, green: 0.43, blue: 0.45)
}
