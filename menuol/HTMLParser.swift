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

	func venues(from string: String) -> [VenueObject] {
		guard let doc = HTML(html: string, encoding: .utf8) else {
			return []
		}
		var result = [VenueObject]()
		for element in doc.xpath("//div[@id='kmBox']/div[contains(@class, 'restaurace')]") {
			if let venue = self.venue(from: element) {
				result.append(venue)
				venue.menuItems.append(objectsIn: self.menuItems(from: element))
			}
		}
		return result
	}

	// MARK: - Private

	private func venue(from element: XMLElement) -> VenueObject? {
		let slug = element["class"]?.components(separatedBy: " ").last
		let name = element.xpath(".//h3/a").first?.innerHTML
		let imageURLString = element.xpath("./div[@class='nazev-restaurace']//img").first?["src"]
		let menuTimeDescription = element.xpath(".//span[@class='vydejmenu']").first?.text
		guard slug != nil, name != nil else {
			return nil
		}
		let venue = VenueObject()
		venue.slug = slug!
		venue.name = name!
		venue.imageURLString = imageURLString ?? ""
		venue.menuTimeDescription = menuTimeDescription
		return venue
	}

	private func menuItems(from element: XMLElement) -> [MenuItemObject] {
		var result = [MenuItemObject]()
		let rows = element.xpath("./table//tr")
		for (index, row) in rows.enumerated() {
			let columns = row.xpath("td")
			let orderDescription = columns[0].text ?? ""
			let title = columns[1].text ?? ""
			var priceDescription = ""
			if columns.count >= 3 {
				priceDescription = columns[2].text ?? ""
			}
			let menuItem = MenuItemObject()
			menuItem.order = index
			menuItem.orderDescription = orderDescription
			menuItem.title = title
			menuItem.priceDescription = priceDescription
			result.append(menuItem)
		}
		return result
	}

}
