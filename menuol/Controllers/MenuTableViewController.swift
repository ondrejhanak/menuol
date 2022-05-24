//
//  MenuTableViewController.swift
//  menuol
//
//  Created by Ondrej Hanak on 19/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit

final class MenuTableViewController: UITableViewController {
	var venue: Venue
	private var venueManager: VenueManager
	private var items: [MenuItem] = []
	private var date = Date()
	private var didTryFetch = false

	// MARK: - Lifecycle

	init(venue: Venue, venueManager: VenueManager) {
		self.venue = venue
		self.venueManager = venueManager
		super.init(style: .grouped)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUI()
		self.loadData()
	}

	// MARK: - Private

	private func setupUI() {
		self.navigationItem.largeTitleDisplayMode = .never
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = 65
		self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
		self.tableView.register(MenuItemTableViewCell.self, forCellReuseIdentifier: MenuItemTableViewCell.reuseIdentifier)
	}

	private func loadData() {
		self.title = DateFormatter.czechDateString(from: self.date).capitalizingFirstLetter()
		let day = DateFormatter.dateOnlyString(from: self.date)
		self.items = self.venue.menuItems(for: day)
		if self.items.isEmpty, !self.didTryFetch {
			self.venueManager.updateMenu(slug: self.venue.slug) { success in
				if success {
					self.didTryFetch = true
					self.loadData()
				} else {
					let alert = AlertFactory.makeGeneralNetworkingError()
					self.present(alert, animated: true, completion: nil)
				}
			}
			self.tableView.reloadDataAnimated()
		} else {
			self.tableView.reloadDataAnimated()
		}
	}

	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.items.isEmpty ? 1 : self.items.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemTableViewCell.reuseIdentifier, for: indexPath) as? MenuItemTableViewCell else { fatalError("Unexpected cell type") }
		if self.items.isEmpty {
			cell.setupWithNoData()
		} else {
			let menuItem = self.items[indexPath.row]
			cell.setup(menuItem: menuItem)
		}
		return cell
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		0
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		nil
	}
}
