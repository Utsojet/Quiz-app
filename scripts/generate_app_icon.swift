import Cocoa
import CoreGraphics

func createQuizzicalLogo(size: Int) -> NSImage {
    let s = CGFloat(size)
    let image = NSImage(size: NSSize(width: s, height: s))
    image.lockFocus()
    guard let ctx = NSGraphicsContext.current?.cgContext else {
        image.unlockFocus()
        return image
    }

    let rect = CGRect(x: 0, y: 0, width: s, height: s)

    // 1. Base rounded squircle background
    let cornerRadius = s * 0.22
    let bgPath = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)

    ctx.saveGState()
    ctx.addPath(bgPath)
    ctx.clip()

    // Background Gradient: Deep Teal / Emerald to Dark Forest
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bgColors = [
        NSColor(red: 13/255, green: 148/255, blue: 136/255, alpha: 1.0).cgColor, // #0D9488
        NSColor(red: 15/255, green: 118/255, blue: 110/255, alpha: 1.0).cgColor, // #0F766E
        NSColor(red: 4/255, green: 47/255, blue: 46/255, alpha: 1.0).cgColor     // #042F2E
    ] as CFArray
    let bgLocations: [CGFloat] = [0.0, 0.45, 1.0]
    if let bgGradient = CGGradient(colorsSpace: colorSpace, colors: bgColors, locations: bgLocations) {
        ctx.drawLinearGradient(bgGradient, start: CGPoint(x: 0, y: s), end: CGPoint(x: s, y: 0), options: [])
    }

    // Soft top-center ambient glow
    let glowColors = [
        NSColor(white: 1.0, alpha: 0.2).cgColor,
        NSColor(white: 1.0, alpha: 0.0).cgColor
    ] as CFArray
    if let glowGradient = CGGradient(colorsSpace: colorSpace, colors: glowColors, locations: [0.0, 1.0]) {
        ctx.drawRadialGradient(
            glowGradient,
            startCenter: CGPoint(x: s * 0.5, y: s * 0.8),
            startRadius: 0,
            endCenter: CGPoint(x: s * 0.5, y: s * 0.8),
            endRadius: s * 0.6,
            options: []
        )
    }

    // Light subtle backdrop circle
    ctx.saveGState()
    ctx.setFillColor(NSColor(red: 254/255, green: 243/255, blue: 199/255, alpha: 0.12).cgColor)
    ctx.fillEllipse(in: CGRect(x: s * 0.12, y: s * 0.12, width: s * 0.76, height: s * 0.76))
    ctx.restoreGState()

    drawFloatingAndCenter(ctx: ctx, s: s, colorSpace: colorSpace)

    // Subtle Outer Border / Bevel Stroke for app icon polish
    ctx.addPath(bgPath)
    ctx.setLineWidth(s * 0.015)
    ctx.setStrokeColor(NSColor(white: 1.0, alpha: 0.15).cgColor)
    ctx.strokePath()

    ctx.restoreGState()
    image.unlockFocus()
    return image
}

func createQuizzicalForeground(size: Int) -> NSImage {
    let s = CGFloat(size)
    let image = NSImage(size: NSSize(width: s, height: s))
    image.lockFocus()
    guard let ctx = NSGraphicsContext.current?.cgContext else {
        image.unlockFocus()
        return image
    }

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    // For adaptive foreground (108dp), scale down slightly into the 72dp safe zone (factor ~0.72)
    ctx.saveGState()
    let scale: CGFloat = 0.72
    let offset = s * (1.0 - scale) * 0.5
    ctx.translateBy(x: offset, y: offset)
    ctx.scaleBy(x: scale, y: scale)

    drawFloatingAndCenter(ctx: ctx, s: s, colorSpace: colorSpace)

    ctx.restoreGState()
    image.unlockFocus()
    return image
}

