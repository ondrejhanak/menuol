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

	func venues(from string: String, day: String) -> [VenueObject] {
		guard let doc = HTML(html: string, encoding: .utf8) else {
			return []
		}
		var result = [VenueObject]()
		for element in doc.xpath("//div[@id='kmBox']/div[contains(@class, 'restaurace')]") {
			if let venue = self.venue(from: element) {
				result.append(venue)
				if let table = element.xpath("./table").first {
					venue.menuItems.append(objectsIn: self.menuItems(from: table, day: day, venueSlug: venue.slug))
				}
			}
		}
		return result
	}

	func menuItems(from string: String, slug: String) -> [MenuItemObject] {
		guard let doc = HTML(html: string, encoding: .utf8) else {
			return []
		}
		var result = [MenuItemObject]()
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "cs_CZ")
		formatter.dateFormat = "EEEE d. M."
		for header in doc.xpath("//section[@class='detail-restaurace']//h3") {
			if let dateString = header.text, let date = formatter.date(from: dateString) {
				let year = Calendar.current.dateComponents([.year], from: Date()).year
				var components = Calendar.current.dateComponents([.day, .month], from: date)
				components.year = year
				let date = Calendar.current.date(from: components)!
				let day = DateFormatter.dateOnlyString(from: date)
				if let table = header.xpath("following-sibling::table").first {
					let items = self.menuItems(from: table, day: day, venueSlug: slug)
					result.append(contentsOf: items)
				}
			}
		}
		return result
	}

	// MARK: - Private

	private func venue(from element: XMLElement) -> VenueObject? {
		let slug = element["class"]?.components(separatedBy: " ").last
		let name = element.xpath(".//h3/a").first?.text
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

	private func menuItems(from element: XMLElement, day: String, venueSlug slug: String) -> [MenuItemObject] {
		var result = [MenuItemObject]()
		let rows = element.xpath(".//tr")
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
			menuItem.day = day
			menuItem.setPrimaryKey(venueSlug: slug)
			result.append(menuItem)
		}
		if let appendix = element.xpath("following-sibling::p").first?.text {
			let menuItem = MenuItemObject()
			menuItem.order = result.count
			menuItem.title = appendix
			menuItem.day = day
			menuItem.setPrimaryKey(venueSlug: slug)
			result.append(menuItem)
		}
		return result
	}

}
