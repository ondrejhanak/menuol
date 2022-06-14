//
//  Venue.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation

struct Venue {
	var slug = ""
	var name = ""
	var imageURL: URL?
	var menuTimeDescription: String?
	var menuItems: [MenuItem] = []
}

extension Venue: Equatable {
	static func ==(lhs: Venue, rhs: Venue) -> Bool {
		lhs.slug == rhs.slug
	}
}
