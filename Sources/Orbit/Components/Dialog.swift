import SwiftUI

/// Orbit component that prompts user to complete an action. 
/// A counterpart of the native `alert()` modifier.
///
/// A ``Dialog`` consists of a title, description, illustration, at most three buttons and an optional custom content.
///
/// ```swift
/// Dialog("Title") {
///     // Content
/// } buttons: {
///     Button("Primary") { /* Tap action */ }
///     Button("Secondary") { /* Tap action */ }
///     Button("Tertiary") { /* Tap action */ }
/// } illustration: {
///     Illustration(.accommodation)
/// }
/// ```
/// 
/// ### Customizing appearance
/// 
/// A ``Status`` of buttons can be modified by ``status(_:)`` modifier:
///
/// ```swift
/// Dialog("Title") {
///     Button("Primary") { /* Tap action */ }
///     Button("Secondary") { /* Tap action */ }
/// }
/// .status(.critical)
/// ```
///
/// The default button priority can be overridden by ``buttonPriority(_:)`` modifier:
///
/// ```swift
/// Dialog("Title") {
///     Button("Secondary Only") {
///         // Tap action 
///     }
///     .buttonPriority(.secondary)
/// }
/// ```
///
/// ### Layout
///
/// The component expands in both axis and is meant to be used as a fullscreen modal overlay.
///
/// - Note: [Orbit.kiwi documentation](https://orbit.kiwi/components/overlay/dialog/)
public struct Dialog<Content: View, Buttons: View, Illustration: View>: View {

    private let title: String
    private let description: String
    @ViewBuilder private let content: Content
    @ViewBuilder private let buttons: Buttons
    @ViewBuilder private let illustration: Illustration

    public var body: some View {
        VStack(alignment: .leading, spacing: .medium) {
            illustration
                .padding(.top, .xSmall)

            texts

            if content.isEmpty == false {
                content
            }

            if buttons.isEmpty == false {
                VStack(spacing: .xSmall) {
                    buttons
                }
            }
        }
        .frame(maxWidth: Layout.readableMaxWidth / 2)
        .padding(.medium)
        .background(Color.whiteDarker)
        .clipShape(shape)
        .elevation(.level4, shape: .roundedRectangle(borderRadius: .small))
        .padding(.xLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.overlay.edgesIgnoringSafeArea(.all))
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder private var texts: some View {
        if title.isEmpty == false || description.isEmpty == false {
            VStack(alignment: .leading, spacing: .xSmall) {
                Heading(title, style: .title4)
                    .accessibility(.dialogTitle)

                Text(description)
                    .textColor(.inkNormal)
                    .accessibility(.dialogDescription)
            }
        }
    }

    private var shape: some InsettableShape {
        RoundedRectangle(cornerRadius: .small)
    }
}

// MARK: - Inits
extension Dialog {

    /// Creates Orbit ``Dialog`` component.
    public init(
        _ title: String = "",
        description: String = "",
        @ViewBuilder content: () -> Content = { EmptyView() },
        @ButtonStackBuilder buttons: () -> Buttons,
        @ViewBuilder illustration: () -> Illustration = { EmptyView() }
    ) {
        self.init(title: title, description: description) {
            content()
        } buttons: {
            buttons()
        } illustration: {
            illustration()
        }
    }
}

// MARK: - Identifiers
public extension AccessibilityID {
    static let dialogTitle              = Self(rawValue: "orbit.dialog.title")
    static let dialogDescription        = Self(rawValue: "orbit.dialog.description")
}

// MARK: - Previews
struct DialogPreviews: PreviewProvider {

    static let title1 = "Kiwi.com would like to send you notifications."
    static let title2 = "Do you really want to delete your account?"

    static let description1 = "Notifications may include alerts, sounds, and icon badges."
        + "These can be configured in <applink1>Settings</applink1>"
    static let description2 = "This action is irreversible, once you delete your account, it's gone."
        + " It will not affect any bookings in progress."
    
    static var previews: some View {
        PreviewWrapper {
            content
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        standalone
        critical
        titleOnly
        descriptionOnly
    }

    static var standalone: some View {
        Dialog(title1, description: description1) {
            contentPlaceholder
        } buttons: {
            Button("Main CTA") {}
            Button("Secondary") {}
            Button("Tertiary") {}
        } illustration: {
            illustrationPlaceholder
        }
        .previewDisplayName()
    }

    static var critical: some View {
        Dialog(title2, description: description2) {
            Button("Main CTA") {}
            Button("Secondary") {}
            Button("Tertiary") {}
        } illustration: {
            illustrationPlaceholder
        }
        .status(.critical)
        .previewDisplayName()
    }

    static var titleOnly: some View {
        Dialog(title1) {
            Button("Main CTA") {}
            Button("Secondary") {}
        }
        .previewDisplayName()
    }

    static var descriptionOnly: some View {
        Dialog(description: description1) {
            Button("Main CTA") {}
        }
        .previewDisplayName()
    }

    static var snapshot: some View {
        standalone
            .background(Color.whiteNormal)
    }
}
