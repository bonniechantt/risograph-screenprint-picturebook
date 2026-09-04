import Foundation
import CoreGraphics
import CoreText
import ImageIO

guard CommandLine.arguments.count == 4 else {
    fputs("usage: apply_unified_title.swift input.png output.png title\n", stderr)
    exit(2)
}

let inputURL = URL(fileURLWithPath: CommandLine.arguments[1])
let outputURL = URL(fileURLWithPath: CommandLine.arguments[2])
let title = CommandLine.arguments[3]

guard let source = CGImageSourceCreateWithURL(inputURL as CFURL, nil),
      let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
    fputs("could not read input image\n", stderr)
    exit(1)
}

let width = image.width
let height = image.height
let colorSpace = CGColorSpaceCreateDeviceRGB()
guard let context = CGContext(data: nil, width: width, height: height,
                              bitsPerComponent: 8, bytesPerRow: 0,
                              space: colorSpace,
                              bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
    fputs("could not create drawing context\n", stderr)
    exit(1)
}

context.interpolationQuality = .high
context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))

let font = CTFontCreateWithName("HiraMinProN-W6" as CFString, 98, nil)
let ink = CGColor(red: 0.82, green: 0.36, blue: 0.25, alpha: 0.92)
let registrationInk = CGColor(red: 0.28, green: 0.39, blue: 0.38, alpha: 0.12)
let horizontalScale: CGFloat = 0.62
let centerX = CGFloat(width) / 2.0
let baselineFromTop: CGFloat = 238.0
let baselineY = CGFloat(height) - baselineFromTop

func drawTitle(color: CGColor, offsetX: CGFloat, offsetY: CGFloat) {
    let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key(kCTFontAttributeName as String): font,
        NSAttributedString.Key(kCTForegroundColorAttributeName as String): color
    ]
    let line = CTLineCreateWithAttributedString(NSAttributedString(string: title, attributes: attributes))
    let lineWidth = CGFloat(CTLineGetTypographicBounds(line, nil, nil, nil))
    context.saveGState()
    context.translateBy(x: centerX + offsetX, y: baselineY + offsetY)
    context.scaleBy(x: horizontalScale, y: 1.0)
    context.textPosition = CGPoint(x: -lineWidth / 2.0, y: 0)
    CTLineDraw(line, context)
    context.restoreGState()
}

drawTitle(color: registrationInk, offsetX: 1.2, offsetY: -0.8)
drawTitle(color: ink, offsetX: 0, offsetY: 0)

guard let destination = CGImageDestinationCreateWithURL(outputURL as CFURL, "public.png" as CFString, 1, nil),
      let rendered = context.makeImage() else {
    fputs("could not create output image\n", stderr)
    exit(1)
}
CGImageDestinationAddImage(destination, rendered, nil)
if !CGImageDestinationFinalize(destination) {
    fputs("could not write output image\n", stderr)
    exit(1)
}
