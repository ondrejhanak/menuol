//
//  AppCoordinator.swift
//  menuol
//
//  Created by Ondrej Hanak on 24/07/2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import UIKit

protocol VenuesViewControllerDelegate: class {
	func didSelect(venue: Venue)
}

final class AppCoordinator {
	internal let navigationController: UINavigationController
	internal var window: UIWindow?
	internal let venueManager = VenueManager()

	// MARK: - Lifecycle

	init(window: UIWindow?) {
		self.window = window
		self.navigationController = UINavigationController()
		self.window?.rootViewController = self.navigationController
	}

	// MARK: - Public

	func start() {
		let vc: VenuesTableViewController = VenuesTableViewController.instantiateFromStoryboard()
		vc.coordinatorDelegate = self
		vc.venueManager = self.venueManager
		self.navigationController.pushViewController(vc, animated: false)
	}
}

// MARK: - VenuesViewControllerDelegate

extension AppCoordinator: VenuesViewControllerDelegate {
	func didSelect(venue: Venue) {
		let vc: MenuTableViewController = MenuTableViewController.instantiateFromStoryboard()
		vc.venueManager = self.venueManager
		vc.venue = venue
		self.navigationController.pushViewController(vc, animated: true)
	}
}
