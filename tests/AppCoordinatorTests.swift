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
	func test_startEmpty() {
		let sut = AppCoordinator()
		XCTAssertTrue(sut.path.isEmpty)
	}

	func test_showMenu() {
		let sut = AppCoordinator()
		let venue = Venue.stubFilled
		let expectedPath = NavigationPath([AppRoute.menu(venue: venue)])
		XCTAssertNotEqual(sut.path, expectedPath)
		sut.showMenu(ofVenue: venue)
		XCTAssertEqual(sut.path, expectedPath)
	}

	func test_viewTypes() throws {
		let sut = AppCoordinator()
		let venue = Venue.stubFilled

		let menuView = sut.view(forRoute: .menu(venue: venue))
		_ = try menuView.inspect().find(MenuListView.self)

		let venueView = sut.view(forRoute: .venues)
		_ = try venueView.inspect().find(VenueListView.self)
	}
}
