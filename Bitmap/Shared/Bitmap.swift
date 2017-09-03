//
//  Bitmap.swift
//  Bitmap
//
//  Created by Julian Dunskus on 31.08.17.
//

import CoreGraphics

// 'ere be horrible CoreGraphics APIs

public class Bitmap {
	static let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
	static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
	static let componentSize = MemoryLayout<Pixel.Component>.size
	static let pixelSize = MemoryLayout<Pixel>.size
	
	/// the bitmap's underlying data
	public private(set) var pixels: [Pixel]
	public private(set) var width, height: Int
	
	private var context: CGContext
	
	/**
	Initializes a bitmap of the specified width and height
	
	This constructor fails iff `width * height != pixels.count`
	
	- Parameter pixels: initial pixels of the bitmap
	*/
	public init?(width: Int, height: Int, pixels: [Pixel]) {
		guard pixels.count == width * height else { return nil }
		self.width = width
		self.height = height
		self.pixels = pixels
		context = CGContext(data: &self.pixels,
		                    width: width,
		                    height: height,
		                    bitsPerComponent: 8 * Bitmap.componentSize,
		                    bytesPerRow: width * Bitmap.pixelSize,
		                    space: Bitmap.rgbColorSpace,
		                    bitmapInfo: Bitmap.bitmapInfo)!
	}
	
	/// Initializes a bitmap of the specified width and height
	/// 
	/// - Parameter base: the color to initially fill the bitmap with; defaults to `Pixel.clear`
	public convenience init(width: Int, height: Int, filledWith base: Pixel = .clear) {
		self.init(width: width, height: height, pixels: .init(repeating: base, count: width * height))!
	}
	
	/// Access the pixel at the specified x and y coordinates
	public subscript(x: Int, y: Int) -> Pixel {
		get {
			return pixels[x + y * width]
		}
		set {
			pixels[x + y * width] = newValue
		}
	}
	
	public var size: CGSize {
		return CGSize(width: width, height: height)
	}
	
	/// Bitmap -> CGImage
	public func cgImage() -> CGImage {
		return context.makeImage()!
	}
	
	/// CGImage -> Bitmap
	public convenience init?(from cgImage: CGImage) {
		self.init(width: cgImage.width, height: cgImage.height)
		
		context.draw(cgImage, in: CGRect(origin: .zero, size: size))
	}
	
	/**
	Allows you to access the bitmap's data in form of a `CGContext` which you can use to draw shapes and such.
	
	**DO NOT** keep the context around outside this closure. (If you absolutely have to, just make sure this bitmap stays allocated as long as you need its context.)
	
	- Parameter block: This is your chance to prove yourself! Do whatever you want with the context you're given, just make sure it doesn't outlive this call. God knows what happens if you do anything to it after this bitmap is deallocated.
	- Parameter context: A context referencing the bitmap's underlying data. Anything you do to this context will be reflected in the bitmap automagically.
	*/
	public func withContext<Result>(do block: (_ context: CGContext) -> Result) -> Result {
		return block(context)
	}
}
