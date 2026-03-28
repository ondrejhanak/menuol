//
//  MockGeocoder.swift
//  tests
//
//  Created by Ondrej Hanak on 28.03.2026.
//  Copyright © 2026 Ondrej Hanak. All rights reserved.
//

import CoreLocation
@testable import menuol

struct MockGeocoder: GeocoderType {
	func coordinate(for address: String) async throws -> CLLocationCoordinate2D {
		.init(latitude: 49.5940214, longitude: 17.2514789)
	}
}
