
import CoreGraphics
import Foundation

func calculateFractalSides(baseSides: [Side], depth:Int) -> [Side]{
    var newSides: [Side] = []
    for side in baseSides {
        newSides.append(side)
    }
    for index in 0..<newSides.count {
        RecursiveFractal(side: newSides[index], depth: depth, newSides: &newSides)
    }
//    print("\(newSides)")
    return newSides

}


func findMainTriangleSides(middlePoint: CGPoint, triangleHeight: CGFloat) -> [Side] {
        let offset = (triangleHeight / sqrt(3)) * 2

        let startPoint = CGPoint(x: middlePoint.x, y: middlePoint.y - (triangleHeight / 2))
        let leftPoint = CGPoint(x: middlePoint.x - (offset / 2), y: middlePoint.y + (triangleHeight / 2))
        let rightPoint = CGPoint(x: middlePoint.x + (offset / 2), y: middlePoint.y + (triangleHeight / 2))

        let side1 = Side(startPoint: startPoint, endPoint: leftPoint, angle: 120, isMainTriangleSide: true)
        let side2 = Side(startPoint: leftPoint, endPoint: rightPoint, angle: 180, isMainTriangleSide: true)
        let side3 = Side(startPoint: rightPoint, endPoint: startPoint, angle: 60, isMainTriangleSide: true)

        return [side1, side2, side3]
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


