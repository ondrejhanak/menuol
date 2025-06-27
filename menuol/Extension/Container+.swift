//
//  Container+.swift
//  menuol
//
//  Created by Ondřej Hanák on 17.11.2024.
//  Copyright © 2024 Ondrej Hanak. All rights reserved.
//

import Factory
import Foundation

extension Container {
	var htmlParser: Factory<HTMLParserType> {
		self { HTMLParser() }
	}

	var httpClient: Factory<HTTPClientType> {
		self { HTTPClient() }
	}

	var favoriteSlugsStorage: Factory<StringStorage> {
		self { StringStorage(key: "FavoriteVenueSlugs") }
			.cached
	}

	@MainActor
	var appCoordinator: Factory<AppCoordinator> {
		self { @MainActor in AppCoordinator() }
			.singleton
	}

	var venueRepository: Factory<VenueRepository> {
		self { VenueRepository() }
			.cached
	}

	var geocoder: Factory<GeocoderType> {
		self { Geocoder() }
			.singleton
	}
}
