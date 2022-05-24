//
//  HTMLParserTests.swift
//  unit tests
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
		XCTAssertEqual(venues.count, 155)

		// first venue details
		let venue = venues[0]
		XCTAssertEqual(venue.slug, "Blues-Rock-CAFE-id1207")
		XCTAssertEqual(venue.name, "Blues Rock CAFE")
		XCTAssertEqual(venue.imageURL, URL(string: "https://www.olomouc.cz/images/katalog/1207.gif"))
		XCTAssertEqual(venue.menuTimeDescription, "11:00 - 14:00")
		XCTAssertFalse(venue.isFavorited)

		// first venue menu items
		XCTAssertEqual(venue.menuItems.count, 6)
		XCTAssertEqual(venue.menuItems(for: "2018-08-23").count, 6)
		XCTAssertEqual(venue.menuItems(for: "2018-08-24").count, 0)

		// first menu item
		let firstItem = venue.menuItems.first!
		XCTAssertEqual(firstItem.title, "Kmínová s vejcem")
		XCTAssertEqual(firstItem.day, "2018-08-23")
		XCTAssertEqual(firstItem.order, 0)
		XCTAssertEqual(firstItem.priceDescription, "")

		// last menu item
		let lastItem = venue.menuItems.last!
		XCTAssertEqual(lastItem.title, "Těstovinový salát s kuřecím masem")
		XCTAssertEqual(lastItem.day, "2018-08-23")
		XCTAssertEqual(lastItem.order, 5)
		XCTAssertEqual(lastItem.priceDescription, "98 Kč") // hard space

		// restaurant without menu info
		XCTAssertEqual(venues[8].menuItems.count, 0)

		// restaurant witht footer info
		XCTAssertEqual(venues[4].menuItems.count, 6)
		XCTAssertEqual(venues[4].menuItems[5].title, "Eva a Vašek, KONCERT v sále u Sklenářů 12. října 2018")
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

	func testMenuParsingCorrect() {
		let parser = HTMLParser()
		let html = loadHTML(from: "Menu.html")
		let menuItems = parser.menuItems(from: html)

		XCTAssertEqual(menuItems.count, 12)

		// first menu item
		let firstItem = menuItems.first!
		XCTAssertEqual(firstItem.title, "Kmínová s vejcem")
		XCTAssertEqual(firstItem.day.suffix(5), "08-23")
		XCTAssertEqual(firstItem.order, 0)
		XCTAssertEqual(firstItem.priceDescription, "")

		// last menu item
		let lastItem = menuItems.last!
		XCTAssertEqual(lastItem.title, "Těstovinový salát s kuřecím masem")
		XCTAssertEqual(lastItem.day.suffix(5), "08-24")
		XCTAssertEqual(lastItem.order, 5)
		XCTAssertEqual(lastItem.priceDescription, "98 Kč") // hard space
	}

	// MARK: - Private

	private func loadHTML(from file: String) -> String {
		let bundle = Bundle(for: type(of: self))
		let path = bundle.path(forResource: file, ofType: nil)!
		let html = try! String(contentsOfFile: path)
		return html
	}
}
