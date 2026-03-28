//
//  Preview.swift
//  menuol
//
//  Created by Ondrej Hanak on 28.03.2026.
//  Copyright © 2026 Ondrej Hanak. All rights reserved.
//

import CoreLocation
import Foundation

#if DEBUG
enum Preview {
	struct MockHTTPClient: HTTPClientType {
		func get(url: URL) async throws -> String {
			""
		}
	}

	struct MockHTMLParser: HTMLParserType {
		func venuesWithMenuItems(from string: String) -> [Venue] {
			Venue.demoItems
		}
	}

	struct MockGeocoder: GeocoderType {
		func coordinate(for address: String) async throws -> CLLocationCoordinate2D {
			.init(latitude: 49.5940214, longitude: 17.2514789)
		}
	}

	final class MockUserDefaults: UserDefaultsType {
		private var storage: [String: Any] = [:]

		func set(_ value: Any?, forKey defaultName: String) {
			storage[defaultName] = value
		}

		func array(forKey defaultName: String) -> [Any]? {
			storage[defaultName] as? [Any]
		}
	}
}
#endif
