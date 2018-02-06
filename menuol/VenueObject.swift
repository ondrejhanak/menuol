//
//  VenueObject.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation

final class VenueObject: NSObject {
	var slug = ""
	@objc var name = ""
	var imageURL: URL?
	var menuTimeDescription: String?
	@objc var isFavorited = false
	
	var menuItems = [MenuItemObject]()
	
	func menuItems(for day: String) -> [MenuItemObject] {
		return self.menuItems.filter({ $0.day == day })
	}

}
