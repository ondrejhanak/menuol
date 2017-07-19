//
//  VenuesTableViewController.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit

private let kVenueCellIdentifier = "VenueCell"
private let kMenuSegue = "MenuSegue"

final class VenuesTableViewController: UITableViewController {

	// MARK: - Properties

	private var venues = [VenueObject]()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		let url = Bundle.main.url(forResource: "menu.html", withExtension: nil)!
		let string = try! String(contentsOf: url)
		self.venues = HTMLParser().venues(from: string)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == kMenuSegue, let vc = segue.destination as? MenuTableViewController, let venue = sender as? VenueObject {
			vc.venue = venue
		}
	}

	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.venues.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: kVenueCellIdentifier, for: indexPath) as! VenueTableViewCell
		let venue = self.venues[indexPath.row]
		cell.setup(venue: venue)
		return cell
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let venue = self.venues[indexPath.row]
		self.performSegue(withIdentifier: kMenuSegue, sender: venue)
	}

}
