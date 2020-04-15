import Foundation

extension Pixel {
	public var rgbHexInt: Int {
		0
			| Int(red) << 16
			| Int(green) << 8
			| Int(blue) << 0
	}
	
	// no conversion to hex with alpha because it's premultiplied and we'd lose a bunch of precision
	
	public init(rgbHex rgb: Int) {
		self.init(
			red: Component(rgb >> 16 & 0xFF),
			green: Component(rgb >> 8 & 0xFF),
			blue: Component(rgb >> 0 & 0xFF)
		)
	}
	
	public init(argbHex argb: Int) {
		self.init(
			red: Component(argb >> 16 & 0xFF),
			green: Component(argb >> 8 & 0xFF),
			blue: Component(argb >> 0 & 0xFF),
			alpha: Component(argb >> 24 & 0xFF)
		)
	}
	
	public init(rgbaHex rgba: Int) {
		self.init(
			red: Component(rgba >> 24 & 0xFF),
			green: Component(rgba >> 16 & 0xFF),
			blue: Component(rgba >> 8 & 0xFF),
			alpha: Component(rgba >> 0 & 0xFF)
		)
	}
}
