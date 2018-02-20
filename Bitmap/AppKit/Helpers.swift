import Cocoa

extension Pixel {
	public init(_ nsColor: NSColor) {
		self.init(red:   nsColor.redComponent,
		          green: nsColor.greenComponent,
		          blue:  nsColor.blueComponent,
		          premultiplyingWithAlpha: nsColor.alphaComponent)
	}
	
	public init(_ cgColor: CGColor) {
		self.init(NSColor(cgColor: cgColor)!)
	}
	
	/**
	Creates a new `NSColor` from the pixel, taking alpha premultiplication into account.
	
	There is some loss of information, e.g. a fully transparent red pixel loses information about its color due to alpha premultiplication. For fully transparent pixels, this method returns a fully transparent black color (`r=g=b=a=0`).
	*/
	public var nsColor: NSColor {
		guard self.alpha > 0 else { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) }
		let alpha = CGFloat(self.alpha) // stupid premultiplication
		let color = NSColor(red:   CGFloat(red)   / alpha,
							green: CGFloat(green) / alpha,
							blue:  CGFloat(blue)  / alpha,
							alpha: alpha / 255)
		return color
	}
}
