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
	
	/// Initializes a bitmap of the specified width and height, filled with a single color.
	/// 
	/// - Parameter base: the color to initially fill the bitmap with; defaults to `Pixel.clear`
	public convenience init(width: Int, height: Int, filledWith base: Pixel = .clear) {
		self.init(width: width, height: height, pixels: Array(repeating: base, count: width * height))!
	}
	
	// TODO this is apparently slow af
	/// Initializes a bitmap of the specified width and height, consulting your custom closure for each pixel.
	/// 
	/// - Parameter generator: This closure is queried for every position in the bitmap and its result is used in the specified slot
	public convenience init(width: Int, height: Int, using generator: (_ x: Int, _ y: Int) throws -> Pixel) rethrows {
		let pixels = try (0..<height).flatMap { y in
			try (0..<width).map { x in
				try generator(x, y)
			}
		}
		self.init(width: width, height: height, pixels: pixels)!
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
	
	/// Size of the bitmap, as a `CGSize` for your convenience
	public var size: CGSize {
		return CGSize(width: width, height: height)
	}
	
	/// Creates an image from the bitmap, using its underlying data.
	public func cgImage() -> CGImage {
		return context.makeImage()!
	}
	
	/// Creates a new bitmap from the given image.
	public convenience init(from cgImage: CGImage) {
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
	
	/// creates and returns a new copy of this bitmap
	public func copy() -> Bitmap {
		return Bitmap(width: width, height: height, pixels: pixels)!
	}
	
	/**
	Maps `transform` over all pixels, returning a row-major matrix of the mapped pixels (pixels on the same line are congiuous in memory)
	
	- Parameter transform: The transformation to apply to every pixel
	*/
	public func map<T>(_ transform: (Pixel) -> T) -> [[T]] {
		return stride(from: 0, to: pixels.count, by: width).map { offset -> [T] in
			pixels[offset ..< offset + width].map(transform)
		}
	}
}

extension CGContext {
	public func draw(_ bitmap: Bitmap, at point: CGPoint = .zero) {
		self.draw(bitmap.cgImage(), in: CGRect(origin: point, size: bitmap.size))
	}
}
