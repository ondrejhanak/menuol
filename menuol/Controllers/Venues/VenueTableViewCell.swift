//
//  VenueTableViewCell.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

protocol VenueTableViewCellDelegate: AnyObject {
	func venueCellDidTapFavorite(_ cell: VenueTableViewCell)
}

final class VenueTableViewCell: UITableViewCell {
	static let reuseIdentifier = "VenueCell"
	weak var delegate: VenueTableViewCellDelegate?
	private(set) var venue: Venue!

	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .body)
		label.numberOfLines = 0
		label.textColor = .darkText
		label.adjustsFontForContentSizeCategory = true
		return label
	}()

	private lazy var subtitleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = UIFont.preferredFont(forTextStyle: .caption1)
		label.textColor = .darkText
		label.adjustsFontForContentSizeCategory = true
		return label
	}()

	private lazy var logoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	private lazy var favoriteImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.tintColor = .darkGray
		imageView.contentMode = .center
		imageView.isUserInteractionEnabled = true
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
		imageView.addGestureRecognizer(recognizer)
		return imageView
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
		logoImageView.kf.cancelDownloadTask()
		logoImageView.image = nil
		titleLabel.text = nil
		subtitleLabel.text = nil
	}

	// MARK: - Public

	func setup(venue: Venue, favourited: Bool) {
		self.venue = venue
		titleLabel.text = venue.name
		subtitleLabel.text = venue.menuTimeDescription
		if let time = venue.menuTimeDescription {
			subtitleLabel.accessibilityLabel = "Opening hours " + time
		} else {
			subtitleLabel.accessibilityLabel = nil
		}
		logoImageView.kf.setImage(with: venue.imageURL, placeholder: UIImage(color: .lightGray, size: CGSize(width: 50, height: 50)))
		setFavorited(favourited)
	}

	// MARK: - Private

	private func setupUI() {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		stack.alignment = .leading
		stack.distribution = .equalSpacing
		stack.spacing = 2
		stack.addArrangedSubview(titleLabel)
		stack.addArrangedSubview(subtitleLabel)
		contentView.addSubview(logoImageView)
		contentView.addSubview(stack)
		contentView.addSubview(favoriteImageView)

		logoImageView.snp.makeConstraints { make in
			make.width.height.equalTo(50)
			make.leading.equalTo(self.contentView.layoutMarginsGuide)
			make.centerY.equalToSuperview()
			make.top.bottom.greaterThanOrEqualToSuperview().inset(8).priority(.medium)
		}

		stack.snp.makeConstraints { make in
			make.leading.equalTo(self.logoImageView.snp.trailing).offset(10)
			make.trailing.equalTo(self.favoriteImageView.snp.leading)
			make.centerY.equalToSuperview()
			make.top.bottom.greaterThanOrEqualToSuperview().inset(8)
		}

		favoriteImageView.snp.makeConstraints { make in
			make.width.height.equalTo(44)
			make.trailing.equalToSuperview()
			make.centerY.equalToSuperview()
			make.top.bottom.greaterThanOrEqualToSuperview().inset(8).priority(.medium)
		}
	}

	private func setFavorited(_ favorited: Bool) {
		let imageName = favorited ? "heart.fill" : "heart"
		favoriteImageView.image = UIImage(systemName: imageName)
		favoriteImageView.accessibilityLabel = favorited ? "Remove \(venue.name) from favorites" : "Add \(venue.name) to favorites"
	}

	@objc
	private func favoriteTapped() {
		delegate?.venueCellDidTapFavorite(self)
	}
}
