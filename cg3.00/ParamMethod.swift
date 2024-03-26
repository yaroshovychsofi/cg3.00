
import Foundation


func calculateBershtainPolinom(n:Int, i:Int, t: Double) -> Double {
    return Double(calculateBinominalCoef(n: n, k: i))*pow(t, Double(i))*pow(1-t, Double(n-i))
}

func calculatePointWithParam(controlPoints: [CGPoint], t: Double) -> CGPoint{
    var point = CGPoint(x: 0, y:0)
    for index in 0..<controlPoints.count{
        point.x += controlPoints[index].x*calculateBershtainPolinom(n: controlPoints.count - 1, i: index, t: t)
        point.y += controlPoints[index].y*calculateBershtainPolinom(n: controlPoints.count - 1, i: index, t: t)
    }
    return point
}

func CalculatePointsParamMethod (controlPoints: [CGPoint]) ->  [CGPoint]{
    var curvePointArray = [CGPoint]()
    for value in stride(from: 0.0, to: 1.0001, by: 0.0001){
        curvePointArray.append(calculatePointWithParam(controlPoints: controlPoints, t: value))
        
    }
    
    return curvePointArray
}
