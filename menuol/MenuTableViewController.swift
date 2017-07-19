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

	private var menuItems = [MenuItemObject]()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.menuItems.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: kMenuItemCellIdentifier, for: indexPath) as! MenuItemTableViewCell
		let menuItem = self.menuItems[indexPath.row]
		cell.setup(menuItem: menuItem)
		return cell
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

}
