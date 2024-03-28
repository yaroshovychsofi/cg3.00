
import SwiftUI

struct KochSnowflake: Shape {
    var level: Int = 3
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let height = rect.height - rect.height / 4
        let width = rect.width
        
        let xStart = width / 2 - height / 2
        drawSnow(&path, level: level, x1: xStart + 20, y1: height - 20, x5: xStart + height - 20, y5: height - 20)
        drawSnow(&path, level: level, x1: xStart + height - 20, y1: height - 20, x5: xStart + height / 2, y5: 20)
        drawSnow(&path, level: level, x1: xStart + height / 2, y1: 20, x5: xStart + 20, y5: height - 20)
        
        return path
    }
    
    private func drawSnow(_ path: inout Path, level lev: Int, x1: CGFloat, y1: CGFloat, x5: CGFloat, y5: CGFloat) {
        let deltaX = x5 - x1
        let deltaY = y5 - y1
        
        if lev == 0 {
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x5, y: y5))
        } else {
            let x2 = x1 + deltaX / 3
            let y2 = y1 + deltaY / 3
            
            let x3 = 0.5 * (x1 + x5) + CGFloat(sqrt(3)) * (y1 - y5) / 6
            let y3 = 0.5 * (y1 + y5) + CGFloat(sqrt(3)) * (x5 - x1) / 6
            
            let x4 = x1 + 2 * deltaX / 3
            let y4 = y1 + 2 * deltaY / 3
            
            drawSnow(&path, level: lev-1, x1: x1, y1: y1, x5: x2, y5: y2)
            drawSnow(&path, level: lev-1, x1: x2, y1: y2, x5: x3, y5: y3)
            drawSnow(&path, level: lev-1, x1: x3, y1: y3, x5: x4, y5: y4)
            drawSnow(&path, level: lev-1, x1: x4, y1: y4, x5: x5, y5: y5)
        }
    }
}
struct FractalView: View {
    var body: some View {
        KochSnowflake(level: 3)
            .stroke(Color.blue, lineWidth: 1)
            .padding()
            .aspectRatio(1, contentMode: .fit)
    }
}

struct FractalView_Previews: PreviewProvider {
    static var previews: some View {
        FractalView()
    }
}
