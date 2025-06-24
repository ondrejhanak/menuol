//
//  Venue.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation

struct Venue: Identifiable, Hashable {
	var id: String {
		slug
	}

	var slug: String
	var name: String
	var imageURL: URL?
	var menuTimeDescription: String?
	var menuItems: [MenuItem] = []
}

extension Venue: Equatable {
	static func == (lhs: Venue, rhs: Venue) -> Bool {
		lhs.id == rhs.id
	}
}

extension Venue {
	static let demoVenueImage = Venue(
		slug: "image",
		name: "Venue + image",
		imageURL: URL(string: "https://picsum.photos/id/1060/200/150"),
		menuTimeDescription: nil,
		menuItems: MenuItem.demoItems
	)
	static let demoVenueNoImage = Venue(
		slug: "noimage",
		name: "Venue + description",
		imageURL: nil,
		menuTimeDescription: "time description",
		menuItems: []
	)
	static let demoItems = [Self.demoVenueImage, Self.demoVenueNoImage]
}