func drawFloatingAndCenter(ctx: CGContext, s: CGFloat, colorSpace: CGColorSpace) {
    let rect = CGRect(x: 0, y: 0, width: s, height: s)

    // Coral Pill badge (Top-Left)
    ctx.saveGState()
    let pillRect = CGRect(x: s * 0.13, y: s * 0.68, width: s * 0.15, height: s * 0.08)
    let pillPath = CGPath(roundedRect: pillRect, cornerWidth: pillRect.height * 0.5, cornerHeight: pillRect.height * 0.5, transform: nil)
    ctx.setShadow(offset: CGSize(width: 0, height: -s * 0.015), blur: s * 0.025, color: NSColor(red: 244/255, green: 63/255, blue: 94/255, alpha: 0.4).cgColor)
    ctx.setFillColor(NSColor(red: 244/255, green: 63/255, blue: 94/255, alpha: 1.0).cgColor)
    ctx.addPath(pillPath)
    ctx.fillPath()
    ctx.setFillColor(NSColor(white: 1.0, alpha: 0.9).cgColor)
    let line1 = CGRect(x: pillRect.minX + pillRect.width * 0.2, y: pillRect.midY + s * 0.008, width: pillRect.width * 0.6, height: s * 0.01)
    let line2 = CGRect(x: pillRect.minX + pillRect.width * 0.2, y: pillRect.midY - s * 0.018, width: pillRect.width * 0.4, height: s * 0.01)
    ctx.addPath(CGPath(roundedRect: line1, cornerWidth: s * 0.005, cornerHeight: s * 0.005, transform: nil))
    ctx.addPath(CGPath(roundedRect: line2, cornerWidth: s * 0.005, cornerHeight: s * 0.005, transform: nil))
    ctx.fillPath()
    ctx.restoreGState()

    // Golden Sphere (Bottom-Left)
    ctx.saveGState()
    let sphereCenter = CGPoint(x: s * 0.19, y: s * 0.35)
    let sphereRadius = s * 0.055
    ctx.setShadow(offset: CGSize(width: 0, height: -s * 0.015), blur: s * 0.02, color: NSColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 0.45).cgColor)
    let sphereColors = [
        NSColor(red: 254/255, green: 240/255, blue: 138/255, alpha: 1.0).cgColor,
        NSColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1.0).cgColor,
        NSColor(red: 180/255, green: 83/255, blue: 9/255, alpha: 1.0).cgColor
    ] as CFArray
    if let sphereGrad = CGGradient(colorsSpace: colorSpace, colors: sphereColors, locations: [0.0, 0.6, 1.0]) {
        ctx.drawRadialGradient(
            sphereGrad,
            startCenter: CGPoint(x: sphereCenter.x - sphereRadius * 0.35, y: sphereCenter.y + sphereRadius * 0.35),
            startRadius: 0,
            endCenter: sphereCenter,
            endRadius: sphereRadius,
            options: []
        )
    }
    ctx.restoreGState()

    // Coral Mini Question Mark (Top-Right)
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: -s * 0.01), blur: s * 0.015, color: NSColor(red: 251/255, green: 113/255, blue: 133/255, alpha: 0.4).cgColor)
    let miniQFont = NSFont.systemFont(ofSize: s * 0.11, weight: .heavy)
    let miniQAttr: [NSAttributedString.Key: Any] = [
        .font: miniQFont,
        .foregroundColor: NSColor(red: 251/255, green: 113/255, blue: 133/255, alpha: 1.0)
    ]
    let miniQString = NSAttributedString(string: "?", attributes: miniQAttr)
    miniQString.draw(at: NSPoint(x: s * 0.77, y: s * 0.65))
    ctx.restoreGState()

    // Mint Mini Question Mark (Bottom-Right)
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: -s * 0.01), blur: s * 0.015, color: NSColor(red: 45/255, green: 212/255, blue: 191/255, alpha: 0.4).cgColor)
    let miniQAttr2: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: s * 0.095, weight: .bold),
        .foregroundColor: NSColor(red: 45/255, green: 212/255, blue: 191/255, alpha: 0.95)
    ]
    let miniQString2 = NSAttributedString(string: "?", attributes: miniQAttr2)
    miniQString2.draw(at: NSPoint(x: s * 0.76, y: s * 0.30))
    ctx.restoreGState()

    // Four-point Gold Sparkles
    func drawSparkle(center: CGPoint, radius: CGFloat) {
        ctx.saveGState()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: center.x, y: center.y + radius))
        path.addQuadCurve(to: CGPoint(x: center.x + radius, y: center.y), control: center)
        path.addQuadCurve(to: CGPoint(x: center.x, y: center.y - radius), control: center)
        path.addQuadCurve(to: CGPoint(x: center.x - radius, y: center.y), control: center)
        path.addQuadCurve(to: CGPoint(x: center.x, y: center.y + radius), control: center)
        path.closeSubpath()
        ctx.setFillColor(NSColor(red: 253/255, green: 224/255, blue: 71/255, alpha: 0.9).cgColor)
        ctx.addPath(path)
        ctx.fillPath()
        ctx.restoreGState()
    }
    drawSparkle(center: CGPoint(x: s * 0.28, y: s * 0.81), radius: s * 0.026)
    drawSparkle(center: CGPoint(x: s * 0.72, y: s * 0.21), radius: s * 0.022)

    // Central Hero 3D Question Mark
    let qFontSize = s * 0.58
    let qFont = NSFont.systemFont(ofSize: qFontSize, weight: .black)

    let qText = "?"
    let layoutManager = NSLayoutManager()
    let textStorage = NSTextStorage(string: qText, attributes: [.font: qFont])
    let textContainer = NSTextContainer(size: NSSize(width: s, height: s))
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)

    let qGlyphRect = layoutManager.usedRect(for: textContainer)
    let qOriginX = (s - qGlyphRect.width) * 0.5
    let qOriginY = (s - qGlyphRect.height) * 0.5 - s * 0.03

    // 3D Extrusion Shadow Layers
    for layer in (1...8).reversed() {
        let offsetFraction = CGFloat(layer) * s * 0.0035
        let shadowColor = NSColor(red: 180/255, green: 83/255, blue: 9/255, alpha: 0.25).cgColor
        ctx.saveGState()
        ctx.setShadow(offset: CGSize(width: 0, height: -offsetFraction), blur: s * 0.015, color: shadowColor)
        let attr: [NSAttributedString.Key: Any] = [
            .font: qFont,
            .foregroundColor: NSColor(red: 217/255, green: 119/255, blue: 6/255, alpha: 0.9)
        ]
        let str = NSAttributedString(string: qText, attributes: attr)
        str.draw(at: NSPoint(x: qOriginX, y: qOriginY - offsetFraction))
        ctx.restoreGState()
    }

    // Main Golden Gradient Question Mark
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: -s * 0.04), blur: s * 0.05, color: NSColor(red: 0, green: 0, blue: 0, alpha: 0.35).cgColor)

    let goldColors = [
        NSColor(red: 254/255, green: 240/255, blue: 138/255, alpha: 1.0).cgColor,
        NSColor(red: 251/255, green: 191/255, blue: 36/255, alpha: 1.0).cgColor,
        NSColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1.0).cgColor,
        NSColor(red: 217/255, green: 119/255, blue: 6/255, alpha: 1.0).cgColor
    ] as CFArray
    let goldLocations: [CGFloat] = [0.0, 0.3, 0.7, 1.0]

    let textImage = NSImage(size: NSSize(width: s, height: s))
    textImage.lockFocus()
    let whiteAttr: [NSAttributedString.Key: Any] = [
        .font: qFont,
        .foregroundColor: NSColor.white
    ]
    NSAttributedString(string: qText, attributes: whiteAttr).draw(at: NSPoint(x: qOriginX, y: qOriginY))
    textImage.unlockFocus()

    if let textCgImage = textImage.cgImage(forProposedRect: nil, context: nil, hints: nil) {
        ctx.clip(to: rect, mask: textCgImage)
        if let goldGrad = CGGradient(colorsSpace: colorSpace, colors: goldColors, locations: goldLocations) {
            ctx.drawLinearGradient(goldGrad, start: CGPoint(x: s * 0.5, y: s * 0.8), end: CGPoint(x: s * 0.5, y: s * 0.2), options: [])
        }

        let glossColors = [
            NSColor(white: 1.0, alpha: 0.45).cgColor,
            NSColor(white: 1.0, alpha: 0.0).cgColor
        ] as CFArray
        if let glossGrad = CGGradient(colorsSpace: colorSpace, colors: glossColors, locations: [0.0, 1.0]) {
            ctx.drawLinearGradient(glossGrad, start: CGPoint(x: s * 0.5, y: s * 0.75), end: CGPoint(x: s * 0.5, y: s * 0.5), options: [])
        }
    }
    ctx.restoreGState()
}

