//
//  AppCoordinatorTests.swift
//  unit tests
//
//  Created by Ondřej Hanák on 23. 08. 2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

@testable import menuol
import XCTest

final class AppCoordinatorTests: XCTestCase {
	func testInit() {
		let window = UIWindow()
		let coordinator = AppCoordinator(window: window)
		XCTAssertEqual(coordinator.window, window)
		XCTAssertTrue(coordinator.window!.rootViewController is UINavigationController)
	}

	func testStart() {
		let coordinator = AppCoordinator(window: UIWindow())
		coordinator.start()
		let topVC = coordinator.navigationController.topViewController
		XCTAssertTrue(topVC is VenuesTableViewController)
	}
}
