import SwiftUI

public struct OrbitStorybookComponentsScreen: View {

    enum Component: CaseIterable {
        case alert
        case badge
        case badgeList
        case button
        case buttonLink
        case card
        case heading
        case checkbox
        case icon
        case illustration
        case inputField
        case radio
        case select
        case separator
        case socialButton
        case `switch`
        case tag
        case text
        case tile
        case tileGroup
    }

    @State var expandedComponent: Component?

    public var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: .large) {
                ForEach(Component.allCases, id: \.self) { component in
                    card(forComponent: component)
                }
            }
            .padding(.vertical, .large)
        }
        .background(Color.cloudLight)
        .navigationBarTitle("Orbit Storybook")
    }

    @ViewBuilder
    func card(forComponent component: Component) -> some View {
        Card(component.title, description: component.description, action: .buttonLink("   ")) {
            if expandedComponent == component {
                component.figmaPreview
            } else {
                component.standalonePreview
            }
        }
        .overlay(
            HStack {
                Spacer()

                Icon(.chevronRight)
                    .rotationEffect(expandedComponent == component ? .init(degrees: 90) : .zero)
                    .padding(.medium)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.2)) {
                    expandedComponent = expandedComponent == component ? nil : component
                }
            },
            alignment: .top
        )
    }

    public init() {}
}

extension OrbitStorybookComponentsScreen.Component {

    @ViewBuilder
    var standalonePreview: some View {
        switch self {
            case .alert:            AlertPreviews.standalone
            case .badge:            BadgePreviews.standalone
            case .badgeList:        BadgeListPreviews.standalone
            case .button:           ButtonPreviews.standalone
            case .buttonLink:       ButtonLinkPreviews.standalone
            case .card:             CardPreviews.standalone.padding(.horizontal, -.medium)
            case .heading:          HeadingPreviews.standalone
            case .checkbox:         CheckboxPreviews.standalone
            case .icon:             IconPreviews.standalone
            case .illustration:     IllustrationPreviews.standalone
            case .inputField:       InputFieldPreviews.standalone
            case .radio:            RadioPreviews.standalone
            case .select:           SelectPreviews.standalone
            case .separator:        SeparatorPreviews.standalone
            case .socialButton:     SocialButtonPreviews.standalone
            case .switch:           SwitchPreviews.standalone
            case .tag:              TagPreviews.standalone
            case .text:             TextPreviews.standalone
            case .tile:             TilePreviews.standalone.padding(.horizontal, -.medium)
            case .tileGroup:        TileGroupPreviews.standalone
        }
    }

    @ViewBuilder
    var figmaPreview: some View {
        switch self {
            case .alert:            AlertPreviews.orbit
            case .badge:            BadgePreviews.orbit
            case .badgeList:        BadgeListPreviews.orbit
            case .button:           ButtonPreviews.orbit
            case .buttonLink:       ButtonLinkPreviews.orbit
            case .card:             CardPreviews.orbit.padding(.horizontal, -.medium)
            case .heading:          HeadingPreviews.orbit
            case .checkbox:         CheckboxPreviews.orbit
            case .icon:             IconPreviews.orbit
            case .illustration:     IllustrationPreviews.orbit
            case .inputField:       InputFieldPreviews.orbit
            case .radio:            RadioPreviews.orbit
            case .select:           SelectPreviews.orbit
            case .separator:        SeparatorPreviews.orbit
            case .socialButton:     SocialButtonPreviews.orbit
            case .switch:           SwitchPreviews.orbit
            case .tag:              TagPreviews.orbit
            case .text:             TextPreviews.figma
            case .tile:             TilePreviews.figma.padding(.horizontal, -.medium)
            case .tileGroup:        TileGroupPreviews.figma.padding(.horizontal, -.medium)
        }
    }

    var name: String {
        String(describing: self)
    }

    var title: String {
        name.prefix(1).capitalized + name.dropFirst()
    }

    var description: String {
        switch self {
            case .alert:            return "Breaks the main user flow to present information."
            case .badge:            return "Presents users with short, relevant information."
            case .badgeList:        return "Presents a list of short details with added visual information."
            case .button:           return "Displays a single important action a user can take."
            case .buttonLink:       return "Displays a single, less important action a user can take."
            case .card:             return "Separates content into sections."
            case .heading:          return "Shows the content hierarchy and improves the reading experience."
            case .checkbox:         return "Enables users to pick multiple options from a group."
            case .icon:             return "An icon matching Orbit name."
            case .illustration:     return "An illustration matching Orbit name."
            case .inputField:       return "Also known as textbox. Offers users a simple input for a form."
            case .radio:            return "Enables users to pick exactly one option from a group."
            case .select:           return "Also known as dropdown. Offers selection from many options."
            case .separator:        return "Separates content."
            case .socialButton:     return "Lets users sign in using a social service."
            case .switch:           return "Offers a control to toggle a setting on or off."
            case .tag:              return "Offers a label that can optionally be selected and unselected or removed."
            case .text:             return "Renders text blocks in styles to fit the purpose."
            case .tile:             return "Groups actionable content to make it easy to scan."
            case .tileGroup:        return "Wraps tiles to show related interactions."
        }
    }
}

struct OrbitStorybookComponentsScreenPreviews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper {
            OrbitStorybookComponentsScreen()
        }
    }
}
