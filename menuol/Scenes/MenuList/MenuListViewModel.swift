//
//  MenuListViewModel.swift
//  menuol
//
//  Created by Ondrej Hanak on 24.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import MapKit

@Observable
@MainActor
final class MenuListViewModel {
	let geocoder: GeocoderType
	var mapRegion: MKCoordinateRegion?
	var mapError: Error?
	let venue: Venue

	init(venue: Venue, geocoder: GeocoderType) {
		self.venue = venue
		self.geocoder = geocoder
	}

	func loadMapRegion() async {
		do {
			let coord = try await geocoder.coordinate(for: venue.address)
			mapRegion = MKCoordinateRegion(
				center: coord,
				span: .init(latitudeDelta: 0.0012, longitudeDelta: 0.0012)
			)
		} catch {
			self.mapError = error
		}
	}
}
