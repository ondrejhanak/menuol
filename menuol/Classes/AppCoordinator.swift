//
//  AppCoordinator.swift
//  menuol
//
//  Created by Ondrej Hanak on 24/07/2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import UIKit

class AppCoordinator {
	private let navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "VenuesTableViewController")
		self.navigationController.pushViewController(vc, animated: false)
	}

}
