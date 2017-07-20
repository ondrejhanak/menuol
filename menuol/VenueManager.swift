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

	func completeUpdate(day: String, callback: @escaping (_ success: Bool) -> Void) {
		self.getCompleteHTML { html in
			guard let html = html else {
				callback(false)
				return
			}
			let result = HTMLParser().venues(from: html, day: day)
			try! self.realm.write {
				for new in result {
					if let existing = self.find(slug: new.slug) {
						new.isFavorited = existing.isFavorited
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

	private func getCompleteHTML(callback: @escaping (String?) -> Void) {
		// SHOWCASE - get remote instead
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
			let url = Bundle.main.url(forResource: "menu.html", withExtension: nil)!
			let string = try! String(contentsOf: url)
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
			callback(string)
		}
	}
	
}
