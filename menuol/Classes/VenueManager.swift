//
//  VenueManager.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation

@MainActor
final class VenueManager: ObservableObject {
	private var httpClient: HTTPClient
	private var htmlParser: HTMLParser
	private var parsedVenues: [Venue] = []
	private var searchPhrase = ""
	private var favoriteVenueSlugs = StringStorage(key: "FavoriteVenueSlugs")
	@Published var visibleVenues: [Venue] = []
	@Published var isLoading = false

	// MARK: - Lifecycle

	init(httpClient: HTTPClient, htmlParser: HTMLParser) {
		self.httpClient = httpClient
		self.htmlParser = htmlParser
	}

	// MARK: - Public

	/// Fetches list of venues along with menu.
	func fetchVenues() async throws {
		isLoading = true
		let url = URL(string: "https://www.olomouc.cz/poledni-menu")!
		let html = try await httpClient.get(url: url)
		parsedVenues = htmlParser.venuesWithMenuItems(from: html)
		updateVisibleVenues()
		isLoading = false
	}

	func applySearchPhrase(_ phrase: String) {
		searchPhrase = phrase
		updateVisibleVenues()
	}

	/// Toggles favorite state of given venue.
	func toggleFavorite(_ venue: Venue) {
		if isFavourited(venue) {
			favoriteVenueSlugs.remove(venue.slug)
		} else {
			favoriteVenueSlugs.save(venue.slug)
		}
		updateVisibleVenues()
	}

	// MARK: - Private

	private func isFavourited(_ venue: Venue) -> Bool {
		favoriteVenueSlugs.contains(venue.slug)
	}

	private func updateVisibleVenues() {
		let filteredVenues = parsedVenues.filter { venue in
			searchPhrase.isEmpty || venue.name.localizedStandardContains(searchPhrase)
		}
		let processedVenues = filteredVenues.map { venue in
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
