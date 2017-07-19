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
	var result: Results<VenueObject>

	private var realm: Realm!

	init() {
		self.realm = try! Realm()
		self.result = self.realm.objects(VenueObject.self)

		// SHOWCASE
		try! realm.write {
			realm.deleteAll()
		}
	}

	func completeUpdate(day: String) {
		self.getCompleteHTML { html in
			guard let html = html else {
				// TODO: error
				return
			}
			let new = HTMLParser().venues(from: html, day: day)
			try! self.realm.write {
				self.realm.add(new, update: true)
			}
		}
	}

	func getCompleteHTML(callback: @escaping (String?) -> Void) {
		// SHOWCASE - get remote instead
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
			let url = Bundle.main.url(forResource: "menu.html", withExtension: nil)!
			let string = try! String(contentsOf: url)
			callback(string)
		}
	}
	
}
