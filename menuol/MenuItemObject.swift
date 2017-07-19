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

	dynamic var title = ""
	dynamic var day = ""
	dynamic var order = 0
	dynamic var orderDescription = ""
	dynamic var priceDescription = ""

	// MARK: - Meta

	override static func primaryKey() -> String? {
		return nil
	}

	override static func indexedProperties() -> [String] {
		return ["order", "day"]
	}

}
