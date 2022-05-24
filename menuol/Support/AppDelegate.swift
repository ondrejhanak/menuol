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

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		setupWindow()
		return true
	}

	// MARK: - Private

	private func setupWindow() {
		window = UIWindow()
		window?.makeKeyAndVisible()
		coordinator = AppCoordinator(window: window)
		coordinator?.start()
	}
}
