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

	static var shared = VenueManager()

	private var realm: Realm!

	// MARK: - Public

	init() {
		self.realm = try! Realm()
	}

	func completeUpdate(date: Date, callback: @escaping (_ success: Bool) -> Void) {
		let day = DateFormatter.dateOnlyString(from: date)
		self.getVenuesHTML(day: day) { html in
			guard let html = html else {
				callback(false)
				return
			}
			let result = HTMLParser().venues(from: html, day: day)
			try! self.realm.write {
				for new in result {
					if let existing = self.find(slug: new.slug) {
						new.isFavorited = existing.isFavorited
						new.menuItems.append(objectsIn: existing.menuItems)
					}
					self.realm.add(new, update: true)
				}
			}
			callback(true)
		}
	}

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
			let items = HTMLParser().menuItems(from: html, slug: slug)
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

	private func getVenuesHTML(day: String, callback: @escaping (String?) -> Void) {
		let url = self.venuesURL(day: day)
		self.getHTML(url: url, callback: callback)
	}

	private func getMenuHTML(slug: String, callback: @escaping (String?) -> Void) {
		let url = self.menuURL(slug: slug)
		self.getHTML(url: url, callback: callback)
	}

	private func venuesURL(day: String) -> URL {
		let parts = day.components(separatedBy: "-")
		var urlString = "https://www.olomouc.cz/poledni-menu"
		urlString += "/" + parts[0]
		urlString += "/" + parts[1]
		urlString += "/" + parts[2]
		let url = URL(string: urlString)!
		return url
	}

	private func menuURL(slug: String) -> URL {
		let urlString = "https://www.olomouc.cz/poledni-menu/" + slug
		let url = URL(string: urlString)!
		return url
	}
	
}
