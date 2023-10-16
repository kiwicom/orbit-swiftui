import SwiftUI

struct AlertContent<Content: View, Icon: View, Buttons: View>: View {

    @Environment(\.iconColor) private var iconColor
    @Environment(\.idealSize) private var idealSize
    @Environment(\.isSubtle) private var isSubtle
    @Environment(\.status) private var status
    @Environment(\.textColor) private var textColor
    @Environment(\.textLinkColor) private var textLinkColor

    let title: String
    var description: String = ""
    let isInline: Bool
    @ViewBuilder let content: Content
    @ViewBuilder let icon: Icon
    @ViewBuilder let buttons: Buttons

    var body: some View {
        variantContent
            .background(background)
            .cornerRadius(BorderRadius.default)
            .accessibilityElement(children: .contain)
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

            VStack(alignment: .leading, spacing: .medium) {
                defaultHeader
                content
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
                Text(description)
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
        Text(title)
            .bold()
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
        AlertContent(title: title, description: description, isInline: false) {
            contentPlaceholder
        } icon: {
            Icon(.informationCircle)
        } buttons: {
            HStack(spacing: .xSmall) {
                Button("Primary") {}
                    .suppressButtonStyle()
                    .buttonStyle(AlertButtonStyle())

                Button("Secondary") {}
                    .suppressButtonStyle()
                    .buttonStyle(AlertButtonStyle())
                    .buttonPriority(.secondary)
            }
        }
        .previewDisplayName()
    }

    static var inline: some View {
        AlertContent(title: title, description: description, isInline: true) {
            contentPlaceholder
        } icon: {
            Icon(.informationCircle)
        } buttons: {
            Button("Primary") {}
                .suppressButtonStyle()
                .buttonStyle(AlertInlineButtonStyle())
                .padding(.trailing, .small)
        }
        .previewDisplayName()
    }
}
