//
//  AppDelegate.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		// Realm
		self.migrateRealmIfNeeded()

		// Fetch content
		//let today = Date().addingTimeInterval(1*24*3600)
		//VenueManager.shared.completeUpdate(date: today) { success in }

		return true
	}

	// MARK: - Private

	private func migrateRealmIfNeeded() {
		// From the doc:
		// Note that default property values aren’t applied to new objects during migrations.
		// We consider this to be a bug and are tracking it as [https://github.com/realm/realm-cocoa/issues/1793].

		let kLatestVersion: UInt64 = 1

		var config = Realm.Configuration.defaultConfiguration

		// No need to migrate
		if config.schemaVersion >= kLatestVersion {
			return
		}

		config.schemaVersion = kLatestVersion
		config.migrationBlock = { migration, oldSchemaVersion in
			// Realm will automatically add and remove properties
			// Content conversion stuff needs to be done manualy here
		}

		Realm.Configuration.defaultConfiguration = config

		// Opening the file will perform the migration
		_ = try! Realm()
	}
}

