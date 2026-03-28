//
//  AppView.swift
//  menuol
//
//  Created by Ondrej Hanak on 23.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import SwiftUI

struct AppView: View {
	@State private var coordinator = AppCoordinator(
		venueRepository: VenueRepository(httpClient: HTTPClient(), htmlParser: HTMLParser()),
		favoritesStorage: FavoritesStorage(userDefaults: UserDefaults.standard),
		geocoder: Geocoder()
	)

	var body: some View {
		@Bindable var coordinator = coordinator
		NavigationStack(path: $coordinator.path) {
			coordinator.view(forRoute: .venues)
				.navigationDestination(for: AppRoute.self) { route in
					coordinator.view(forRoute: route)
				}
		}
		.tint(.accent)
	}
}
