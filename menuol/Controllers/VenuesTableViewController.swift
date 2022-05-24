//
//  VenuesTableViewController.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit

protocol VenuesViewControllerDelegate: AnyObject {
	func didSelect(venue: Venue)
}

final class VenuesTableViewController: UITableViewController {
	var venueManager: VenueManager
	weak var coordinatorDelegate: VenuesViewControllerDelegate?
	private var result: [Venue] = []
	private lazy var searchController: UISearchController = {
		let controller = UISearchController(searchResultsController: nil)
		controller.searchResultsUpdater = self
		return controller
	}()

	// MARK: - Lifecycle

	init(venueManager: VenueManager) {
		self.venueManager = venueManager
		super.init(style: .grouped)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		fetchData()
	}

	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		result.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: VenueTableViewCell.reuseIdentifier, for: indexPath) as? VenueTableViewCell else { fatalError("Unexpected cell type.") }
		let venue = self.venue(for: indexPath)
		cell.setup(venue: venue)
		cell.delegate = self
		return cell
	}

	// MARK: - UITableViewDelegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let venue = self.venue(for: indexPath)
		coordinatorDelegate?.didSelect(venue: venue)
	}

	// MARK: - Private

	private func setupUI() {
		title = "Polední menu"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.searchController = searchController
		definesPresentationContext = true
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(VenueTableViewCell.self, forCellReuseIdentifier: VenueTableViewCell.reuseIdentifier)
		tableView.estimatedRowHeight = 60
		refreshControl = UIRefreshControl()
		refreshControl?.tintColor = .black
		refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
	}

	private func venue(for indexPath: IndexPath) -> Venue {
		result[indexPath.row]
	}

	private func fetchData() {
		let today = Date()
		venueManager.updateVenuesAndMenu(for: today) { result in
			self.refreshControl?.endRefreshing()
			switch result {
			case .success:
				self.loadData()
			case .failure:
				let alert = AlertFactory.makeGeneralNetworkingError()
				self.present(alert, animated: true, completion: nil)
			}
		}
	}

	private func loadData(nameFilter: String? = nil) {
		let name = nameFilter ?? ""
		result = venueManager.find(name: name)
		tableView.reloadDataAnimated()
	}

	@objc
	private func refreshData() {
		fetchData()
	}
}

// MARK: - VenueTableViewCellDelegate

extension VenuesTableViewController: VenueTableViewCellDelegate {
	internal func venueCellDidTapFavorite(_ cell: VenueTableViewCell) {
		venueManager.toggleFavorite(cell.venue)
		loadData(nameFilter: searchController.searchBar.text)
	}
}

// MARK: - UISearchResultsUpdating

extension VenuesTableViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		loadData(nameFilter: searchController.searchBar.text)
	}
}
