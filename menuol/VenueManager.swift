//
//  VenueManager.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation
import RealmSwift

final class VenueManager {

	private var realm: Realm!
	private var htmlFetcher = HTMLFetcher()

	// MARK: - Public

	init() {
		self.realm = try! Realm()
	}

	/// Fetches list of venues along with menu for given day.
	func updateVenuesAndMenu(for date: Date, callback: ((_ success: Bool) -> Void)? = nil) {
		self.htmlFetcher.getVenueHTML(for: date) { html in
			guard let html = html else {
				if let callback = callback {
					callback(false)
				}
				return
			}
			let result = HTMLParser().venuesWithMenuItems(from: html)
			try! self.realm.write {
				for new in result {
					if let existing = self.find(slug: new.slug) {
						new.isFavorited = existing.isFavorited
					}
					self.realm.add(new, update: true)
				}
			}
			if let callback = callback {
				callback(true)
			}
		}
	}

	/// Fetchches whole week menu for given venue.
	func updateMenu(slug: String, callback: @escaping (_ success: Bool) -> Void) {
		guard let venue = self.find(slug: slug) else {
			callback(false)
			return
		}
		self.htmlFetcher.getMenuHTML(slug: slug) { html in
			guard let html = html else {
				callback(false)
				return
			}
			let items = HTMLParser().menuItems(from: html, venueSlug: slug)
			try! self.realm.write {
				for item in items {
					if venue.menuItems.contains(item) {
						continue
					}
					venue.menuItems.append(item)
				}
			}
			callback(true)
		}
	}

	/// Finds venues partialy matching given name.
	func find(name: String) -> Results<VenueObject> {
		let favDescriptor = SortDescriptor(keyPath: "isFavorited", ascending: false)
		let nameDescriptor = SortDescriptor(keyPath: "name", ascending: true)
		let predicate = name == "" ? NSPredicate(format: "TRUEPREDICATE") : NSPredicate(format: "name CONTAINS[cd] %@", name)
		let result = self.realm.objects(VenueObject.self).filter(predicate).sorted(by: [favDescriptor, nameDescriptor])
		return result
	}

	// MARK: - Private

	private func find(slug: String) -> VenueObject? {
		return self.realm.object(ofType: VenueObject.self, forPrimaryKey: slug)
	}

}
