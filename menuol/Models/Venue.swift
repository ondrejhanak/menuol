//
//  Venue.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation

struct Venue: Hashable {
	var slug: String
	var name: String
	var imageURL: URL?
	var menuTimeDescription: String?
	var address: String
	var menuItems: [MenuItem] = []
}

extension Venue: Identifiable {
	var id: String {
		slug
	}
}

extension Venue: Equatable {
	static func == (lhs: Venue, rhs: Venue) -> Bool {
		lhs.slug == rhs.slug
	}
}

extension Venue {
	static let demoVenueImage = Venue(
		slug: "image",
		name: "Venue + image",
		imageURL: URL(string: "https://picsum.photos/id/1060/200/150"),
		menuTimeDescription: nil,
		address: "Some Nice Place",
		menuItems: MenuItem.demoItems
	)
	static let demoVenueNoImage = Venue(
		slug: "noimage",
		name: "Venue + description",
		imageURL: nil,
		menuTimeDescription: "time description",
		address: "",
		menuItems: []
	)
	static let demoItems = [Self.demoVenueImage, Self.demoVenueNoImage]
}
