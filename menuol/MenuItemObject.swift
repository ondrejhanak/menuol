//
//  MenuItemObject.swift
//  menuol
//
//  Created by Ondrej Hanak on 19/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation
import RealmSwift

final class MenuItemObject: Object {

	// MARK: - Persistent properties

	@objc dynamic var pk = ""
	@objc dynamic var title = ""
	@objc dynamic var day = ""
	@objc dynamic var order = 0
	@objc dynamic var orderDescription = ""
	@objc dynamic var priceDescription = ""

	// MARK: - Meta

	override static func primaryKey() -> String? {
		return "pk"
	}

	override static func indexedProperties() -> [String] {
		return ["order", "day"]
	}

	// MARK: - Public

	func setPrimaryKey(venueSlug slug: String) {
		if self.realm == nil {
			self.pk = slug + "_" + day + "_" + String(self.order)
		}
	}

	override func isEqual(_ object: Any?) -> Bool {
		if let object = object as? MenuItemObject {
			return self.pk == object.pk
		}
		return false
	}

	override var hashValue: Int {
		return self.pk.hashValue
	}

}
