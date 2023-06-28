import SwiftUI

public struct _ConditionalContent<TrueView: View, FalseView: View>: View {

    enum Content {
        case trueView(TrueView)
        case falseView(FalseView)
    }

    let content: Content

    public var body: some View {
        switch content {
            case .trueView(let view):   view
            case .falseView(let view):  view
        }
    }
}
