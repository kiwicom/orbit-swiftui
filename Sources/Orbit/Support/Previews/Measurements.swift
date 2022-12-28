import SwiftUI

struct Measurement: View {

    static let width: CGFloat = .large

    @State private var size: CGFloat = 0

    var body: some View {
        ContentHeightReader(height: $size) {
            Color.clear
        }
        .overlay(label, alignment: .trailing)
    }

    var label: some View {
        HStack(spacing: .xxxSmall) {
            Color.red
                .frame(width: 1)

            Text("\(size.formatted)", size: .custom(8), color: .custom(.redNormal))
                .environment(\.sizeCategory, .large)

        }
        .frame(width: Self.width, alignment: .leading)
    }
}

extension View {

    func measured() -> some View {
        self
            .padding(.trailing, Measurement.width + .xSmall)
            .overlay(Measurement())
    }
}
