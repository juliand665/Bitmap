import Cocoa
import Bitmap
import PlaygroundSupport
//: # Bitmap Playground
//: Use this to experiment with bitmaps or play around with the predefined examples.
print("Hello, world!")
//: ***
//: ## "Edge Detection"
//: ### (well, almost)
let dickbutt = #imageLiteral(resourceName: "dickbutt.png").cgImage(forProposedRect: nil, context: nil, hints: nil)!
let bitmap = Bitmap(from: dickbutt)!
//: Please excuse the fact that playgrounds are *slow af.*
//: The inner part will be executated 65536 times in total.
for y in 0..<bitmap.height {
	for x in 0..<bitmap.width {
		if case 1...254 = bitmap[x, y].alpha {
			bitmap[x, y] = .red
		} else {
			bitmap[x, y] = .clear
		}
	}
}
bitmap
//: ***
//: ## Generating Gradients
//: The Wrong Way™
generateGradient(from: .red, to: .clear)
//: The Right Way™
generateGradient(from: .red, to: Pixel(red: 255, green: 0, blue: 0, alpha: 0))
//: ***
