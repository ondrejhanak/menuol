//
//  Venue.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation

final class Venue: NSObject {
	var slug = ""
	var name = ""
	var imageURL: URL?
	var menuTimeDescription: String?
	var isFavorited = false
	var menuItems = [MenuItem]()

	func menuItems(for day: String) -> [MenuItem] {
		menuItems.filter { $0.day == day }
	}
}
