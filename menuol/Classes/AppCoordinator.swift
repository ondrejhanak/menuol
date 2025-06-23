//
//  AppCoordinator.swift
//  menuol
//
//  Created by Ondrej Hanak on 23.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import SwiftUI
import Combine

enum AppRoute: Hashable {
	case venues
	case menu(venue: Venue)
}

@MainActor
final class AppCoordinator: ObservableObject {
	@Published var path = NavigationPath()

	func showMenu(ofVenue venue: Venue) {
		path.append(AppRoute.menu(venue: venue))
	}

	@ViewBuilder
	func view(forRoute route: AppRoute) -> some View {
		switch route {
		case .venues:
			VenueListView(viewModel: .init())
		case .menu(let venue):
			MenuListView(venue: venue)
		}
	}
}
