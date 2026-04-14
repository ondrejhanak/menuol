//
//  HTMLParser.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation
import Kanna

protocol HTMLParserType: Sendable {
	func venuesWithMenuItems(from string: String) -> [Venue]
}

struct HTMLParser: HTMLParserType {
	// MARK: - Public

	func venuesWithMenuItems(from string: String) -> [Venue] {
		guard let html = try? HTML(html: string, encoding: .utf8) else {
			return []
		}
		var result: [Venue] = []
		for element in html.css("#kmBox > div.restaurace") {
			if var venue = venue(from: element) {
				if let table = element.css("table").first {
					let appendix = element.css("table ~ p").first?.text
					venue.menuItems = menuItems(from: table, appendix: appendix)
				}
				result.append(venue)
			}
		}
		return result
	}

	// MARK: - Private

	private func venue(from element: XMLElement) -> Venue? {
		let slug = element["class"]?.components(separatedBy: " ").last
		let name = element.css("h3 > a").first?.text
		guard let slug, let name else { return nil }
		let address = element.css("p.restadresa").first?.text ?? ""
		let note = element.css("p.restPoznMim").first?.text ?? ""
		let imageURL = element.css("div.nazev-restaurace img").first?["src"].flatMap { URL(string: $0) }
		let menuTimeDescription = element.css("span.vydejmenu").first?.text
		let venue = Venue(
			slug: slug,
			name: name,
			imageURL: imageURL,
			menuTimeDescription: menuTimeDescription,
			address: address,
			note: note
		)
		return venue
	}

	private func menuItems(from element: XMLElement, appendix: String?) -> [MenuItem] {
		var result = [MenuItem]()
		let rows = element.css("tr")
		for (index, row) in rows.enumerated() {
			let columns = row.css("td")
			let title = columns[1].text ?? ""
			var priceDescription = ""
			if columns.count >= 3 {
				priceDescription = columns[2].text ?? ""
			}
			let menuItem = MenuItem(title: title, order: index, priceDescription: priceDescription)
			result.append(menuItem)
		}
		if let appendix {
			let menuItem = MenuItem(title: appendix, order: result.count, priceDescription: nil)
			result.append(menuItem)
		}
		return result
	}
}
