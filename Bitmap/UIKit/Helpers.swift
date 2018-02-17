//
//  Helpers.swift
//  Bitmap
//
//  Created by Julian Dunskus on 02.09.17.
//

import UIKit

extension Pixel {
	public init(_ uiColor: UIColor) {
		var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
		self.init(red: r, green: g, blue: b, premultiplyingWithAlpha: a)
	}
	
	public init(_ cgColor: CGColor) {
		self.init(UIColor(cgColor: cgColor))
	}
}
