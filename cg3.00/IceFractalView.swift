

import SwiftUI

struct IceFractalView: View {
    @State var sides = [Side]()
    @State var depth = 6
    var body: some View {
        VStack {
            Spacer()
            
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                
                let middlePoint = CGPoint(x: width / 2, y: height / 2)
                let triangleHeight = min(width, height) * 0.5
                
                VStack{
                    ZStack(alignment: .center) {
                        ForEach(sides, id: \.self) { side in
                            Path { path in
                                path.move(to: side.startPoint)
                                path.addLine(to: side.endPoint)
                            }
                            .stroke(Color.black, lineWidth: 3)
                        }
                    }
                    .frame(width: width, height: height) // Встановлення розмірів рамки для центрування вмісту
                    .background(Color.purple.opacity(0.7))
                    Button("Обчислити фрактал") {
                        let mainSides = findMainTriangleSides(middlePoint: middlePoint, triangleHeight: triangleHeight)
                        sides = calculateFractalSides(baseSides: mainSides, depth: depth)
                        print("\(sides)")
                    }
                }
            }
            .frame(width: 1200, height: 00) // Явне задання розмірів для GeometryReader
            
            Spacer()
        }
    }
}


#Preview {
    IceFractalView()
}
