import SwiftUI

struct Measurements: View {

    static let width: CGFloat = .small

    @State private var size: CGFloat = 0

    var body: some View {
        ContentHeightReader(height: $size) {
            Color.clear
        }
        .overlay(label, alignment: .trailing)
    }

    var label: some View {
        HStack(spacing: .xxxSmall) {
            Color.redNormal
                .frame(width: 1)

            Text("\(size.formatted)", size: .custom(6), color: .custom(.redNormal))
                .lineLimit(1)
                .environment(\.sizeCategory, .large)

        }
        .fixedSize(horizontal: true, vertical: false)
        .frame(width: Self.width, alignment: .leading)
    }
}

extension View {

    func measured() -> some View {
        self
            .padding(.trailing, Measurements.width + .xxxSmall)
            .overlay(Measurements())
    }
}

// MARK: - Previews
struct MeasurementsPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            vertical
        }
        .padding(.medium)
        .previewLayout(PreviewLayout.sizeThatFits)
    }

    static var vertical: some View {
        VStack {
            Color.blueNormal
                .frame(height: 31.54321)

            Color.blueNormal
                .frame(height: 31.54321)
                .measured()

            Select("", value: nil)
                .measured()
        }
        .previewDisplayName()
    }
}

