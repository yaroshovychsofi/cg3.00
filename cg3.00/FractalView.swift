
//import SwiftUI

//struct KochSnowflake: Shape {
//    var level: Int = 3
//    
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        
//        let height = rect.height - rect.height / 4
//        let width = rect.width
//        
//        let xStart = width / 2 - height / 2
//        drawSnow(&path, level: level, x1: xStart + 20, y1: height - 20, x5: xStart + height - 20, y5: height - 20)
//        drawSnow(&path, level: level, x1: xStart + height - 20, y1: height - 20, x5: xStart + height / 2, y5: 20)
//        drawSnow(&path, level: level, x1: xStart + height / 2, y1: 20, x5: xStart + 20, y5: height - 20)
//        
//        return path
//    }
//    
//    private func drawSnow(_ path: inout Path, level lev: Int, x1: CGFloat, y1: CGFloat, x5: CGFloat, y5: CGFloat) {
//        let deltaX = x5 - x1
//        let deltaY = y5 - y1
//        
//        if lev == 0 {
//            path.move(to: CGPoint(x: x1, y: y1))
//            path.addLine(to: CGPoint(x: x5, y: y5))
//        } else {
//            let x2 = x1 + deltaX / 3
//            let y2 = y1 + deltaY / 3
//            
//            let x3 = 0.5 * (x1 + x5) + CGFloat(sqrt(3)) * (y1 - y5) / 6
//            let y3 = 0.5 * (y1 + y5) + CGFloat(sqrt(3)) * (x5 - x1) / 6
//            
//            let x4 = x1 + 2 * deltaX / 3
//            let y4 = y1 + 2 * deltaY / 3
//            
//            drawSnow(&path, level: lev-1, x1: x1, y1: y1, x5: x2, y5: y2)
//            drawSnow(&path, level: lev-1, x1: x2, y1: y2, x5: x3, y5: y3)
//            drawSnow(&path, level: lev-1, x1: x3, y1: y3, x5: x4, y5: y4)
//            drawSnow(&path, level: lev-1, x1: x4, y1: y4, x5: x5, y5: y5)
//        }
//    }
//}
//struct FractalView: View {
//    var body: some View {
//        KochSnowflake(level: 3)
//            .stroke(Color.blue, lineWidth: 1)
//            .padding()
//            .aspectRatio(1, contentMode: .fit)
//    }
//}
//
//struct FractalView_Previews: PreviewProvider {
//    static var previews: some View {
//        FractalView()
//    }
//}
import SwiftUI

struct TriangleView: View {
    
    @State  var sides = [Side]()
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            let middlePoint = CGPoint(x: width / 2, y: height / 2)
            let triangleHeight = min(width, height) * 0.5
            let offset = (triangleHeight / sqrt(3)) * 2
            
            let startPoint = CGPoint(x: middlePoint.x, y: middlePoint.y - (triangleHeight / 2))
            let leftPoint = CGPoint(x: middlePoint.x - (offset / 2), y: middlePoint.y + (triangleHeight / 2))
            let rightPoint = CGPoint(x: middlePoint.x + (offset / 2), y: middlePoint.y + (triangleHeight / 2))
            
            VStack(spacing: 10) {
                ZStack{
                    ForEach(sides, id: \.self) { side in
                        Path { path in
                            path.move(to: side.startPoint)
                            path.addLine(to: side.endPoint)
                        }
                        .stroke(Color.black, lineWidth: 3)
                        
                    }
                    Button("Обчислити фрактал") {
                        var side1 = Side(startPoint: startPoint, endPoint: leftPoint, angle: 120, isMainTriangleSide: true)
                        var side2 = Side(startPoint: leftPoint, endPoint: rightPoint, angle: 180, isMainTriangleSide: true)
                        var side3 = Side(startPoint: rightPoint, endPoint: startPoint, angle: 60, isMainTriangleSide: true)
                        sides = calculateFractalSides(side1: side1, side2: side2, side3: side3)
                        print("\(sides)")
                        
                        
                    }
                }
            }
            .background(Color.purple.opacity(0.7))
        }
        .frame(height: 900)
    }
    func calculateFractalSides(side1: Side, side2: Side, side3: Side) -> [Side]{
        var newSides: [Side] = []
        newSides.append(side1)
        newSides.append(side2)
        newSides.append(side3)
        for index in 0..<newSides.count {
           RecursiveFractal(side: newSides[index], depth: 4, newSides: &newSides)
        }
        return newSides
        
    }
}
    
    
    
    
    


struct TriangleView_Previews: PreviewProvider {
    static var previews: some View {
        TriangleView()
    }
}

extension Side {
    static func == (lhs: Side, rhs: Side) -> Bool {
        return lhs.startPoint == rhs.startPoint && lhs.endPoint == rhs.endPoint && lhs.angle == rhs.angle
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(startPoint.x)
        hasher.combine(startPoint.y)
        hasher.combine(endPoint.x)
        hasher.combine(endPoint.y)
        hasher.combine(angle)
    }
}

