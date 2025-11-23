//
//  Geocoder.swift
//  menuol
//
//  Created by Ondrej Hanak on 24.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import CoreLocation
import Foundation

protocol GeocoderType {
	func coordinate(for address: String) async throws -> CLLocationCoordinate2D
}

final actor Geocoder: GeocoderType {
	private let geocoder = CLGeocoder()
	private var cache: [String: CLLocationCoordinate2D] = [:]

	func coordinate(for address: String) async throws -> CLLocationCoordinate2D {
		if let cached = cache[address] {
			return cached
		}

		let placeMarks = try await geocodeAddressString(address)
		guard let location = placeMarks.first?.location else {
			throw CLError(.geocodeFoundNoResult)
		}

		let coord = location.coordinate
		cache[address] = coord
		return coord
	}

	private func geocodeAddressString(_ address: String) async throws -> [CLPlacemark] {
		try await withCheckedThrowingContinuation { continuation in
			geocoder.geocodeAddressString(address) { places, error in
				if let err = error {
					continuation.resume(throwing: err)
				} else {
					continuation.resume(returning: places ?? [])
				}
			}
		}
	}
}

final class GeocoderMock: GeocoderType {
	func coordinate(for address: String) async throws -> CLLocationCoordinate2D {
		.init(latitude: 49.5940214, longitude: 17.2514789)
	}
}
