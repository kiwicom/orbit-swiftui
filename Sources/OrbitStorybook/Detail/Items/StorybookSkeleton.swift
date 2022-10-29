import SwiftUI
import Orbit

struct StorybookSkeleton {

    static var basic: some View {
        content()
    }

    static var atomic: some View {
        contentAtomic()
    }

    static func content(animation: Skeleton.Animation = .default) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            Skeleton(.list(rows: 3), animation: animation)
            Skeleton(.image(height: 150), animation: animation)
            Skeleton(.card(height: 200), animation: animation)
            Skeleton(.button(), animation: animation)
            Skeleton(.text(lines: 4), animation: animation)
        }
    }

    static func contentAtomic(animation: Skeleton.Animation = .default) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            Skeleton(.atomic(.circle), animation: animation)
                .frame(height: 60)
            Skeleton(.atomic(.rectangle), animation: animation)
                .frame(height: 60)
            Skeleton(.atomic(.rectangle), borderRadius: 20, animation: animation)
                .frame(height: 60)
        }
    }
}

struct StorybookSkeletonPreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookSkeleton.basic
            StorybookSkeleton.atomic
        }
    }
}
