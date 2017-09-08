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
	
	func testPerformance() {
		let bitmap = generateRandom(width: 1280, height: 720)
		measure {
			for _ in 1...10 {
				let cgImage = bitmap.cgImage()
				let nsImage = NSImage(cgImage: cgImage, size: .zero)
				let rep = nsImage.tiffRepresentation!
				let newImage = NSImage(data: rep)
//				print(i)
			}
			print("done!")
		}
	}
	
	func _testPerformance1() {
		var bitmap: Bitmap!
		measure {
			for i in 1...1 {
				print(i)
				bitmap = generateRandom(width: 1280, height: 720)
			}
			print("done!")
		}
		let cgImage = bitmap.cgImage()
		let nsImage = NSImage(cgImage: cgImage, size: .zero)
		print(nsImage.size)
	}
	
	func _testPerformance2() {
		let bitmap = generateRandom(width: 1280, height: 720)
		var cgImage: CGImage!
		measure {
			for i in 1...10000 {
				print(i)
				cgImage = bitmap.cgImage()
			}
			print("done!")
		}
		let nsImage = NSImage(cgImage: cgImage, size: .zero)
		print(nsImage.size)
	}
	
	func _testPerformance3() {
		let bitmap = generateRandom(width: 1280, height: 720)
		let cgImage = bitmap.cgImage()
		var nsImage: NSImage!
		measure {
			for i in 1...10000 {
				print(i)
				nsImage = NSImage(cgImage: cgImage, size: .zero)
			}
			print("done!")
		}
		print(nsImage.size)
	}
	
	/// generates a random bitmap
	func generateRandom(width: Int = 512, height: Int = 384) -> Bitmap {
		return Bitmap(width: width, height: height) { (_, _) in fastRandomPixel() }
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
