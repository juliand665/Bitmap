//
//  Pixel.swift
//  Bitmap
//
//  Created by Julian Dunskus on 31.08.17.
//

import CoreGraphics

public struct Pixel {
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
	public var red: UInt8
	
	/// the green component, out of 255
	public var green: UInt8
	
	/// the blue component, out of 255
	public var blue: UInt8
	
	/// the alpha component, out of 255 (255 means fully opaque)
	/// 
	/// N.B.: RGB components should be premultiplied with the alpha, i.e. the alpha is always the maximum component.
	public var alpha: UInt8
	
	/**
	Creates a pixel with the specified premultiplied components, ranging from 0 to 255.
	
	- Parameter red: the red component, out of 255
	- Parameter green: the green component, out of 255
	- Parameter blue: the blue component, out of 255
	- Parameter alpha: the alpha component, out of 255 — defaults to 255 (opaque)
	*/
	public init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = 255) {
		self.red = red
		self.green = green
		self.blue = blue
		self.alpha = alpha
	}
	
	/**
	Creates a pixel with the specified **premultiplied** floating-point components, ranging from 0 to 1.
	
	Arguments will be clamped to `0.0...1.0` before conversion to `UInt8`; go nuts!
	
	- Parameter red: the red component, from 0 to 1
	- Parameter green: the green component, from 0 to 1
	- Parameter blue: the blue component, from 0 to 1
	- Parameter alpha: the alpha component, from 0 to 1 — defaults to 1 (opaque)
	*/
	public init<F: BinaryFloatingPoint>(red: F, green: F, blue: F, alpha: F = 1) {
		self.init(red: red.clamped().uInt8,
		          green: green.clamped().uInt8,
		          blue: blue.clamped().uInt8,
		          alpha: alpha.clamped().uInt8)
	}
	
	/**
	Creates a pixel with the specified (**not** premultiplied) floating-point components, ranging from 0 to 1.
	
	Arguments will be clamped to `0.0...1.0` before conversion to `UInt8`; go nuts!
	
	This initializer premultiplies the RGB components with the alpha component so you don't have to! :)
	
	- Parameter red: the red component, from 0 to 1
	- Parameter green: the green component, from 0 to 1
	- Parameter blue: the blue component, from 0 to 1
	- Parameter alpha: the alpha component, from 0 to 1
	*/
	public init<F: BinaryFloatingPoint>(red: F, green: F, blue: F, premultiplyingWithAlpha alpha: F) {
		let clamped = alpha.clamped()
		self.init(red: (clamped * red.clamped()).uInt8,
		          green: (clamped * green.clamped()).uInt8,
		          blue: (clamped * blue.clamped()).uInt8,
		          alpha: alpha.uInt8)
	}
}

extension FloatingPoint {
	func clamped(to bounds: (min: Self, max: Self) = (0, 1)) -> Self {
		return .minimum(bounds.max, .maximum(bounds.min, self))
	}
}

extension BinaryFloatingPoint {
	var uInt8: UInt8 {
		return UInt8((255 * self).rounded())
	}
}
