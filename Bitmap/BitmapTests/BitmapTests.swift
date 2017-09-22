//
//  BitmapTests.swift
//  BitmapTests
//
//  Created by Julian Dunskus on 03.09.17.
//

import XCTest
import AppKit

@testable import Bitmap

class BitmapTests: XCTestCase {
	/**
	Tests symmetry of encoding/decoding in the following way:
	
	1. Creates a random bitmap
	2. Encodes it into a `CGImage`
	3. Creates a new bitmap from the image
	4. Makes sure the two bitmaps are equal
	*/
	func testSymmetry() {
		let bitmap = generateRandom(quickly: false)
		let encoded = bitmap.cgImage()
		let decoded = Bitmap(from: encoded)
		XCTAssertEqual(bitmap.pixels, decoded.pixels)
	}
	
	func testPerformance() {
		let bitmap = generateRandom(width: 1280, height: 720)
		measure {
			for _ in 1...10 {
				let cgImage = bitmap.cgImage()
				let nsImage = NSImage(cgImage: cgImage, size: .zero)
				let rep = nsImage.tiffRepresentation!
				_ = NSImage(data: rep)
			}
		}
	}
	
	func testFromPixels() {
		XCTAssertNil(Bitmap(width: 3, height: 2, pixels: []))
		XCTAssertNil(Bitmap(width: 3, height: 2, pixels: [.red, .green, .blue, .cyan, .magenta, .yellow, .black, .white, .clear]))
		XCTAssertNotNil(Bitmap(width: 3, height: 3, pixels: [.red, .green, .blue, .cyan, .magenta, .yellow, .black, .white, .clear]))
	}
	
	func testFill() {
		let color = #colorLiteral(red: 0.5450980392, green: 0.007843137255, blue: 0.1294117647, alpha: 1).cgColor
		let fast = Bitmap(width: 256, height: 128, filledWith: Pixel(color))
		let slow = Bitmap(width: 256, height: 128)
		slow.withContext { (context) -> Void in
			context.setFillColor(color)
			context.setLineWidth(0)
			context.fill(CGRect(origin: .zero, size: slow.size))
		}
		XCTAssert(fast.pixels == slow.pixels)
	}
	
	func testCopy() {
		let bitmap = generateRandom()
		XCTAssert(bitmap.pixels == bitmap.copy().pixels)
	}
	
	func testDrawing() {
		let first = generateRandom()
		let second = generateRandom()
		second.withContext { $0.draw(first) }
		XCTAssert(first.pixels == second.pixels)
	}
	
	/// generates a random bitmap
	func generateRandom(width: Int = 512, height: Int = 384, quickly: Bool = true) -> Bitmap {
		return Bitmap(width: width, height: height) { (_, _) in quickly ? fastRandomPixel() : slowRandomPixel() }
	}
	
	func fastRandomPixel() -> Pixel {
		func random() -> UInt8 {
			return UInt8(arc4random_uniform(256))
		}
		
		return Pixel(red: random(), green: random(), blue: random())
	}
	
	func slowRandomPixel(withAlpha alpha: Double? = nil) -> Pixel {
		func random() -> Double {
			return Double(arc4random()) / Double(UInt32.max)
		}
		
		return Pixel(red: random(), green: random(), blue: random(), premultiplyingWithAlpha: alpha ?? random())
	}
}
