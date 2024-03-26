import Foundation


func factorial(_ n: Int) -> Int {
    if(n < 0 ){
        return 0
    }
    if n == 0 {
        return 1
    }
    return n * factorial(n - 1)
}

func calculateVectorT(parametrT: Double, number: Int) -> [[Double]]{
    var VectorT = [[Double]]()
    VectorT.append([Double]())
    for value in stride(from: number - 1, to: 0, by: -1) {
        var result = 1.0
        for _ in 1...value {
            result *= parametrT
        }
        VectorT[0].append(result)
    }
    VectorT[0].append(1)
    return VectorT
}
func calculateBinominalCoef(n: Int, k: Int)  -> Int {
    return (factorial(n)/(factorial(k)*(factorial(n-k))))
}
func calculateBeizerMatrix(number: Int) -> [[Double]]{
    var matrix = [[Double]](repeating: [Double](repeating: 0, count: number+1), count: number+1)
    for rowIndex in 0..<matrix.count {
        for columnIndex in 0..<matrix[rowIndex].count {
            let sum = rowIndex + columnIndex
            if sum <= number {
                let binominalCoef1 = calculateBinominalCoef(n: number, k: columnIndex)
                let binominalCoef2 = calculateBinominalCoef(n: number - columnIndex, k: number - sum)
                let powResult = Int(pow(-1.0, Double(number - sum)))
                matrix[rowIndex][columnIndex] = Double(binominalCoef1 * binominalCoef2 * powResult)
            }
        }
    }
    return matrix
}
func multiplyMatrices (matrixA: [[Double]], matrixB: [[Double]]) -> [[Double]]? {
    let aRows = matrixA.count
    let aCols = matrixA[0].count
    let bRows = matrixB.count
    let bCols = matrixB[0].count
    guard aCols == bRows else {
        print("Матриці не можна перемножити через несумісні розміри.")
        return nil
    }
    var result = Array(repeating: Array(repeating: 0.0, count: bCols), count: aRows)
    for i in 0..<aRows {
        for j in 0..<bCols {
            for k in 0..<aCols {
                result[i][j] += matrixA[i][k] * matrixB[k][j]
            }
        }
    }
    return result
}
func CalculatePoint(parametrT: Double, beizerMatrix: [[Double]] ,controlPoints: [[Double]]) -> CGPoint{
    var result = CGPoint()
    var foundPoint = [[Double]]()
    foundPoint = multiplyMatrices(matrixA: multiplyMatrices(matrixA: calculateVectorT(parametrT: parametrT, number: controlPoints.count), matrixB: beizerMatrix) ?? [[0.0, 0.0]], matrixB: controlPoints) ?? [[0.0, 0.0]]
    result.x = foundPoint[0][0]
    result.y = foundPoint[0][1]
    return result
}
func convertPointsToMatrix(_ points: [CGPoint]) -> [[Double]] {
    return points.map { [Double($0.x), Double($0.y)] }
}
func CalculatePointsForCurve(controlPointsInCG: [CGPoint]) -> [CGPoint]{
    let pointMantix = convertPointsToMatrix(controlPointsInCG)
    let BezierMatrix = calculateBeizerMatrix(number: pointMantix.count - 1)
    var curvePointArray = [CGPoint]()
    for value in stride(from: 0.0, to: 1.0001, by: 0.0001){
        curvePointArray.append(CalculatePoint(parametrT: value, beizerMatrix: BezierMatrix, controlPoints: pointMantix))
    }
    return curvePointArray
}
func sumOfRows(in matrix: [[Double]]) -> [Double] {
    var sums = Array(repeating: 0.0, count: matrix.count)
    for rowIndex in 0..<matrix.count{
        for elementIndex in 0..<matrix[rowIndex].count{
            sums[rowIndex]+=matrix[rowIndex][elementIndex]
        }
    }
    return sums
}

