import SwiftUI
import CoreGraphics
import Lottie

public struct LottieAnimation: UIViewRepresentable {

    private let name: String
    private let loopMode: LottieLoopMode
    private let startTime: CGFloat
    private let contentMode: UIView.ContentMode

    public init(
        _ name: String,
        loopMode: LottieLoopMode = .playOnce,
        startTime: CGFloat = 0,
        contentMode: UIView.ContentMode = .scaleAspectFit
    ) {
        self.name = name
        self.loopMode = loopMode
        self.startTime = startTime
        self.contentMode = contentMode
    }

    public func makeUIView(context _: UIViewRepresentableContext<LottieAnimation>) -> UIView {
        let view = UIView()

        let animationView = AnimationView()
        animationView.animation = Animation.named(name, bundle: .current)
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])

        animationView.play(fromProgress: startTime, toProgress: 1, loopMode: loopMode)
        return view
    }

    public func updateUIView(_: UIView, context _: UIViewRepresentableContext<LottieAnimation>) {
        // No implementation
    }
}

struct LottieAnimationPreviews: PreviewProvider {

    public static var previews: some View {
        LottieAnimation("Airport", loopMode: .loop, startTime: 0.15, contentMode: .scaleAspectFit)
            .aspectRatio(contentMode: .fit)
            .previewLayout(.sizeThatFits)
    }
}
