//
//  MenuItemTableViewCell.swift
//  menuol
//
//  Created by Ondrej Hanak on 19/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit

final class MenuItemTableViewCell: UITableViewCell {
	static let reuseIdentifier = "MenuItemCell"
	static let noDataText = "Restaurace nedodala aktuální údaje"

	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .body)
		label.numberOfLines = 0
		label.textColor = .darkText
		label.adjustsFontForContentSizeCategory = true
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var priceLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .caption1)
		label.textColor = .darkText
		label.adjustsFontForContentSizeCategory = true
		label.translatesAutoresizingMaskIntoConstraints = false
		label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		return label
	}()

	// MARK: - Lifecycle

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		titleLabel.text = nil
		priceLabel.text = nil
	}

	// MARK: - Private

	private func setupUI() {
		contentView.addSubview(titleLabel)
		contentView.addSubview(priceLabel)

		titleLabel.snp.makeConstraints { make in
			make.leading.equalTo(self.contentView.layoutMarginsGuide)
			make.top.bottom.equalToSuperview().inset(8)
			make.centerY.equalToSuperview()
		}

		priceLabel.snp.makeConstraints { make in
			make.leading.greaterThanOrEqualTo(self.titleLabel.snp.trailing).offset(10)
			make.trailing.equalTo(self.contentView.layoutMarginsGuide)
			make.centerY.equalToSuperview()
		}
	}

	// MARK: - Public

	func setup(menuItem: MenuItem) {
		titleLabel.text = menuItem.title
		priceLabel.text = menuItem.priceDescription
	}

	func setupWithNoData() {
		titleLabel.text = MenuItemTableViewCell.noDataText
		priceLabel.text = nil
	}
}
