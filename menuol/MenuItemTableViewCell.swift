//
//  MenuItemTableViewCell.swift
//  menuol
//
//  Created by Ondrej Hanak on 19/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit

final class MenuItemTableViewCell: UITableViewCell {

	@IBOutlet var orderLabel: UILabel!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var priceLabel: UILabel!

	override func prepareForReuse() {
		super.prepareForReuse()
		self.orderLabel.text = nil
	}

	func setup(menuItem: MenuItemObject) {
		self.orderLabel?.text = menuItem.orderDescription
		self.titleLabel?.text = menuItem.title
		self.priceLabel?.text = menuItem.priceDescription
	}

	func setupAsNoDataCell() {
		self.orderLabel?.text = nil
		self.titleLabel?.text = "Restaurace nedodala aktuální údaje"
		self.priceLabel?.text = nil
	}

}
