//
//  VenueManager.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation
import Result

private let kFavoriteVenuesKey = "kFavoriteVenuesKey"

final class VenueManager {

	struct VenueError: Error {
	}

	private var htmlFetcher = HTMLFetcher()
	private var htmlParser = HTMLParser()
	private var allVenues = [Venue]()
	private var favoriteVenues: [String] {
		get {
			return UserDefaults.standard.array(forKey: kFavoriteVenuesKey)?.compactMap({ String(describing: $0) }) ?? []
		}
		set {
			UserDefaults.standard.set(newValue, forKey: kFavoriteVenuesKey)
		}
	}

	// MARK: - Public

	/// Fetches list of venues along with menu for given day.
	func updateVenuesAndMenu(for date: Date, callback: ((Result<Void, VenueError>) -> Void)? = nil) {
		self.htmlFetcher.fetchVenueHTML(for: date) { result in
			switch result {
			case let .success(html):
				let result = self.htmlParser.venuesWithMenuItems(from: html)
				self.allVenues.removeAll()
				for new in result {
					new.isFavorited = self.favoriteVenues.contains(new.slug)
					self.allVenues.append(new)
				}
				if let callback = callback {
					callback(.success(()))
				}
			case .failure:
				if let callback = callback {
					callback(.failure(VenueError()))
				}
			}
		}
	}

	/// Fetchches whole week menu for given venue.
	func updateMenu(slug: String, callback: @escaping (_ success: Bool) -> Void) {
		guard let venue = self.find(slug: slug) else {
			callback(false)
			return
		}
		self.htmlFetcher.fetchMenuHTML(slug: slug) { result in
			switch result {
			case let .success(html):
				let items = self.htmlParser.menuItems(from: html, venueSlug: slug)
				venue.menuItems = items
				callback(true)
			case .failure:
				callback(false)
			}
		}
	}
	
	/// Finds venues partially matching given name.
	func find(name: String) -> [Venue] {
		let predicate = name == "" ? NSPredicate(format: "TRUEPREDICATE") : NSPredicate(format: "name CONTAINS[cd] %@", name)
		let result = self.allVenues.filter({ predicate.evaluate(with: $0) }).sorted {
			// sort by (isFavorited, name)
			if $0.isFavorited == $1.isFavorited {
				return $0.name.lowercased() < $1.name.lowercased()
			}
			return $0.isFavorited && !$1.isFavorited
		}
		return result
	}

	/// Toggles favorite state of given venue.
	func toggleFavorite(_ venue: Venue) {
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

	private func find(slug: String) -> Venue? {
		return self.allVenues.filter({ $0.slug == slug }).first
	}

}
