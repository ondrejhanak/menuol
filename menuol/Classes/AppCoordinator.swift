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
	private let navigationController: UINavigationController
	private var window: UIWindow?
	private let venueManager = VenueManager()

	// MARK: - Lifecycle

	init(window: UIWindow?) {
		self.window = window
		self.navigationController = UINavigationController()
		self.window?.rootViewController = self.navigationController
	}

	// MARK: - Public

	func start() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "VenuesTableViewController") as! VenuesTableViewController
		vc.coordinatorDelegate = self
		vc.venueManager = self.venueManager
		self.navigationController.pushViewController(vc, animated: false)
	}

}

// MARK: - VenuesViewControllerDelegate

extension AppCoordinator: VenuesViewControllerDelegate {
	func didSelect(venue: Venue) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as! MenuTableViewController
		vc.venueManager = self.venueManager
		vc.venue = venue
		self.navigationController.pushViewController(vc, animated: true)
	}

}
