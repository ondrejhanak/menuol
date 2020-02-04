//
//  MenuItemTableViewCell.swift
//  menuol
//
//  Created by Ondrej Hanak on 19/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit

final class MenuItemTableViewCell: UITableViewCell {
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var priceLabel: UILabel!

	static let noDataText = "Restaurace nedodala aktuální údaje"

	// MARK: - Lifecycle

	override func prepareForReuse() {
		super.prepareForReuse()
		self.clearUI()
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		self.clearUI()
	}

	// MARK: - Private

	private func clearUI() {
		self.titleLabel.text = nil
		self.priceLabel.text = nil
	}

	// MARK: - Public

	public func setup(menuItem: MenuItem) {
		self.titleLabel?.text = menuItem.title
		self.priceLabel?.text = menuItem.priceDescription
	}

	public func setupWithNoData() {
		self.titleLabel?.text = MenuItemTableViewCell.noDataText
	}
}
