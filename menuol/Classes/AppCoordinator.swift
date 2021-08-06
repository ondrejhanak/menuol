//
//  AppCoordinator.swift
//  menuol
//
//  Created by Ondrej Hanak on 24/07/2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import UIKit

protocol VenuesViewControllerDelegate: AnyObject {
	func didSelect(venue: Venue)
}

final class AppCoordinator {
	private(set) var navigationController: UINavigationController
	private(set) var window: UIWindow?
	private let venueManager: VenueManager

	// MARK: - Lifecycle

	init(window: UIWindow?) {
		self.window = window
		self.navigationController = UINavigationController()
		self.venueManager = VenueManager()
		self.window?.rootViewController = self.navigationController
	}

	// MARK: - Public

	func start() {
		let vc = VenuesTableViewController(venueManager: self.venueManager)
		vc.coordinatorDelegate = self
		self.navigationController.pushViewController(vc, animated: false)
	}
}

// MARK: - VenuesViewControllerDelegate

extension AppCoordinator: VenuesViewControllerDelegate {
	func didSelect(venue: Venue) {
		let vc = MenuTableViewController(venue: venue, venueManager: self.venueManager)
		self.navigationController.pushViewController(vc, animated: true)
	}
}
