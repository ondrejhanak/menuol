//
//  HTMLParserTests.swift
//  tests
//
//  Created by Ondřej Hanák on 23. 08. 2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import Foundation
@testable import menuol
import Testing

final class HTMLParserTests {
	@Test(arguments: ["", "HTML without proper structure"])
	func venues_invalidInput(_ html: String) {
		let venues = HTMLParser().venuesWithMenuItems(from: html)
		#expect(venues.isEmpty)
	}

	@Test func venues_validInput() throws {
		let parser = HTMLParser()
		let html = try loadHTML(from: "Venues.html")

		// venues count
		let venues = parser.venuesWithMenuItems(from: html)
		#expect(venues.count == 107)

		// first venue details
		let venue = venues[0]
		#expect(venue.slug == "Blues-Rock-CAFE-id1207")
		#expect(venue.name == "Blues Rock CAFE")
		#expect(venue.imageURL == URL(string: "https://www.olomouc.cz/images/katalog/1207.gif"))
		#expect(venue.menuTimeDescription == "11:00 - 14:00")
		#expect(venue.address == "Bořivojova 1, 772 00 Olomouc")
		#expect(venue.note == "Testovaci poznamka.")

		// first venue menu items
		#expect(venue.menuItems.count == 6)

		// first menu item
		let firstItem = venue.menuItems.first!
		#expect(firstItem.title == "0,33 l Špenátová")
		#expect(firstItem.order == 0)
		#expect(firstItem.priceDescription == "25\u{00A0}Kč") // nbsp

		// last menu item
		let lastItem = venue.menuItems.last!
		#expect(lastItem.title == "300 g  Míchaný salát s vařeným vejcem,olivami a balkánským sýrem")
		#expect(lastItem.order == 5)
		#expect(lastItem.priceDescription == "145\u{00A0}Kč") // nbsp

		// restaurant without menu info "MacLaren's Pub"
		#expect(venues.last?.menuItems.count == 0)

		// restaurant with footer info
		#expect(venues[2].menuItems.count == 9)
		#expect(venues[2].menuItems[8].title == "K polednímu menu Vám nabízíme 0,3l Kofolu, nebo Rajec za 25,- Kč")
		#expect(venues[2].menuItems[8].priceDescription == nil)
	}

	@Test func venueWithoutName_isExcluded() {
		let parser = HTMLParser()
		let html = """
		<div id="kmBox">
		  <div class="restaurace NoNameVenue-id1">
		    <div class="nazev-restaurace"><h3></h3></div>
		  </div>
		</div>
		"""
		let venues = parser.venuesWithMenuItems(from: html)
		#expect(venues.isEmpty)
	}

	@Test func venueWithoutImage_hasNilImageURL() throws {
		let parser = HTMLParser()
		let html = """
		<div id="kmBox">
		  <div class="restaurace NoImage-id1">
		    <div class="nazev-restaurace"><h3><a>No Image Restaurant</a></h3></div>
		  </div>
		</div>
		"""
		let venue = try #require(parser.venuesWithMenuItems(from: html).first)
		#expect(venue.imageURL == nil)
	}

	@Test func venueWithoutMenuTime_hasNilMenuTimeDescription() throws {
		let parser = HTMLParser()
		let html = """
		<div id="kmBox">
		  <div class="restaurace NoTime-id1">
		    <div class="nazev-restaurace"><h3><a>No Time Restaurant</a></h3></div>
		  </div>
		</div>
		"""
		let venue = try #require(parser.venuesWithMenuItems(from: html).first)
		#expect(venue.menuTimeDescription == nil)
	}

	@Test func menuItemWithTwoColumns_hasEmptyPriceDescription() throws {
		let parser = HTMLParser()
		let html = """
		<div id="kmBox">
		  <div class="restaurace TwoCol-id1">
		    <div class="nazev-restaurace"><h3><a>Test Restaurant</a></h3></div>
		    <table><tr><td>1</td><td>Soup of the day</td></tr></table>
		  </div>
		</div>
		"""
		let venue = try #require(parser.venuesWithMenuItems(from: html).first)
		let item = try #require(venue.menuItems.first)
		#expect(item.title == "Soup of the day")
		#expect(item.priceDescription == "")
	}

	// MARK: - Private

	private func loadHTML(from file: String) throws -> String{
		let bundle = Bundle(for: type(of: self))
		let path = bundle.path(forResource: file, ofType: nil)!
		let html = try String(contentsOfFile: path)
		return html
	}
}
