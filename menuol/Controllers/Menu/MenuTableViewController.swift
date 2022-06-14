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
	private var date = Date()

	// MARK: - Lifecycle

	init(venue: Venue) {
		self.venue = venue
		super.init(style: .grouped)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		loadData()
	}

	// MARK: - Private

	private func setupUI() {
		navigationItem.largeTitleDisplayMode = .never
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 65
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
		tableView.register(MenuItemTableViewCell.self, forCellReuseIdentifier: MenuItemTableViewCell.reuseIdentifier)
	}

	private func loadData() {
		title = DateFormatter.czechDateString(from: date).capitalizingFirstLetter()
		tableView.reloadDataAnimated()
	}

	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		venue.menuItems.isEmpty ? 1 : venue.menuItems.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemTableViewCell.reuseIdentifier, for: indexPath) as? MenuItemTableViewCell else { fatalError("Unexpected cell type") }
		if venue.menuItems.isEmpty {
			cell.setupWithNoData()
		} else {
			let menuItem = venue.menuItems[indexPath.row]
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
