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
		self.getCompleteHTML(day: day) { html in
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

	func find(name: String) -> Results<VenueObject> {
		let favDescriptor = SortDescriptor(keyPath: "isFavorited", ascending: false)
		let nameDescriptor = SortDescriptor(keyPath: "name", ascending: true)
		return self.realm.objects(VenueObject.self).filter("name CONTAINS[cd] %@", name).sorted(by: [favDescriptor, nameDescriptor])
	}

	// MARK: - Private

	private func find(slug: String) -> VenueObject? {
		return self.realm.object(ofType: VenueObject.self, forPrimaryKey: slug)
	}

	private func getCompleteHTML(day: String, callback: @escaping (String?) -> Void) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let url = self.url(day: day)
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard error == nil, let data = data, let html = String(data: data, encoding: .utf8) else {
				callback(nil)
				return
			}
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			DispatchQueue.main.async {
				callback(html)
			}
		}
		task.resume()
	}

	private func url(day: String) -> URL {
		let parts = day.components(separatedBy: "-")
		var urlString = "http://www.olomouc.cz/poledni-menu"
		urlString = urlString + "/" + parts[0]
		urlString = urlString + "/" + parts[1]
		urlString = urlString + "/" + parts[2]
		let url = URL(string: urlString)!
		return url
	}
	
}
