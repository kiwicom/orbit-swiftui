import SwiftUI
import Orbit

struct StorybookSocialButton {

    static var basic: some View {
        VStack(spacing: .medium) {
            SocialButton("Sign in with E-mail", service: .email)
            SocialButton("Sign in with Facebook", service: .facebook)
            SocialButton("Sign in with Google", service: .google)
            SocialButton("Sign in with Apple", service: .apple)
        }
    }
}

struct StorybookSocialButtonPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookSocialButton.basic
        }
    }
}
