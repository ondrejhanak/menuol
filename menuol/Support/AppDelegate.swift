//
//  AppDelegate.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var coordinator: AppCoordinator?

	// MARK: - Lifecycle

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		self.setupWindow()
		return true
	}

	// MARK: - Private

	private func setupWindow() {
		self.window = UIWindow()
		self.window?.makeKeyAndVisible()
		self.coordinator = AppCoordinator(window: self.window)
		self.coordinator?.start()
	}
}