struct Side: Hashable {
    var startPoint: CGPoint
    var endPoint: CGPoint
    var angle: CGFloat
    var isMainTriangleSide: Bool
    var length: CGFloat {
            return sqrt(pow(endPoint.x - startPoint.x, 2) + pow(endPoint.y - startPoint.y, 2))
        }
    init(startPoint: CGPoint, endPoint: CGPoint, angle: CGFloat , isMainTriangleSide: Bool) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.angle = angle
        self.isMainTriangleSide = isMainTriangleSide
    }
}

func findMidpoint(ofSide side: Side) -> CGPoint {
    let midpointX = (side.startPoint.x + side.endPoint.x) / 2
    let midpointY = (side.startPoint.y + side.endPoint.y) / 2
    return CGPoint(x: midpointX, y: midpointY)
}

func calculateNewAngles(forAngle angle: CGFloat) -> (CGFloat, CGFloat) {
    
    switch angle {
    case 180:
        return (60, 120)
    case 0:
        return (60, 120)
    case 60:
        return (300, 0)
    case 240:
        return (300, 0)
    case 120:
        return (240, 180)
    case 300:
        return (240, 180)
        
    default:
        return (0, 180)
    }
}

func calculateAddAngles(forAngle angle: CGFloat) -> (CGFloat, CGFloat) {
    
    switch angle {
    case 180:
        return (240, 300)
    case 0:
        return (240, 300)
    case 60:
        return (180, 120)
    case 240:
        return (180, 120)
    case 120:
        return (0, 60)
    case 300:
        return (0, 60)
    default:
        return (0, 180)
    }
}



func RecursiveFractal(side: Side, depth: Int, newSides: inout [Side]) {
    guard depth >= 0 else { return }
    
    let middleOfSide = findMidpoint(ofSide: side)
    let lengthOfSmallerSides = side.length / 5
    let anglesOfSides = calculateNewAngles(forAngle: side.angle)
    
    
    let endPoints = findLastPoints(angles: anglesOfSides, firstPoint: middleOfSide, newSideLength: lengthOfSmallerSides)
    
    // Створення нових сторін
    let side1 = Side(startPoint: side.startPoint, endPoint: middleOfSide, angle: side.angle, isMainTriangleSide: side.isMainTriangleSide)
    let side2 = Side(startPoint: middleOfSide, endPoint: side.endPoint, angle: side.angle, isMainTriangleSide: side.isMainTriangleSide)
    //сторони від серединки
    let newSide1 = Side(startPoint: middleOfSide, endPoint: endPoints.0, angle: anglesOfSides.0, isMainTriangleSide: false)
    let newSide2 = Side(startPoint: middleOfSide, endPoint: endPoints.1, angle: anglesOfSides.1, isMainTriangleSide: false)
    
    
    
    // рекурсивний виклик
    newSides.append(newSide1)
    newSides.append(newSide2)
    RecursiveFractal(side: side1, depth: depth - 1, newSides: &newSides)
    RecursiveFractal(side: side2, depth: depth - 1, newSides: &newSides)
    RecursiveFractal(side: newSide1, depth: depth - 1, newSides: &newSides)
    RecursiveFractal(side: newSide2, depth: depth - 1, newSides: &newSides)
    
    
    if !side.isMainTriangleSide{
        let addAngles = calculateAddAngles(forAngle: side.angle)
        let endPoints2 = findLastPoints(angles: addAngles, firstPoint: middleOfSide, newSideLength: lengthOfSmallerSides)
        
        let newSide3 = Side(startPoint: middleOfSide, endPoint: endPoints2.0, angle: addAngles.0, isMainTriangleSide: false)
        let newSide4 = Side(startPoint: middleOfSide, endPoint: endPoints2.1, angle: addAngles.1, isMainTriangleSide: false)
        newSides.append(newSide3)
        newSides.append(newSide4)
        RecursiveFractal(side: newSide3, depth: depth - 1, newSides: &newSides)
        RecursiveFractal(side: newSide4, depth: depth - 1, newSides: &newSides)
    }
}
    
    
    



func findLastPoints(angles: (CGFloat, CGFloat), firstPoint: CGPoint, newSideLength: CGFloat) -> (CGPoint, CGPoint) {
    let (angle1, angle2) = angles
    
    let angle1Radians = angle1 * .pi / 180
    let angle2Radians = angle2 * .pi / 180
    
    let firstEndPoint = CGPoint(
        x: firstPoint.x + newSideLength * cos(angle1Radians),
        y: firstPoint.y + newSideLength * sin(angle1Radians)
    )
    
    let secondEndPoint = CGPoint(
        x: firstPoint.x + newSideLength * cos(angle2Radians),
        y: firstPoint.y + newSideLength * sin(angle2Radians)
    )
    
    return (firstEndPoint, secondEndPoint)
}


