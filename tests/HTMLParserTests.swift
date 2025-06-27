//
//  HTMLParserTests.swift
//  tests
//
//  Created by Ondřej Hanák on 23. 08. 2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

@testable import menuol
import XCTest

final class HTMLParserTests: XCTestCase {
	func testVenuesParsing_correct() {
		let parser = HTMLParser()
		let html = loadHTML(from: "Venues.html")

		// venues count
		let venues = parser.venuesWithMenuItems(from: html)
		XCTAssertEqual(venues.count, 107)

		// first venue details
		let venue = venues[0]
		XCTAssertEqual(venue.slug, "Blues-Rock-CAFE-id1207")
		XCTAssertEqual(venue.name, "Blues Rock CAFE")
		XCTAssertEqual(venue.imageURL, URL(string: "https://www.olomouc.cz/images/katalog/1207.gif"))
		XCTAssertEqual(venue.menuTimeDescription, "11:00 - 14:00")
		XCTAssertEqual(venue.address, "Bořivojova 1, 772 00 Olomouc")
		XCTAssertEqual(venue.note, "Testovaci poznaka.")

		// first venue menu items
		XCTAssertEqual(venue.menuItems.count, 6)

		// first menu item
		let firstItem = venue.menuItems.first!
		XCTAssertEqual(firstItem.title, "0,33 l Špenátová")
		XCTAssertEqual(firstItem.order, 0)
		XCTAssertEqual(firstItem.priceDescription, "25 Kč") // nbsp

		// last menu item
		let lastItem = venue.menuItems.last!
		XCTAssertEqual(lastItem.title, "300 g  Míchaný salát s vařeným vejcem,olivami a balkánským sýrem")
		XCTAssertEqual(lastItem.order, 5)
		XCTAssertEqual(lastItem.priceDescription, "145 Kč") // nbsp

		// restaurant without menu info "MacLaren's Pub"
		XCTAssertEqual(venues.last!.menuItems.count, 0)

		// restaurant with footer info
		XCTAssertEqual(venues[2].menuItems.count, 9)
		XCTAssertEqual(venues[2].menuItems[8].title, "K polednímu menu Vám nabízíme 0,3l Kofolu, nebo Rajec za 25,- Kč")
	}

	func testVenuesParsing_wrongStructure() {
		let parser = HTMLParser()
		let html = "HTML without proper structure"
		let venues = parser.venuesWithMenuItems(from: html)
		XCTAssertEqual(venues.count, 0)
	}

	func testVenuesParsing_notHTML() {
		let parser = HTMLParser()
		let html = ""
		let venues = parser.venuesWithMenuItems(from: html)
		XCTAssertEqual(venues.count, 0)
	}

	// MARK: - Private

	private func loadHTML(from file: String) -> String {
		let bundle = Bundle(for: type(of: self))
		let path = bundle.path(forResource: file, ofType: nil)!
		let html = try! String(contentsOfFile: path)
		return html
	}
}
