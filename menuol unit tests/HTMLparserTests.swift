//
//  HTMLParserTests.swift
//  menuol unit tests
//
//  Created by Ondřej Hanák on 23. 08. 2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import XCTest
@testable import menuol

final class HTMLParserTests: XCTestCase {

	func testVenuesParsing_correct() {
		let parser = HTMLParser()
		let html = self.loadHTML(from: "Venues.html")

		// venues count
		let venues = parser.venuesWithMenuItems(from: html)
		XCTAssert(venues.count == 155)

		// first venue details
		let venue = venues[0]
		XCTAssert(venue.slug == "Blues-Rock-CAFE-id1207")
		XCTAssert(venue.name == "Blues Rock CAFE")
		XCTAssert(venue.imageURL == URL(string: "https://www.olomouc.cz/images/katalog/1207.gif"))
		XCTAssert(venue.menuTimeDescription == "11:00 - 14:00")
		XCTAssert(venue.isFavorited == false)

		// first venue menu items
		XCTAssert(venue.menuItems.count == 6)
		XCTAssert(venue.menuItems(for: "2018-08-23").count == 6)
		XCTAssert(venue.menuItems(for: "2018-08-24").count == 0)

		// first menu item
		let firstItem = venue.menuItems.first!
		XCTAssert(firstItem.title == "Kmínová s vejcem")
		XCTAssert(firstItem.day == "2018-08-23")
		XCTAssert(firstItem.order == 0)
		XCTAssert(firstItem.orderDescription == "")
		XCTAssert(firstItem.priceDescription == "")

		// last menu item
		let lastItem = venue.menuItems.last!
		XCTAssert(lastItem.title == "Těstovinový salát s kuřecím masem")
		XCTAssert(lastItem.day == "2018-08-23")
		XCTAssert(lastItem.order == 5)
		XCTAssert(lastItem.orderDescription == "5.")
		XCTAssert(lastItem.priceDescription == "98 Kč") // hard space

		// restaurant without menu info
		XCTAssert(venues[8].menuItems.count == 0)

		// restaurant witht footer info
		XCTAssert(venues[4].menuItems.count == 6)
		XCTAssert(venues[4].menuItems[5].title == "Eva a Vašek, KONCERT v sále u Sklenářů 12. října 2018")
	}

	func testVenuesParsing_wrongStructure() {
		let parser = HTMLParser()
		let html = "HTML without proper structure"
		let venues = parser.venuesWithMenuItems(from: html)
		XCTAssert(venues.count == 0)
	}

	func testVenuesParsing_notHTML() {
		let parser = HTMLParser()
		let html = ""
		let venues = parser.venuesWithMenuItems(from: html)
		XCTAssert(venues.count == 0)
	}

	func testMenuParsingCorrect() {
		let parser = HTMLParser()
		let html = self.loadHTML(from: "Menu.html")
		let menuItems = parser.menuItems(from: html)

		XCTAssert(menuItems.count == 12)

		// first menu item
		let firstItem = menuItems.first!
		XCTAssert(firstItem.title == "Kmínová s vejcem")
		XCTAssert(firstItem.day == "2018-08-23")
		XCTAssert(firstItem.order == 0)
		XCTAssert(firstItem.orderDescription == "")
		XCTAssert(firstItem.priceDescription == "")

		// last menu item
		let lastItem = menuItems.last!
		XCTAssert(lastItem.title == "Těstovinový salát s kuřecím masem")
		XCTAssert(lastItem.day == "2018-08-24")
		XCTAssert(lastItem.order == 5)
		XCTAssert(lastItem.orderDescription == "5.")
		XCTAssert(lastItem.priceDescription == "98 Kč") // hard space
	}

	// MARK: - Private

	private func loadHTML(from file: String) -> String {
		let bundle = Bundle(for: type(of: self))
		let path = bundle.path(forResource: file, ofType: nil)!
		let html = try! String(contentsOfFile: path)
		return html
	}

}
