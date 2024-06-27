//
//  VenueManager.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation

private let kFavoriteVenuesKey = "kFavoriteVenuesKey"

@MainActor
final class VenueManager: ObservableObject {
	private var httpClient = HTTPClient()
	private var htmlParser = HTMLParser()
	private var parsedVenues: [Venue] = []
	@Published var visibleVenues: [Venue] = []
	@Published var isLoading = false

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
	func fetchVenues() async throws {
		isLoading = true
		let html = try await httpClient.getVenuesPage()
		parsedVenues = self.htmlParser.venuesWithMenuItems(from: html)
		updateVisibleVenues()
		isLoading = false
	}

	/// Finds venues partially matching given name.
	func find(name: String) -> [Venue] {
		var venues = visibleVenues
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
		updateVisibleVenues()
	}

	// MARK: - Private

	private func isFavourited(_ venue: Venue) -> Bool {
		favoriteVenues.contains(venue.slug)
	}

	private func updateVisibleVenues() {
		let processedVenues = parsedVenues.map { venue in
			var newVenue = venue
			newVenue.isFavorited = isFavourited(venue)
			return newVenue
		}
		let sortedVenues = processedVenues.sorted { v1, v2 in
			if v1.isFavorited == v2.isFavorited {
				return v1.name < v2.name
			}
			return v1.isFavorited
		}
		visibleVenues = sortedVenues
	}
}
