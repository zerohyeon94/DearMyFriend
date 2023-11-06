import UIKit

extension CALayer {
    func applyShadow(color: UIColor,alpha: Float,x: CGFloat,y: CGFloat,blur: CGFloat) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = .white
    }
}

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

extension UIImage {
    var averageColor: UIColor?
    {
        guard let inputImage = CIImage(image: self) else { return nil }

        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else {
            return nil
        }

        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])

        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension UIImage {
    enum AverageColorAlgorithm {
        case simple
        case squareRoot
    }

    func findAverageColor(algorithm: AverageColorAlgorithm = .simple) -> UIColor? {
        guard let cgImage = cgImage else { return nil }

        let size = CGSize(width: 40, height: 40)
        let width = Int(size.width)
        let height = Int(size.height)
        let totalPixels = width * height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue

        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }

        context.draw(cgImage, in: CGRect(origin: .zero, size: size))

        guard let pixelBuffer = context.data else { return nil }

        let pointer = pixelBuffer.bindMemory(to: UInt32.self, capacity: width * height)
        var totalRed = 0
        var totalBlue = 0
        var totalGreen = 0

        for x in 0 ..< width {
            for y in 0 ..< height {
                let pixel = pointer[(y * width) + x]
                let r = red(for: pixel)
                let g = green(for: pixel)
                let b = blue(for: pixel)

                switch algorithm {
                case .simple:
                    totalRed += Int(r)
                    totalBlue += Int(b)
                    totalGreen += Int(g)
                case .squareRoot:
                    totalRed += Int(pow(CGFloat(r), CGFloat(2)))
                    totalGreen += Int(pow(CGFloat(g), CGFloat(2)))
                    totalBlue += Int(pow(CGFloat(b), CGFloat(2)))
                }
            }
        }

        let averageRed: CGFloat
        let averageGreen: CGFloat
        let averageBlue: CGFloat

        switch algorithm {
        case .simple:
            averageRed = CGFloat(totalRed) / CGFloat(totalPixels)
            averageGreen = CGFloat(totalGreen) / CGFloat(totalPixels)
            averageBlue = CGFloat(totalBlue) / CGFloat(totalPixels)
        case .squareRoot:
            averageRed = sqrt(CGFloat(totalRed) / CGFloat(totalPixels))
            averageGreen = sqrt(CGFloat(totalGreen) / CGFloat(totalPixels))
            averageBlue = sqrt(CGFloat(totalBlue) / CGFloat(totalPixels))
        }

        return UIColor(red: averageRed / 255.0, green: averageGreen / 255.0, blue: averageBlue / 255.0, alpha: 1.0)
    }

    private func red(for pixelData: UInt32) -> UInt8 {
        return UInt8((pixelData >> 16) & 255)
    }

    private func green(for pixelData: UInt32) -> UInt8 {
        return UInt8((pixelData >> 8) & 255)
    }

    private func blue(for pixelData: UInt32) -> UInt8 {
        return UInt8((pixelData >> 0) & 255)
    }
}
