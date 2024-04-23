

import SwiftUI

struct IceFractalView: View {
    @State var sides = [Side]()
    @State var depth = 4
    @State private var scale: Double = 10 // Використання значення масштабування
    
    var body: some View {
        VStack {
            
            Text("Глибина фракталу")
            TextField("Введіть глибину фрактала", value: $depth, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.default)
            
            // Слайдер для контролю масштабування
            Slider(value: $scale, in: 0...100, step: 1)
            Text("Масштаб: \(scale, specifier: "%.0f")%")
            
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                
                let middlePoint = CGPoint(x: width / 2, y: height / 2)
                let triangleHeight = min(width, height) * 0.7
                
                VStack{
                    VStack(alignment:.center){
                        ZStack() {
                            ForEach(sides, id: \.self) { side in
                                Path { path in
                                    path.move(to: side.startPoint)
                                    path.addLine(to: side.endPoint)
                                }
                                .stroke(Color.black, lineWidth: 1)
                                .scaleEffect(scale / 10)
                            }
                        }
                    }
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .shadow(radius: 10)
                    
                    Button("Обчислити фрактал") {
                        let mainSides = findMainTriangleSides(middlePoint: middlePoint, triangleHeight: triangleHeight)
                        sides = calculateFractalSides(baseSides: mainSides, depth: depth)
                        
                        print("\(sides)")
                    }
                }
                .cornerRadius(10)
            }
            .cornerRadius(3.0)
            .frame(width: 350, height: 400)
            .padding()
            .background(Color.purple.opacity(0.7))
            
            Spacer()
        }
    }
}


#Preview {
    IceFractalView()
}
