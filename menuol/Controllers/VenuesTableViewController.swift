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
	public weak var coordinatorDelegate: VenuesViewControllerDelegate?
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
		self.setupUI()
		self.fetchData()
	}

	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.result.count
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
		self.coordinatorDelegate?.didSelect(venue: venue)
	}

	// MARK: - Private

	private func setupUI() {
		self.title = "Polední menu"
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationItem.searchController = self.searchController
		self.definesPresentationContext = true
		self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.register(VenueTableViewCell.self, forCellReuseIdentifier: VenueTableViewCell.reuseIdentifier)
		self.tableView.estimatedRowHeight = 60
		self.refreshControl = UIRefreshControl()
		self.refreshControl?.tintColor = .black
		self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
	}

	private func venue(for indexPath: IndexPath) -> Venue {
		self.result[indexPath.row]
	}

	private func fetchData() {
		let today = Date()
		self.venueManager.updateVenuesAndMenu(for: today) { result in
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
		self.result = self.venueManager.find(name: name)
		self.tableView.reloadDataAnimated()
	}

	@objc
	private func refreshData() {
		self.fetchData()
	}
}

// MARK: - VenueTableViewCellDelegate

extension VenuesTableViewController: VenueTableViewCellDelegate {
	internal func venueCellDidTapFavorite(_ cell: VenueTableViewCell) {
		self.venueManager.toggleFavorite(cell.venue)
		self.loadData(nameFilter: self.searchController.searchBar.text)
	}
}

// MARK: - UISearchResultsUpdating

extension VenuesTableViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		self.loadData(nameFilter: searchController.searchBar.text)
	}
}
