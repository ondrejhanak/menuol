//
//  VenuesTableViewController.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit

private let kVenueCellIdentifier = "VenueCell"

final class VenuesTableViewController: UITableViewController, UISearchResultsUpdating, VenueTableViewCellDelegate {

	// MARK: - Properties

	public var venueManager: VenueManager!
	public weak var coordinatorDelegate: VenuesViewControllerDelegate?
	private var result = [Venue]()
	private var searchController: UISearchController!
	private var refresher: UIRefreshControl!

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUI()
		self.fetchData()
	}

	// MARK: - UISearchResultsUpdating

	func updateSearchResults(for searchController: UISearchController) {
		self.loadData(nameFilter: searchController.searchBar.text)
	}

	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.result.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: kVenueCellIdentifier, for: indexPath) as! VenueTableViewCell
		let venue = self.venue(for: indexPath)
		cell.setup(venue: venue)
		cell.delegate = self
		return cell
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let venue = self.venue(for: indexPath)
		self.coordinatorDelegate?.didSelect(venue: venue)
	}

	// MARK: - Private

	private func setupUI() {
		self.searchController = UISearchController(searchResultsController: nil)
		self.searchController.searchResultsUpdater = self
		self.searchController.dimsBackgroundDuringPresentation = false
		self.definesPresentationContext = true
		self.tableView.tableHeaderView = self.searchController.searchBar
		self.tableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1) // same as default search bar background
		self.tableView.tableFooterView = UIView()
		self.refresher = UIRefreshControl()
		self.refresher.tintColor = .black
		self.refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
		self.tableView?.addSubview(refresher)
	}

	private func venue(for indexPath: IndexPath) -> Venue {
		return self.result[indexPath.row]
	}
	
	private func fetchData() {
		let today = Date()
		self.venueManager.updateVenuesAndMenu(for: today) { result in
			self.refresher.endRefreshing()
			switch result {
			case .success:
				self.loadData()
			case .failure:
				// TODO: handle error
				()
			}
		}
	}

	private func loadData(nameFilter: String? = nil) {
		self.result = self.venueManager.find(name: nameFilter ?? "")
		self.tableView.reloadDataAnimated()
	}

	@objc private func refreshData() {
		self.fetchData()
	}

	// MARK: - VenueTableViewCellDelegate

	internal func venueCellDidTapFavorite(_ cell: VenueTableViewCell) {
		self.venueManager.toggleFavorite(cell.venue)
		self.loadData(nameFilter: searchController.searchBar.text)
	}

}
