//
//  Venue.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation

struct Venue: Identifiable {
	var id: String {
		slug
	}

	var slug = ""
	var name = ""
	var imageURL: URL?
	var menuTimeDescription: String?
	var menuItems: [MenuItem] = []
	var isFavorited = false
}

extension Venue: Equatable {
	static func == (lhs: Venue, rhs: Venue) -> Bool {
		lhs.slug == rhs.slug
	}
}

extension Venue {
	static var demoVenueImage = Venue(slug: "image", name: "Venue + image", imageURL: URL(string: "https://picsum.photos/id/1060/200/150"), menuTimeDescription: nil, menuItems: MenuItem.demoItems)
	static var demoVenueNoImage = Venue(slug: "noimage", name: "Venue + description", imageURL: nil, menuTimeDescription: "time description", menuItems: [])
	static var demoItems = [Self.demoVenueImage, Self.demoVenueNoImage]
}
