//
//  AppCoordinator.swift
//  menuol
//
//  Created by Ondrej Hanak on 24/07/2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import UIKit

final class AppCoordinator {
	private(set) var navigationController: UINavigationController
	private(set) var window: UIWindow?
	private let venueManager: VenueManager

	// MARK: - Lifecycle

	init(window: UIWindow?) {
		self.window = window
		navigationController = UINavigationController()
		venueManager = VenueManager()
		self.window?.rootViewController = navigationController
	}

	// MARK: - Public

	func start() {
		let vc = VenuesTableViewController(venueManager: venueManager)
		vc.coordinatorDelegate = self
		navigationController.pushViewController(vc, animated: false)
	}
}

// MARK: - VenuesViewControllerDelegate

extension AppCoordinator: VenuesViewControllerDelegate {
	func didSelect(venue: Venue) {
		let vc = MenuTableViewController(venue: venue, venueManager: venueManager)
		navigationController.pushViewController(vc, animated: true)
	}
}
