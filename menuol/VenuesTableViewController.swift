//
//  VenuesTableViewController.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit
import RealmSwift

private let kVenueCellIdentifier = "VenueCell"
private let kMenuSegue = "MenuSegue"

final class VenuesTableViewController: UITableViewController, UISearchResultsUpdating, VenueTableViewCellDelegate {

	// MARK: - Properties

	private var result: Results<VenueObject>!
	private var searchController: UISearchController!
	private var venuesManager: VenueManager!
	private var notificationToken: NotificationToken?

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		self.venuesManager = VenueManager.shared
		self.loadData()
		self.searchController = UISearchController(searchResultsController: nil)
		self.searchController.searchResultsUpdater = self
		self.searchController.dimsBackgroundDuringPresentation = false
		self.definesPresentationContext = true
		self.tableView.tableHeaderView = self.searchController.searchBar
		self.createNotificationToken()
	}

	deinit {
		self.notificationToken?.invalidate()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == kMenuSegue, let vc = segue.destination as? MenuTableViewController, let venue = sender as? VenueObject {
			vc.venue = venue
		}
	}

	// MARK: - UISearchResultsUpdating

	func updateSearchResults(for searchController: UISearchController) {
		self.loadData(nameFilter: searchController.searchBar.text)
		self.createNotificationToken()
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

	private func venue(for indexPath: IndexPath) -> VenueObject {
		return self.result[indexPath.row]
	}

	private func loadData(nameFilter: String? = nil) {
		self.result = self.venuesManager.find(name: nameFilter ?? "")
	}

	private func createNotificationToken() {
		self.notificationToken = self.result.observe { [weak self] (changes: RealmCollectionChange) in
			guard let tableView = self?.tableView else {
				return
			}
			switch changes {
			case .initial:
				tableView.reloadData()
			case .update(_, let deletions, let insertions, let modifications):
				tableView.beginUpdates()
				tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
				tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
				tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
				tableView.endUpdates()
			case .error(let error):
				fatalError("\(error)")
			}
		}
	}

	// MARK: - VenueTableViewCellDelegate

	internal func venueCellDidTapFavorite(_ cell: VenueTableViewCell) {
		try! cell.venue.realm?.write {
			cell.venue.isFavorited = !cell.venue.isFavorited
		}
	}

}
