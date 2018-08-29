//
//  ExtensionsTests.swift
//  unit tests
//
//  Created by Ondřej Hanák on 23. 08. 2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import XCTest
@testable import menuol

final class ExtensionsTests: XCTestCase {

	func testStringCapitalization() {
		var original = "hello world!"
		let new = original.capitalizingFirstLetter()
		XCTAssertEqual(new, "Hello world!")
		original.capitalizeFirstLetter()
		XCTAssertEqual(original, "Hello world!")
	}

	func testDateStringOnly() {
		let components = DateComponents(year: 2018, month: 08, day: 23, hour: 16, minute: 4, second: 10)
		let date = Calendar.current.date(from: components)!
		let string = DateFormatter.dateOnlyString(from: date)
		XCTAssertEqual(string, "2018-08-23")
	}

	func testCzechDateString() {
		let components = DateComponents(year: 2018, month: 08, day: 23, hour: 16, minute: 4, second: 10)
		let date = Calendar.current.date(from: components)!
		let string = DateFormatter.czechDateString(from: date)
		XCTAssertEqual(string, "čtvrtek 23. srpna")
	}

	func testImageWithColor() {
		let red = 255.0
		let green = 128.0
		let blue = 64.0
		let alpha = 255.0
		let color = UIColor(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: CGFloat(alpha / 255.0))
		let size = CGSize(width: 100, height: 200)

		// check size
		let image = UIImage(color: color, size: size)!
		XCTAssertEqual(image.size, size)

		// check color (data are stored as [b, g, r, a])
		let data: UnsafePointer<UInt8> = CFDataGetBytePtr(image.cgImage!.dataProvider!.data)
		XCTAssertEqual(UInt8(red), data[2])
		XCTAssertEqual(UInt8(green), data[1])
		XCTAssertEqual(UInt8(blue), data[0])
		XCTAssertEqual(UInt8(alpha), data[3])
	}
}
