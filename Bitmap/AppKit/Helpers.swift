//
//  Helpers.swift
//  Bitmap macOS
//
//  Created by Julian Dunskus on 02.09.17.
//

import Cocoa

extension Pixel {
	public init(_ nsColor: NSColor) {
		self.init(red:   nsColor.redComponent,
		          green: nsColor.greenComponent,
		          blue:  nsColor.blueComponent,
		          alpha: nsColor.alphaComponent)
	}
	
	public init(_ cgColor: CGColor) {
		self.init(NSColor(cgColor: cgColor)!)
	}
}
