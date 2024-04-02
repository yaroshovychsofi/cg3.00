import Accelerate
import UIKit
import SwiftUI

struct ComplexNumber {
    var real: Double
    var imaginary: Double

    func squaredSin() -> ComplexNumber {
        let realPart = sin(real) * cosh(imaginary)
        let imaginaryPart = cos(real) * sinh(imaginary)
        return ComplexNumber(real: realPart * realPart - imaginaryPart * imaginaryPart,
                             imaginary: 2 * realPart * imaginaryPart)
    }

    func magnitude() -> Double {
        return sqrt(real*real + imaginary*imaginary)
    }

    static func +(left: ComplexNumber, right: ComplexNumber) -> ComplexNumber {
        return ComplexNumber(real: left.real + right.real, imaginary: left.imaginary + right.imaginary)
    }
}

struct SinFractalView: UIViewRepresentable {
    var maxIterations: Int
    var boundsSize: Double
    var colors: [Color]

    func makeUIView(context: Context) -> UIView {
        let view = SinFractalUIView()
        view.maxIterations = maxIterations
        view.boundsSize = boundsSize
        // Конвертація SwiftUI Color у UIColor
        view.colors = colors.map { UIColor($0) }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let fractalView = uiView as? SinFractalUIView {
            fractalView.maxIterations = maxIterations
            fractalView.boundsSize = boundsSize
            fractalView.colors = colors.map { UIColor($0) }
            uiView.setNeedsDisplay()
        }
    }
}

class SinFractalUIView: UIView {
    var maxIterations: Int = 500
    var boundsSize: Double = 5.0
    // Масив кольорів для фракталу
    var colors: [UIColor] = [.black, .white]

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let width = Int(rect.width)
        let height = Int(rect.height)
        for x in 0..<width {
            for y in 0..<height {
                let c = ComplexNumber(
                    real: boundsSize * (Double(x) / Double(width)) - boundsSize / 2,
                    imaginary: boundsSize * (Double(y) / Double(height)) - boundsSize / 2
                )
                var z = ComplexNumber(real: 0, imaginary: 0)
                var iterations = 0

                while z.magnitude() <= 2.0 && iterations < maxIterations {
                    z = z.squaredSin() + c
                    iterations += 1
                }

                let colorIndex = iterations % colors.count
                let color = iterations == maxIterations ? UIColor.black : colors[colorIndex]
                context.setFillColor(color.cgColor)
                context.fill(CGRect(x: x, y: y, width: 1, height: 1))
            }
        }
    }
}
