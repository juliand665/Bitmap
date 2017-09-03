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
		let bitmap = generateRandom()
		let encoded = bitmap.cgImage()
		let decoded = Bitmap(from: encoded)!
		XCTAssertEqual(bitmap.pixels, decoded.pixels)
	}
	
	/// generates a random bitmap
	func generateRandom(width: Int = 512, height: Int = 384) -> Bitmap {
		let bitmap = Bitmap(width: width, height: height)
		for y in 0..<height {
			for x in 0..<width {
				bitmap[x, y] = randomPixel()
			}
		}
		return bitmap
	}
	
	func randomPixel(withAlpha alpha: Double? = nil) -> Pixel {
		func randomDouble() -> Double {
			return Double(arc4random()) / Double(UInt32.max)
		}
		
		return Pixel(red: randomDouble(), green: randomDouble(), blue: randomDouble(), premultiplyingWithAlpha: alpha ?? randomDouble())
	}
}
