//
//  AppDelegate.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var coordinator: AppCoordinator?

	// MARK: - Lifecycle

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		self.setupWindowAndRootViewController()
		return true
	}

	// MARK: - Private

	private func setupWindowAndRootViewController() {
		self.window = UIWindow()
		let nc = UINavigationController()
		window?.rootViewController = nc
		self.coordinator = AppCoordinator(navigationController: nc)
		self.coordinator?.start()
		self.window?.makeKeyAndVisible()
	}

}
