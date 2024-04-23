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
        let pinch = UIPinchGestureRecognizer(target: view, action: #selector(view.handlePinch(_:)))
        view.addGestureRecognizer(pinch)
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

// Визначення UIViewController, який міститиме  SinFractalUIView
class SinFractalViewController: UIViewController {
    var maxIterations: Int = 100
    var boundsSize: Double = 200.0
    var colors: [UIColor] = [.red, .green, .blue] // Приклад кольорів

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = SinFractalUIView(frame: self.view.frame)
        view.maxIterations = maxIterations
        view.boundsSize = boundsSize
        view.colors = colors
        
        // Додавання жесту масштабування
        let pinch = UIPinchGestureRecognizer(target: view, action: #selector(view.handlePinch(_:)))
        view.addGestureRecognizer(pinch)

        self.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}

// SwiftUI обгортка для  SinFractalViewController
struct SinFractalViewControllerRepresentable: UIViewControllerRepresentable {
    var maxIterations: Int
    var boundsSize: Double
    var colors: [Color]

    func makeUIViewController(context: Context) -> SinFractalViewController {
        let viewController = SinFractalViewController()
        viewController.maxIterations = maxIterations
        viewController.boundsSize = boundsSize
        viewController.colors = colors.map { UIColor($0) } // Конвертація SwiftUI Color у UIColor
        return viewController
    }

    func updateUIViewController(_ uiViewController: SinFractalViewController, context: Context) {
        uiViewController.maxIterations = maxIterations
        uiViewController.boundsSize = boundsSize
        uiViewController.colors = colors.map { UIColor($0) }
    }
}

class SinFractalUIView: UIView {
    var maxIterations: Int = 100
    var boundsSize: Double = 5.0
    var colors: [UIColor] = [.black, .white]
    var scale: CGFloat = 1.0
    var centerOffset: CGPoint = .zero

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let width = Int(rect.width)
        let height = Int(rect.height)
        let scaleFactor = boundsSize / (Double(min(width, height)) * Double(scale))
        
        for x in 0..<width {
            for y in 0..<height {
                let c = ComplexNumber(
                    real: scaleFactor * (Double(x) - Double(width) / 2 + Double(centerOffset.x)),
                    imaginary: scaleFactor * (Double(y) - Double(height) / 2 + Double(centerOffset.y))
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

    @objc func handlePinch(_ pinch: UIPinchGestureRecognizer) {
        if pinch.state == .began || pinch.state == .changed {
            scale *= pinch.scale
            pinch.scale = 1.0
            setNeedsDisplay()
        }
    }
}
