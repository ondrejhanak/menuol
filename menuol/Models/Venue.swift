//
//  Venue.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation

final class Venue: NSObject {
	public var slug = ""
	public var name = ""
	public var imageURL: URL?
	public var menuTimeDescription: String?
	public var isFavorited = false

	public var menuItems = [MenuItem]()

	public func menuItems(for day: String) -> [MenuItem] {
		return self.menuItems.filter { $0.day == day }
	}
}
