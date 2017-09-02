//
//  Pixel.swift
//  Bitmap
//
//  Created by Julian Dunskus on 31.08.17.
//

import CoreGraphics

public struct Pixel {
	public static let clear = Pixel(red: 0, green: 0, blue: 0, alpha: 0)
	
	public static let black = Pixel(red:   0, green:   0, blue:   0)
	public static let white = Pixel(red: 255, green: 255, blue: 255)
	
	public static let red     = Pixel(red: 255, green:   0, blue:   0)
	public static let yellow  = Pixel(red: 255, green: 255, blue:   0)
	public static let green   = Pixel(red:   0, green: 255, blue:   0)
	public static let cyan    = Pixel(red:   0, green: 255, blue: 255)
	public static let blue    = Pixel(red:   0, green:   0, blue: 255)
	public static let magenta = Pixel(red: 255, green:   0, blue: 255)
	
	public var r, g, b, a: UInt8
	
	public init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = 255) {
		(r, g, b, a) = (red, green, blue, alpha)
	}
	
	public init<F: BinaryFloatingPoint>(red: F, green: F, blue: F, alpha: F = 1) {
		self.init(red: red.uInt8, green: green.uInt8, blue: blue.uInt8, alpha: alpha.uInt8)
	}
}

extension FloatingPoint {
	func clamped(to bounds: (min: Self, max: Self) = (0, 1)) -> Self {
		return .minimum(bounds.max, .maximum(bounds.min, self))
	}
}

extension BinaryFloatingPoint {
	var uInt8: UInt8 {
		return UInt8(255 * clamped())
	}
}