// 1. Generate master 1024x1024 icon
let masterImage = createQuizzicalLogo(size: 1024)
if let tiffData = masterImage.tiffRepresentation,
   let bitmapRep = NSBitmapImageRep(data: tiffData),
   let pngData = bitmapRep.representation(using: .png, properties: [:]) {
    let outputPath = "assets/images/app_icon.png"
    try? pngData.write(to: URL(fileURLWithPath: outputPath))
    print("Master icon successfully saved to \(outputPath)")
}

// 2. Generate standard Android density launcher icons
let densities: [(String, Int)] = [
    ("mipmap-mdpi", 48),
    ("mipmap-hdpi", 72),
    ("mipmap-xhdpi", 96),
    ("mipmap-xxhdpi", 144),
    ("mipmap-xxxhdpi", 192)
]

for (folder, iconSize) in densities {
    let icon = createQuizzicalLogo(size: iconSize)
    if let tiff = icon.tiffRepresentation,
       let rep = NSBitmapImageRep(data: tiff),
       let png = rep.representation(using: .png, properties: [:]) {
        let dest = "android/app/src/main/res/\(folder)/ic_launcher.png"
        try? png.write(to: URL(fileURLWithPath: dest))
        print("Generated \(dest) (\(iconSize)x\(iconSize))")
    }
}

// 3. Generate adaptive icon foregrounds
let adaptiveDensities: [(String, Int)] = [
    ("mipmap-mdpi", 108),
    ("mipmap-hdpi", 162),
    ("mipmap-xhdpi", 216),
    ("mipmap-xxhdpi", 324),
    ("mipmap-xxxhdpi", 432)
]

for (folder, iconSize) in adaptiveDensities {
    let icon = createQuizzicalForeground(size: iconSize)
    if let tiff = icon.tiffRepresentation,
       let rep = NSBitmapImageRep(data: tiff),
       let png = rep.representation(using: .png, properties: [:]) {
        let dest = "android/app/src/main/res/\(folder)/ic_launcher_foreground.png"
        try? png.write(to: URL(fileURLWithPath: dest))
        print("Generated adaptive foreground \(dest) (\(iconSize)x\(iconSize))")
    }
}

print("All icons generated successfully!")
