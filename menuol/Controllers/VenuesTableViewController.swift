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

final class VenuesTableViewController: UITableViewController, UISearchResultsUpdating, VenueTableViewCellDelegate {

	// MARK: - Properties

	private var result = [VenueObject]()
	private var searchController: UISearchController!
	private var venuesManager = VenueManager()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUI()
		self.fetchData()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == kMenuSegue, let vc = segue.destination as? MenuTableViewController, let venue = sender as? VenueObject {
			vc.venue = venue
			vc.venueManager = self.venuesManager
		}
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
		self.performSegue(withIdentifier: kMenuSegue, sender: venue)
	}

	// MARK - Private

	private func setupUI() {
		self.searchController = UISearchController(searchResultsController: nil)
		self.searchController.searchResultsUpdater = self
		self.searchController.dimsBackgroundDuringPresentation = false
		self.definesPresentationContext = true
		self.tableView.tableHeaderView = self.searchController.searchBar
		self.tableView.tableFooterView = UIView()
	}

	private func venue(for indexPath: IndexPath) -> VenueObject {
		return self.result[indexPath.row]
	}
	
	private func fetchData() {
		let today = Date()
		self.venuesManager.updateVenuesAndMenu(for: today) { result in
			switch result {
			case .success(_):
				self.loadData()
			case .failure(_):
				// TODO: handle error
				()
			}
		}
	}

	private func loadData(nameFilter: String? = nil) {
		self.result = self.venuesManager.find(name: nameFilter ?? "")
		self.tableView.reloadDataAnimated()
	}

	// MARK: - VenueTableViewCellDelegate

	internal func venueCellDidTapFavorite(_ cell: VenueTableViewCell) {
		self.venuesManager.toggleFavorite(cell.venue)
		self.loadData(nameFilter: searchController.searchBar.text)
	}

}
