//
//  Pixel.swift
//  Bitmap
//
//  Created by Julian Dunskus on 31.08.17.
//

import CoreGraphics

public struct Pixel {
	public typealias Component = UInt8
	
	/// fully transparent
	public static let clear = Pixel(red: 0, green: 0, blue: 0, alpha: 0)
	
	public static let black = Pixel(red:   0, green:   0, blue:   0)
	public static let white = Pixel(red: 255, green: 255, blue: 255)
	
	public static let red     = Pixel(red: 255, green:   0, blue:   0)
	public static let yellow  = Pixel(red: 255, green: 255, blue:   0)
	public static let green   = Pixel(red:   0, green: 255, blue:   0)
	public static let cyan    = Pixel(red:   0, green: 255, blue: 255)
	public static let blue    = Pixel(red:   0, green:   0, blue: 255)
	public static let magenta = Pixel(red: 255, green:   0, blue: 255)
	
	/// the red component, out of 255
	public var red: Component
	
	/// the green component, out of 255
	public var green: Component
	
	/// the blue component, out of 255
	public var blue: Component
	
	/// the alpha component, out of 255 (255 means fully opaque)
	/// 
	/// N.B.: RGB components should be premultiplied with the alpha, i.e. the alpha is always the maximum component.
	public var alpha: Component
	
	/**
	Creates a pixel with the specified premultiplied components, ranging from 0 to 255.
	
	- Parameter red: the red component, out of 255
	- Parameter green: the green component, out of 255
	- Parameter blue: the blue component, out of 255
	- Parameter alpha: the alpha component, out of 255 — defaults to 255 (opaque)
	*/
	public init(red: Component, green: Component, blue: Component, alpha: Component = 255) {
		self.red = red
		self.green = green
		self.blue = blue
		self.alpha = alpha
	}
	
	/**
	Creates a pixel with the specified **premultiplied** floating-point components, ranging from 0 to 1.
	
	Arguments will be clamped to `0.0...1.0` before conversion to `Component`; go nuts!
	
	- Parameter red: the red component, from 0 to 1
	- Parameter green: the green component, from 0 to 1
	- Parameter blue: the blue component, from 0 to 1
	- Parameter alpha: the alpha component, from 0 to 1 — defaults to 1 (opaque)
	*/
	public init<F: BinaryFloatingPoint>(red: F, green: F, blue: F, alpha: F = 1) {
		self.init(cRed:    red.clamped(),
		          green: green.clamped(),
		          blue:   blue.clamped(),
		          alpha: alpha.clamped())
	}
	
	/**
	Creates a pixel with the specified (**not** premultiplied) floating-point components, ranging from 0 to 1.
	
	Arguments will be clamped to `0.0...1.0` before conversion to `Component`; go nuts!
	
	This initializer premultiplies the RGB components with the alpha component so you don't have to! :)
	
	- Parameter red: the red component, from 0 to 1
	- Parameter green: the green component, from 0 to 1
	- Parameter blue: the blue component, from 0 to 1
	- Parameter alpha: the alpha component, from 0 to 1
	*/
	public init<F: BinaryFloatingPoint>(red: F, green: F, blue: F, premultiplyingWithAlpha alpha: F) {
		let clampedAlpha = alpha.clamped()
		self.init(cRed:  clampedAlpha * red.clamped(),
		          green: clampedAlpha * green.clamped(),
		          blue:  clampedAlpha * blue.clamped(),
		          alpha: clampedAlpha)
	}
	
	/// initialize from already clamped values
	private init<F: BinaryFloatingPoint>(cRed red: F, green: F, blue: F, alpha: F) {
		self.init(red:     red.asPixelComponent,
		          green: green.asPixelComponent,
		          blue:   blue.asPixelComponent,
		          alpha: alpha.asPixelComponent)
	}
}

extension Pixel: Equatable {
	public static func ==(lhs: Pixel, rhs: Pixel) -> Bool {
		return lhs.red == rhs.red
			&& lhs.green == rhs.green
			&& lhs.blue == rhs.blue
			&& lhs.alpha == rhs.alpha
	}
}

extension FloatingPoint {
	func clamped(to bounds: (min: Self, max: Self) = (0, 1)) -> Self {
		return .minimum(bounds.max, .maximum(bounds.min, self))
	}
}

extension BinaryFloatingPoint {
	var asPixelComponent: Pixel.Component {
		let rounded = (255 * self).rounded()
		return (rounded as? CGFloat).map(UInt8.init) ?? UInt8(rounded) // calls a different UInt8.init for CGFloats because otherwise we get a runtime crash >_<
	}
}
