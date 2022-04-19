import SwiftUI

public struct Progress: View {

    public static let height: CGFloat = 5
    public let progress: CGFloat

    public var body: some View {
        Capsule()
            .frame(height: Self.height)
            .foregroundColor(Color.cloudDark)
            .overlay(
                GeometryReader { geometry in
                    Capsule()
                        .foregroundColor(Color.productNormalActive)
                        .padding(.trailing, geometry.size.width * (1 - max(min(1, progress), 0)))
                        .animation(.easeOut, value: progress)
                },
                alignment: .leading
            )
    }

    public init(_ progress: CGFloat) {
        self.progress = progress
    }
}

// MARK: - Previews
struct ProgressPreviews: PreviewProvider {

    public static var previews: some View {
        PreviewWrapper {
            VStack(spacing: .large) {
                Progress(-3)
                Progress(0)
                Progress(0.1)
                Progress(0.5)
                Progress(1)
                Progress(3)
            }
            .previewDisplayName("Progress")

            StateWrapper(initialState: CGFloat(0)) { progress in
                VStack(spacing: .large) {
                    Progress(progress.wrappedValue)
                    Button("Change") {
                        progress.wrappedValue += 0.25

                        if progress.wrappedValue > 1 {
                            progress.wrappedValue = 0
                        }
                    }
                }
                .previewDisplayName("Live Preview")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
