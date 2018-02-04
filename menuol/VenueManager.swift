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

	// MARK: - Public

	init() {
		self.realm = try! Realm()
	}

	/// Fetches list of venues along with menu for given day.
	func updateVenuesAndMenu(for date: Date, callback: ((_ success: Bool) -> Void)? = nil) {
		self.getVenueHTML(for: date) { html in
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
		self.getMenuHTML(slug: slug) { html in
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

	private func getHTML(url: URL, callback: @escaping (String?) -> Void) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard error == nil, let data = data, let html = String(data: data, encoding: .utf8) else {
				callback(nil)
				return
			}
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				callback(html)
			}
		}
		task.resume()
	}

	private func getVenueHTML(for date: Date, callback: @escaping (String?) -> Void) {
		let url = self.venueURL(date: date)
		self.getHTML(url: url, callback: callback)
	}

	private func getMenuHTML(slug: String, callback: @escaping (String?) -> Void) {
		let url = self.venueMenuURL(slug: slug)
		self.getHTML(url: url, callback: callback)
	}

	private func venueURL(date: Date) -> URL {
		let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
		let year = components.year!
		let month = components.month!
		let day = components.day!
		let urlString = "https://www.olomouc.cz/poledni-menu/\(year)/\(month)/\(day)"
		let url = URL(string: urlString)!
		return url
	}

	private func venueMenuURL(slug: String) -> URL {
		let urlString = "https://www.olomouc.cz/poledni-menu/" + slug
		let url = URL(string: urlString)!
		return url
	}
	
}
