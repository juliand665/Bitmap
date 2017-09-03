import Cocoa
import Bitmap
import PlaygroundSupport

public func saveImageToDesktop(_ image: CGImage, named name: String) throws {
	let rep = NSBitmapImageRep(cgImage: image)
	let data = rep.representation(using: .png, properties: [:])
	let path = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first!
	let url = URL(fileURLWithPath: name, relativeTo: URL(fileURLWithPath: path))
	print("Saving image as", url.absoluteString)
	try data!.write(to: url)
}

public func generateMoiré(width: Int = 128, height: Int = 128) -> Bitmap {
	let bitmap = Bitmap(width: width, height: height)
	for y in 0..<height {
		for x in 0..<width {
			bitmap[x, y] = (x + y) % 2 == 0 ? .white : .black
		}
	}
	return bitmap
}

public func generateGradient(from top: Pixel, to bot: Pixel, width: Int = 128, height: Int = 256) -> Bitmap {
	let top = top.components
	let bot = bot.components
	
	func interpolate(zero: Double, one: Double, progress: Double) -> Double {
		return progress * one + (1 - progress) * zero
	}
	
	let bitmap = Bitmap(width: width, height: height)
	for y in 0..<height {
		let progress = Double(y) / Double(height)
		let color = Pixel(red:   interpolate(zero: top.r, one: bot.r, progress: progress),
		                  green: interpolate(zero: top.g, one: bot.g, progress: progress),
		                  blue:  interpolate(zero: top.b, one: bot.b, progress: progress),
		                  premultiplyingWithAlpha: interpolate(zero: top.a, one: bot.a, progress: progress))
		for x in 0..<width {
			bitmap[x, y] = color
		}
	}
	return bitmap	
}

extension Pixel {
	var components: (r: Double, g: Double, b: Double, a: Double) {
		return (Double(red) / 255, Double(green) / 255, Double(blue) / 255, Double(alpha) / 255)
	}
}

extension Bitmap: PlaygroundLiveViewable, CustomPlaygroundQuickLookable {
	public var playgroundLiveViewRepresentation: PlaygroundLiveViewRepresentation {
		let imageView = NSImageView(image: NSImage(cgImage: cgImage(), size: size))
		imageView.frame = CGRect(origin: .zero, size: size)
		return .view(imageView)
	}
	
	public var customPlaygroundQuickLook: PlaygroundQuickLook {
		return .image(NSImage(cgImage: cgImage(), size: size))
	}
}
