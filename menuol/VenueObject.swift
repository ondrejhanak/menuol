//
//  VenueObject.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation
import RealmSwift

final class VenueObject: Object {

	// MARK: - Persistent properties

	dynamic var slug = ""
	dynamic var name = ""
	dynamic var imageURLString = ""
	dynamic var menuTimeDescription: String?
	dynamic var isHidden = false
	dynamic var isFavorited = false

	let menuItems = List<MenuItemObject>()

	// MARK: - Derived properies

	var imageURL: URL? {
		return URL(string: self.imageURLString)
	}

	func menuItems(day: String) -> [MenuItemObject] {
		return Array(self.menuItems.filter("day == %@", day))
	}

	// MARK: - Meta

	override static func primaryKey() -> String? {
		return "slug"
	}

	override static func indexedProperties() -> [String] {
		return ["name"]
	}

}
