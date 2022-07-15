import SwiftUI

public struct TimelineStepText: View {
    let text: String
    let style: TimelineStepStyle

    public var body: some View {
        Text(text, size: .normal, color: .custom(style.textColor))
            .padding(.leading, .xSmall)
    }
}
