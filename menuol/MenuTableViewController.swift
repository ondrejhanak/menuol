//
//  MenuTableViewController.swift
//  menuol
//
//  Created by Ondrej Hanak on 19/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit

private let kMenuItemCellIdentifier = "MenuItemCell"

final class MenuTableViewController: UITableViewController {

	// MARK: - Properties

	var venue: VenueObject!
	private var items: [MenuItemObject]!

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = self.venue.name
		let day = DateFormatter.dateOnlyString(from: Date()) // SHOWCASE
		self.items = self.venue.menuItems(day: day)
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.estimatedRowHeight = 65
	}

	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.items.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: kMenuItemCellIdentifier, for: indexPath) as! MenuItemTableViewCell
		let menuItem = self.items[indexPath.row]
		cell.setup(menuItem: menuItem)
		return cell
	}

}
