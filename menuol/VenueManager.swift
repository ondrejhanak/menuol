//
//  VenueManager.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation

private let kFavoriteVenuesKey = "kFavoriteVenuesKey"

final class VenueManager {

	private var htmlFetcher = HTMLFetcher()
	private var allVenues = [VenueObject]()
	private var favoriteVenues: [String] {
		get {
			return UserDefaults.standard.array(forKey: kFavoriteVenuesKey)?.flatMap({ String(describing: $0) }) ?? []
		}
		set {
			UserDefaults.standard.set(newValue, forKey: kFavoriteVenuesKey)
		}
	}

	// MARK: - Public

	/// Fetches list of venues along with menu for given day.
	func updateVenuesAndMenu(for date: Date, callback: ((_ success: Bool) -> Void)? = nil) {
		self.htmlFetcher.getVenueHTML(for: date) { html in
			guard let html = html else {
				if let callback = callback {
					callback(false)
				}
				return
			}
			let result = HTMLParser().venuesWithMenuItems(from: html)
			self.allVenues.removeAll()
			// TODO: load favorite slugs from user defaults

			for new in result {
				new.isFavorited = self.favoriteVenues.contains(new.slug)
				self.allVenues.append(new)
			}
			if let callback = callback {
				callback(true)
			}
		}
	}

	/// Fetchches whole week menu for given venue.
	func updateMenu(slug: String, callback: @escaping (_ success: Bool) -> Void) {
		guard let venue = self.find(slug: slug) else {
			callback(false)
			return
		}
		self.htmlFetcher.getMenuHTML(slug: slug) { html in
			guard let html = html else {
				callback(false)
				return
			}
			let items = HTMLParser().menuItems(from: html, venueSlug: slug)
			venue.menuItems = items
			callback(true)
		}
	}
	
	/// Finds venues partially matching given name.
	func find(name: String) -> [VenueObject] {
		let favDescriptor = NSSortDescriptor(key: "isFavorited", ascending: false)
		let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
		let predicate = name == "" ? NSPredicate(format: "TRUEPREDICATE") : NSPredicate(format: "name CONTAINS[cd] %@", name)
		let result = self.allVenues.filter({ predicate.evaluate(with: $0) }).sorted(by: [favDescriptor, nameDescriptor])
		return result
	}

	/// Toggles favorite state of given venue.
	func toggleFavorite(_ venue: VenueObject) {
		if venue.isFavorited {
			venue.isFavorited = false
			if let index = favoriteVenues.index(of: venue.slug) {
				self.favoriteVenues.remove(at: index)
			}
		} else {
			venue.isFavorited = true
			self.favoriteVenues.append(venue.slug)
		}
	}
	
	// MARK: - Private

	private func find(slug: String) -> VenueObject? {
		return self.allVenues.filter({ $0.slug == slug }).first
	}

}
