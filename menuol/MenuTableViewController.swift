//
//  MenuTableViewController.swift
//  menuol
//
//  Created by Ondrej Hanak on 19/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit
import STPopup

private let kMenuItemCellIdentifier = "MenuItemCell"

final class MenuTableViewController: UITableViewController {

	// MARK: - Properties

	var venue: VenueObject!
	private var items = [MenuItemObject]()
	private var date = Date()
	private var didTryFetch = false
	private var venueManager = VenueManager()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUI()
		self.loadData()
	}

	// MARK: - IBActions

	@IBAction func calendarTapped(_ sender: UIBarButtonItem) {
		let vc = CalendarViewController()
		vc.date = self.date
		vc.callback = { date in
			self.date = date
			self.loadData()
		}
		let padding: CGFloat = 10
		let size = self.view.bounds.size.width - 2 * padding
		vc.contentSizeInPopup = CGSize(width: size, height: size)
		let popupController = STPopupController(rootViewController: vc)
		popupController.containerView.layer.cornerRadius = 8
		popupController.hidesCloseButton = false
		popupController.style = .formSheet
		popupController.present(in: self)
	}

	// MARK: - Private

	private func setupUI() {
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.estimatedRowHeight = 65
	}

	private func loadData() {
		self.title = DateFormatter.czechDateString(from: self.date).capitalizingFirstLetter()
		let day = DateFormatter.dateOnlyString(from: self.date)
		self.items = self.venue.menuItems(for: day)
		if self.items.isEmpty && !self.didTryFetch {
			self.venueManager.updateMenu(slug: self.venue.slug) { success in
				self.didTryFetch = true
				self.loadData()
			}
			self.tableView.reloadData()
		} else {
			self.tableView.reloadData()
		}
	}

	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.items.isEmpty ? 1 : self.items.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: kMenuItemCellIdentifier, for: indexPath) as! MenuItemTableViewCell
		if self.items.isEmpty {
			cell.setupAsNoDataCell()
		} else {
			let menuItem = self.items[indexPath.row]
			cell.setup(menuItem: menuItem)
		}
		return cell
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.0001 // removes extra footer
	}

}
