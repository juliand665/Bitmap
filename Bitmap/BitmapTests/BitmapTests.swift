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
	
	/// Creates a trippy bitmap and writes it to your desktop
	func testCreativeWriting() throws {
		let width = 512
		let height = 386
		let bitmap = Bitmap(width: width, height: height)
		for y in 0..<height {
			for x in 0..<width {
				bitmap[x, y] = Pixel(red: x % 2 == 0 ? 255 : 0,
				                     green: x % 2 == 0 ? 0 : 255,
				                     blue: y % 2 == 0 ? 0 : 255)
			}
		}
		let rep = NSBitmapImageRep(cgImage: bitmap.cgImage())
		let data = rep.representation(using: .png, properties: [:])
		let path = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first!
		let url = URL(fileURLWithPath: "bitmap.png", relativeTo: URL(fileURLWithPath: path))
		print(url.absoluteString)
		try data!.write(to: url)
	}
}
