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
	struct VenueError: Error {}

	private var pageFetcher = PageFetcher()
	private var htmlParser = HTMLParser()
	private var allVenues = [Venue]()
	private var favoriteVenues: [String] {
		get {
			UserDefaults.standard.array(forKey: kFavoriteVenuesKey)?.compactMap { String(describing: $0) } ?? []
		}
		set {
			UserDefaults.standard.set(newValue, forKey: kFavoriteVenuesKey)
		}
	}

	// MARK: - Public

	/// Fetches list of venues along with menu.
	func fetchVenues(callback: ((Result<Void, VenueError>) -> Void)? = nil) {
		pageFetcher.fetchVenuePage { result in
			switch result {
			case let .success(html):
				let result = self.htmlParser.venuesWithMenuItems(from: html)
				self.allVenues.removeAll()
				for new in result {
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

	/// Finds venues partially matching given name.
	func find(name: String) -> [Venue] {
		var venues = allVenues
		if name.isEmpty == false {
			venues = venues.filter { $0.name.localizedCaseInsensitiveContains(name) }
		}
		let favourites = venues.map { isFavourited($0) }
		let pairs = zip(favourites, venues)
		let result = pairs.sorted { pair1, pair2 in
			// sort by (favourited, venue.name)
			if pair1.0 == pair2.0 {
				return pair1.1.name.lowercased() < pair2.1.name.lowercased()
			}
			return pair1.0 && !pair2.0
		}
		return result.map { $0.1 }
	}

	/// Toggles favorite state of given venue.
	func toggleFavorite(_ venue: Venue) {
		if let index = favoriteVenues.firstIndex(of: venue.slug) {
			favoriteVenues.remove(at: index)
		} else {
			favoriteVenues.append(venue.slug)
		}
	}

	func isFavourited(_ venue: Venue) -> Bool {
		favoriteVenues.contains(venue.slug)
	}
}
