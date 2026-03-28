//
//  AppCoordinatorTests.swift
//  tests
//
//  Created by Ondrej Hanak on 27.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import SwiftUI
@testable import menuol
import Testing
import ViewInspector

@MainActor
struct AppCoordinatorTests {
	private func makeSUT() -> AppCoordinator {
		AppCoordinator(
			venueRepository: VenueRepository(httpClient: HTTPClientMock(), htmlParser: HTMLParserMock()),
			favoritesStorage: FavoritesStorageMock(),
			geocoder: GeocoderMock()
		)
	}

	@Test func startEmpty() {
		let sut = makeSUT()
		#expect(sut.path.isEmpty)
	}

	@Test func showMenu() {
		let sut = makeSUT()
		let venue = Venue.stubFilled
		let expectedPath = NavigationPath([AppRoute.menu(venue: venue)])
		#expect(sut.path != expectedPath)
		sut.showMenu(ofVenue: venue)
		#expect(sut.path == expectedPath)
	}

	@Test func viewTypes() throws {
		let sut = makeSUT()
		let venue = Venue.stubFilled

		let menuView = sut.view(forRoute: .menu(venue: venue))
		_ = try menuView.inspect().find(MenuListView.self)

		let venueView = sut.view(forRoute: .venues)
		_ = try venueView.inspect().find(VenueListView.self)
	}
}
