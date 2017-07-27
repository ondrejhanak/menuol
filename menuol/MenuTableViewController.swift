//
//  MenuTableViewController.swift
//  menuol
//
//  Created by Ondrej Hanak on 19/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit
import FSCalendar

private let kMenuItemCellIdentifier = "MenuItemCell"

final class MenuTableViewController: UITableViewController, FSCalendarDelegate {

	// MARK: - Properties

	var venue: VenueObject!
	private var items = [MenuItemObject]()
	private var date = Date()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.estimatedRowHeight = 65
//		self.calendar.select(date)
//		self.calendar.delegate = self
		self.loadData()
	}

	// MARK: - IBActions

	@IBAction func calendarTapped(_ sender: UIBarButtonItem) {
	}

	// MARK: - Private

	private func loadData() {
		self.title = DateFormatter.czechDateString(from: self.date)
		let day = DateFormatter.dateOnlyString(from: self.date)
		self.items = self.venue.menuItems(day: day)
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

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.0001 // removes extra footer
	}

	// MARK: – FSCalendarDelegate

	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		self.date = date
		self.loadData()
		self.tableView.reloadData()
	}

}
