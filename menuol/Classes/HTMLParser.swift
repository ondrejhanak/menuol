//
//  HTMLParser.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation
import Kanna

final class HTMLParser {
	// MARK: - Public

	func venuesWithMenuItems(from string: String) -> [Venue] {
		guard let html = try? HTML(html: string, encoding: .utf8) else {
			return []
		}
		var result: [Venue] = []
		for element in html.xpath("//div[@id='kmBox']/div[contains(@class, 'restaurace')]") {
			if var venue = venue(from: element) {
				if let table = element.xpath("./table").first {
					venue.menuItems = menuItems(from: table)
				}
				result.append(venue)
			}
		}
		return result
	}

	// MARK: - Private

	private func venue(from element: XMLElement) -> Venue? {
		let slug = element["class"]?.components(separatedBy: " ").last
		let name = element.xpath(".//h3/a").first?.text
		let menuTimeDescription = element.xpath(".//span[@class='vydejmenu']").first?.text
		guard slug != nil, name != nil else { return nil }
		var venue = Venue()
		venue.slug = slug!
		venue.name = name!
		if let imageURLString = element.xpath("./div[@class='nazev-restaurace']//img").first?["src"] {
			venue.imageURL = URL(string: imageURLString)
		}
		venue.menuTimeDescription = menuTimeDescription
		return venue
	}

	private func menuItems(from element: XMLElement) -> [MenuItem] {
		var result = [MenuItem]()
		let rows = element.xpath(".//tr")
		for (index, row) in rows.enumerated() {
			let columns = row.xpath("td")
			let title = columns[1].text ?? ""
			var priceDescription = ""
			if columns.count >= 3 {
				priceDescription = columns[2].text ?? ""
			}
			let menuItem = MenuItem(title: title, order: index, priceDescription: priceDescription)
			result.append(menuItem)
		}
		if let appendix = element.xpath("following-sibling::p").first?.text {
			let menuItem = MenuItem(title: appendix, order: result.count, priceDescription: nil)
			result.append(menuItem)
		}
		return result
	}
}
