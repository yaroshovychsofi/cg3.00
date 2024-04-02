//
//  cg3_00App.swift
//  cg3.00
//
//  Created by  Sofia Yaroshovych on 26.03.2024.
//

import SwiftUI

@main
struct cg3_00App: App {

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
//            IceFractalView()
//            FractalSettingsView()
        }
    }
}



func findPointsByUserVectorT(vectorT: [Double], controlPointsInCG: [CGPoint]) -> [CGPoint] {
    let pointMantix = convertPointsToMatrix(controlPointsInCG)
    let BezierMatrix = calculateBeizerMatrix(number: pointMantix.count - 1)
    var pointsForUserVectorT = [CGPoint]()
    for value in vectorT{
        pointsForUserVectorT.append(CalculatePoint(parametrT: value, beizerMatrix: BezierMatrix, controlPoints: pointMantix))
    }
    return pointsForUserVectorT
}

