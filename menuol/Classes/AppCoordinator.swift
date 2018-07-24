//
//  AppCoordinator.swift
//  menuol
//
//  Created by Ondrej Hanak on 24/07/2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import UIKit

protocol VenuesViewControllerDelegate: class {
	func didSelect(venue: VenueObject)
}

final class AppCoordinator: VenuesViewControllerDelegate {
	private let navigationController: UINavigationController
	private let venueManager = VenueManager()

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "VenuesTableViewController") as! VenuesTableViewController
		vc.delegate = self
		vc.venueManager = self.venueManager
		self.navigationController.pushViewController(vc, animated: false)
	}

	func didSelect(venue: VenueObject) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as! MenuTableViewController
		vc.venueManager = self.venueManager
		vc.venue = venue
		self.navigationController.pushViewController(vc, animated: true)
	}

}
