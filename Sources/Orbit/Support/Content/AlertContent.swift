import SwiftUI

struct AlertContent<Title: View, Description: View, Icon: View, Buttons: View>: View {

    @Environment(\.iconColor) private var iconColor
    @Environment(\.idealSize) private var idealSize
    @Environment(\.isSubtle) private var isSubtle
    @Environment(\.status) private var status
    @Environment(\.textColor) private var textColor
    @Environment(\.textLinkColor) private var textLinkColor

    let isInline: Bool
    @ViewBuilder let buttons: Buttons
    @ViewBuilder let title: Title
    @ViewBuilder let description: Description
    @ViewBuilder let icon: Icon

    var body: some View {
        variantContent
            .background(background)
            .cornerRadius(BorderRadius.default)
            .accessibilityElement(children: .contain)
            .accessibility(.alert)
    }

    @ViewBuilder var variantContent: some View {
        if isInline {
            inlineContent
        } else {
            defaultContent
        }
    }

    @ViewBuilder var defaultContent: some View {
        HStack(alignment: .top, spacing: .xSmall) {
            iconContent

            VStack(alignment: .leading, spacing: .small) {
                defaultHeader
                buttons
            }
        }
        .frame(maxWidth: idealSize.horizontal == true ? nil : .infinity, alignment: .leading)
        .padding(.small)
    }

    @ViewBuilder var inlineContent: some View {
        HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
            inlineHeader

            if idealSize.horizontal != true {
                Spacer(minLength: 0)
            }

            buttons
        }
    }

    @ViewBuilder var defaultHeader: some View {
        if title.isEmpty == false || description.isEmpty == false {
            VStack(alignment: .leading, spacing: .xxSmall) {
                titleContent
                
                description
                    .textLinkColor(textLinkColor ?? textColor.map { TextLink.Color.custom($0) } ?? .secondary)
                    .accessibility(.alertDescription)
            }
        }
    }

    @ViewBuilder var inlineHeader: some View {
        if icon.isEmpty == false || title.isEmpty == false {
            HStack(alignment: .top, spacing: .xSmall) {
                iconContent
                titleContent
            }
            .padding(.vertical, 14)
            .padding(.horizontal, .small)
        }
    }

    @ViewBuilder var iconContent: some View {
        icon
            .font(.system(size: Orbit.Icon.Size.normal.value))
            .foregroundColor(iconColor ?? outlineColor)
            .iconColor(iconColor ?? outlineColor)
            .accessibility(.alertIcon)
    }

    @ViewBuilder var titleContent: some View {
        title
            .textFontWeight(.bold)
            .accessibility(.alertTitle)
    }

    @ViewBuilder var background: some View {
        backgroundColor
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.default)
                    .strokeBorder(strokeColor, lineWidth: 1)
            )
            .overlay(
                outlineColor
                    .frame(height: 3),
                alignment: .top
            )
    }

    var outlineColor: Color {
        defaultStatus.color
    }

    var backgroundColor: Color {
        isSubtle ? .cloudLight : defaultStatus.lightColor
    }

    var strokeColor: Color {
        isSubtle ? .cloudLightHover : defaultStatus.lightHoverColor
    }

    var defaultStatus: Status {
        status ?? .info
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let alert           = Self(rawValue: "orbit.alert")
    static let alertTitle           = Self(rawValue: "orbit.alert.title")
    static let alertIcon            = Self(rawValue: "orbit.alert.icon")
    static let alertDescription     = Self(rawValue: "orbit.alert.description")
}

struct AlertContentPreviews: PreviewProvider {

    static let title = "Title"
    static let description = """
        The main description message of this Alert component should be placed here. If you need to use TextLink \
        in this component, please do it by using <a href="..">Normal Underline text style</a>.

        Description message can be <strong>formatted</strong>, but if more <ref>customizaton</ref> is needed a custom \
        description content can be provided instead.
        """

    static var previews: some View {
        PreviewWrapper {
            content
            inline
        }
        .padding(.medium)
    }

    static var content: some View {
        VStack(spacing: .medium) {
            AlertContent(isInline: false) {
                HStack(spacing: .xSmall) {
                    Button("Primary") {}
                        .suppressButtonStyle()
                        .buttonStyle(AlertButtonStyle())
                    
                    Button("Secondary") {}
                        .suppressButtonStyle()
                        .buttonStyle(AlertButtonStyle())
                        .buttonPriority(.secondary)
                }
            } title: {
                Text(title)
            } description: {
                VStack(alignment: .leading, spacing: .small) {
                    Text(description)
                    contentPlaceholder
                }
            } icon: {
                Icon(.informationCircle)
            }
            
            AlertContent(isInline: false) {
                EmptyView()
            } title: {
                Text(title)
            } description: {
                contentPlaceholder
            } icon: {
                EmptyView()
            }
            
            AlertContent(isInline: false) {
                EmptyView()
            } title: {
                EmptyView()
            } description: {
                contentPlaceholder
            } icon: {
                EmptyView()
            }
        }
        .previewDisplayName()
    }

    static var inline: some View {
        AlertContent(isInline: true) {
            Button("Primary") {}
                .suppressButtonStyle()
                .buttonStyle(AlertInlineButtonStyle())
                .padding(.trailing, .small)
        } title: {
            Text(title)
        } description: {
            VStack(alignment: .leading, spacing: .medium) {
                Text(description)
                contentPlaceholder
            }
        } icon: {
            Icon(.informationCircle)
        }
        .previewDisplayName()
    }
}
