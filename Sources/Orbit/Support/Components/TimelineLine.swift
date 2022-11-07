import SwiftUI

struct TimelineLine: View {
    var height: CGFloat
    var startPointType: TimelineItemType
    var endPointType: TimelineItemType

    var body: some View {
        coloredLine
            .frame(width: 2, height: height)
    }

    @ViewBuilder var coloredLine: some View {
        if endPointType.isLineDashed {
            linePath
                .fill(endPointType.color)
        } else {
            linePath
                .fill(LinearGradient(
                    colors: [startPointType.color, endPointType.color],
                    startPoint: .top,
                    endPoint: .bottom
                ))
        }
    }

    var linePath: some Shape {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
        }
        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: endPointType.isLineDashed ? [3, 5] : []))
    }
}
