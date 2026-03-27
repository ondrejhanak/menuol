//
//  MenuListViewModel.swift
//  menuol
//
//  Created by Ondrej Hanak on 24.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import Combine
import MapKit

@MainActor
final class MenuListViewModel: ObservableObject {
	let geocoder: GeocoderType
	@Published var mapRegion: MKCoordinateRegion?
	@Published var mapError: Error?
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
