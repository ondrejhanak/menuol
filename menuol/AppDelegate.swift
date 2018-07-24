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

	// MARK: - Lifecycle

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		self.setWindowAndRootViewController()
		return true
	}

	// MARK: - Private

	private func setWindowAndRootViewController() {
		self.window = UIWindow()
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let root = storyboard.instantiateInitialViewController()
		window?.rootViewController = root
		self.window?.makeKeyAndVisible()
	}

}
