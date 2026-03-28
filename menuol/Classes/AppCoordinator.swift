//
//  AppCoordinator.swift
//  menuol
//
//  Created by Ondrej Hanak on 23.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import SwiftUI

enum AppRoute: Hashable {
	case venues
	case menu(venue: Venue)
}

@Observable
@MainActor
final class AppCoordinator {
	var path = NavigationPath()

	private let venueRepository: VenueRepository
	private let favoriteSlugsStorage: StringStorage
	private let geocoder: GeocoderType

	init(venueRepository: VenueRepository, favoriteSlugsStorage: StringStorage, geocoder: GeocoderType) {
		self.venueRepository = venueRepository
		self.favoriteSlugsStorage = favoriteSlugsStorage
		self.geocoder = geocoder
	}

	func showMenu(ofVenue venue: Venue) {
		path.append(AppRoute.menu(venue: venue))
	}

	@ViewBuilder
	func view(forRoute route: AppRoute) -> some View {
		switch route {
		case .venues:
			VenueListView(viewModel: VenueListViewModel(
				venueRepository: self.venueRepository,
				favoriteSlugsStorage: self.favoriteSlugsStorage,
				onShowMenu: { [weak self] venue in self?.showMenu(ofVenue: venue) }
			))
		case let .menu(venue):
			MenuListView(viewModel: MenuListViewModel(venue: venue, geocoder: self.geocoder))
		}
	}
}
