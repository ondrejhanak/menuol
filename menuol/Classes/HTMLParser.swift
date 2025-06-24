//
//  HTMLParser.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation
import Kanna

protocol HTMLParserType {
	func venuesWithMenuItems(from string: String) -> [Venue]
}

final class HTMLParser: HTMLParserType {
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
		guard let slug, let name else { return nil }
		let address = element.xpath(".//p[@class='restadresa']").first?.text ?? ""
		let imageURL = element.xpath("./div[@class='nazev-restaurace']//img").first?["src"].flatMap { URL(string: $0) }
		let menuTimeDescription = element.xpath(".//span[@class='vydejmenu']").first?.text
		let venue = Venue(slug: slug, name: name, imageURL: imageURL, menuTimeDescription: menuTimeDescription, address: address)
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

final class HTMLParserMock: HTMLParserType {
	func venuesWithMenuItems(from string: String) -> [Venue] {
		Venue.demoItems
	}
}
