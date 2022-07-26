import SwiftUI

struct TutorialScreen: View {

    var primaryAction = {}
    var alertAction = {}
    var secondaryAction = {}
    
    var body: some View {
        VStack(spacing: .large) {
            Card("Card Title", action: .buttonLink("Edit")) {
                List {
                    ListItem("List Item 1", icon: .check, style: .custom(color: .greenNormal))
                    ListItem("List Item 2 with a <a href=\"...\">TextLink</a>", icon: .check)
                    ListItem("List Item 3")
                }
                
                Alert(
                    "Alert",
                    description: "Alert Desctiption with a <a href=\"...\">TextLink</a>",
                    buttons: .primary(.init("Action", action: alertAction))
                )
                
                HStack(spacing: .medium) {
                    Button("Secondary Button", style: .secondary, action: secondaryAction)
                    Button(.creditCard, style: .status(.warning))
                }
            }
            
            VStack(alignment: .leading, spacing: .medium) {
                Text("""
                    Multi-line very long text containing <a href="...">TextLink</a> \
                    and <a href="...">Some other TextLink</a>"
                    """
                )
                
                Badge("Badge", style: .status(.info, inverted: true))
                
                Button("Primary Button", action: primaryAction)
            }
            .padding(.horizontal, .medium)
        }
        .padding(.vertical, .medium)
        .background(Color.screen)
    }
}

struct TutorialScreenPreviews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper {
            TutorialScreen()
        }
        .previewLayout(.sizeThatFits)
    }
}
