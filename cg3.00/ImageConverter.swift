import UIKit

struct HSV {
    var h: CGFloat
    var s: CGFloat
    var v: CGFloat
}

class ImageProcessor {
    var originalImageView: UIImageView!
    var convertedImageView: UIImageView!
    
    func loadImage(from url: URL) {
        guard let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return
        }
        
        originalImageView.image = image
        if let processedImage = processImage(image: image) {
            convertedImageView.image = processedImage
        }
    }
    
    private func processImage(image: UIImage) -> UIImage? {
        guard let inputCGImage = image.cgImage else { return nil }
        
        let width = inputCGImage.width
        let height = inputCGImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bytesPerPixel = 4
        let bitsPerComponent = 8
        let bytesPerRow = bytesPerPixel * width
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else { return nil }
        let pixelBuffer = buffer.bindMemory(to: UInt32.self, capacity: width * height)
        
        var hsvData: [HSV] = []
        
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = y * width + x
                let pixel = pixelBuffer[pixelIndex]
                
                let r = CGFloat((pixel >> 16) & 255) / 255
                let g = CGFloat((pixel >> 8) & 255) / 255
                let b = CGFloat(pixel & 255) / 255
                
                let hsv = rgbToHsv(r: r, g: g, b: b)
                hsvData.append(hsv)
            }
        }
        
        return drawHSVImage(hsvData: hsvData, width: width, height: height)
    }
    
    private func rgbToHsv(r: CGFloat, g: CGFloat, b: CGFloat) -> HSV {
        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)
        let d = max - min
        var h: CGFloat = 0
        let s = max == 0 ? 0 : d / max
        let v = max
        
        if max == min {
            h = 0 // achromatic
        } else {
            if max == r {
                h = (g - b) / d + (g < b ? 6 : 0)
            } else if max == g {
                h = (b - r) / d + 2
            } else if max == b {
                h = (r - g) / d + 4
            }
            h /= 6
        }
        
        return HSV(h: h, s: s, v: v)
    }
    
    private func drawHSVImage(hsvData: [HSV], width: Int, height: Int) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        for i in 0..<hsvData.count {
            let color = UIColor(hue: hsvData[i].h, saturation: hsvData[i].s, brightness: hsvData[i].v, alpha: 1.0)
            context.setFillColor(color.cgColor)
            let x = i % width
            let y = i / width
            context.fill(CGRect(x: x, y: y, width: 1, height: 1))
        }
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
}
