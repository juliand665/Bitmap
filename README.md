<p align="center">
	<img width=192px src="GitHub/logo.png" /><br><br>
	<a href="https://swift.org/package-manager/">
		<img alt="Swift Package Manager compatible" src="https://img.shields.io/badge/swift_package_manager-compatible-brightgreen.svg" />
	</a>
	<a href="./LICENSE">
		<img alt="MIT licensed" src="https://img.shields.io/badge/license-MIT-blue.svg" />
	</a>
</p>

# Bitmap

###### Easy low-overhead access to individual pixels.

Bitmap uses low-level data pointers to reduce overhead in working with `CGImage`.

It allows you to get and set pixels directly through a 2-argument subscript, as well as offering various bulk creation/modification operations.

### Example

Identify pixels that are neither fully opaque nor fully transparent and turn them red, clearing the rest.

```Swift
for y in 0..<bitmap.height {
	for x in 0..<bitmap.width {
		if case 1...254 = bitmap[x, y].alpha {
			bitmap[x, y] = .red
		} else {
			bitmap[x, y] = .clear
		}
	}
}
```

<table>
  <tr align="center">
    <td>turns this</td>
    <td>into this</td>
  </tr>
  <tr>
    <td><img width=200 src=GitHub/swift.png /></td>
    <td><img width=200 src=GitHub/swift_processed.png /></td>
  </tr>
</table>


