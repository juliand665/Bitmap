import Cocoa
import Bitmap
import PlaygroundSupport
//: # Bitmap Playground
//: 
//: Use this to experiment with bitmaps or play around with the predefined examples.
// try anything once ;)
//: ***
//: 
//: ## "Edge Detection"
//: 
//: ### (well, almost)
let image = #imageLiteral(resourceName: "swift logo 500w.png").cgImage(forProposedRect: nil, context: nil, hints: nil)!
let bitmap = Bitmap(from: image)
//: Please excuse the fact that playgrounds are *slow af.*
//: The inner part will be executed 65'536 times in total.
for y in 0..<bitmap.height {
	for x in 0..<bitmap.width {
		if case 1...254 = bitmap[x, y].alpha {
			bitmap[x, y] = .red
		} else {
			bitmap[x, y] = .clear
		}
	}
}
try saveImageToDesktop(bitmap.cgImage(), named: "processed image.png")
//: ***
//: 
//: ## Generating Gradients
//: 
//: ### The Wrong Way™
generateGradient(from: .red, to: .clear)
//: ### The Right Way™
generateGradient(from: .red, to: Pixel(red: 255, green: 0, blue: 0, alpha: 0))
//: ***
