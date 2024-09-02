import SwiftUI

/// Orbit image related to a social service.
public struct SocialButtonIcon: View {
    
    private let service: SocialButtonService
    
    public var body: some View {
        switch service {
            case .apple:
                Image(.apple)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(.whiteNormal)
                    .padding(1)
            case .google:
                Image(.google)
                    .resizable()
            case .facebook:
                Image(.facebook)
                    .resizable()
            case .email:        
                Icon(.email).iconSize(.large)
        }
    }
    
    /// Creates Orbit ``SocialButtonIcon`` image.
    public init(_ service: SocialButtonService) {
        self.service = service
    }
}

// MARK: - Types

/// Orbit ``SocialButton`` social service or login method.
public enum SocialButtonService {
    case apple
    case google
    case facebook
    case email
}

// MARK: - Previews
struct SocialButtonIconPreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            standalone
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }
    
    static var standalone: some View {
        HStack(spacing: .medium) {
            SocialButtonIcon(.apple)
            SocialButtonIcon(.google)
            SocialButtonIcon(.facebook)
            SocialButtonIcon(.email)
        }
        .previewDisplayName()
    }
}
