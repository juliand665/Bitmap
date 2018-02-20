import UIKit

extension Pixel {
	public init(_ uiColor: UIColor) {
		var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
		self.init(red: r, green: g, blue: b, premultiplyingWithAlpha: a)
	}
	
	public init(_ cgColor: CGColor) {
		self.init(UIColor(cgColor: cgColor))
	}
	
	/**
	Creates a new `UIColor` from the pixel, taking alpha premultiplication into account.
	
	There is some loss of information, e.g. a fully transparent red pixel loses information about its color due to alpha premultiplication. For fully transparent pixels, this method returns a fully transparent black color (`r=g=b=a=0`).
	*/
	public var uiColor: UIColor {
		guard self.alpha > 0 else { return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) }
		let alpha = CGFloat(self.alpha) // stupid premultiplication
		let color = UIColor(red:   CGFloat(red)   / alpha,
							green: CGFloat(green) / alpha,
							blue:  CGFloat(blue)  / alpha,
							alpha: alpha / 255)
		return color
	}
}
