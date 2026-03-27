//
//  AppCoordinatorTests.swift
//  tests
//
//  Created by Ondrej Hanak on 27.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import SwiftUI
@testable import menuol
import XCTest
import ViewInspector

@MainActor
final class AppCoordinatorTests: XCTestCase {
	private func makeSUT() -> AppCoordinator {
		AppCoordinator(
			venueRepository: VenueRepository(httpClient: HTTPClientMock(), htmlParser: HTMLParserMock()),
			favoriteSlugsStorage: StringStorage(key: "Test"),
			geocoder: GeocoderMock()
		)
	}

	func test_startEmpty() {
		let sut = makeSUT()
		XCTAssertTrue(sut.path.isEmpty)
	}

	func test_showMenu() {
		let sut = makeSUT()
		let venue = Venue.stubFilled
		let expectedPath = NavigationPath([AppRoute.menu(venue: venue)])
		XCTAssertNotEqual(sut.path, expectedPath)
		sut.showMenu(ofVenue: venue)
		XCTAssertEqual(sut.path, expectedPath)
	}

	func test_viewTypes() throws {
		let sut = makeSUT()
		let venue = Venue.stubFilled

		let menuView = sut.view(forRoute: .menu(venue: venue))
		_ = try menuView.inspect().find(MenuListView.self)

		let venueView = sut.view(forRoute: .venues)
		_ = try venueView.inspect().find(VenueListView.self)
	}
}
