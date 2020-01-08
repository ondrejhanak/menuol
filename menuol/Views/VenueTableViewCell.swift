//
//  VenueTableViewCell.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Kingfisher
import UIKit

protocol VenueTableViewCellDelegate: AnyObject {
	func venueCellDidTapFavorite(_ cell: VenueTableViewCell)
}

final class VenueTableViewCell: UITableViewCell {
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var subtitleLabel: UILabel!
	@IBOutlet var logoImageView: UIImageView!
	@IBOutlet var favoriteImageView: UIImageView!
	public weak var delegate: VenueTableViewCellDelegate?
	private(set) var venue: Venue!

	// MARK: - Lifecycle

	override func awakeFromNib() {
		super.awakeFromNib()
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.favoriteTapped))
		self.favoriteImageView.addGestureRecognizer(recognizer)
	}

	// MARK: - Public

	public func setup(venue: Venue) {
		self.venue = venue
		self.titleLabel?.text = venue.name
		self.subtitleLabel?.text = venue.menuTimeDescription
		if let time = venue.menuTimeDescription {
			self.subtitleLabel?.accessibilityLabel = "Opening hours " + time
		} else {
			self.subtitleLabel?.accessibilityLabel = nil
		}
		self.logoImageView?.kf.setImage(with: venue.imageURL, placeholder: UIImage(color: .lightGray, size: CGSize(width: 50, height: 50)))
		self.setFavorited(venue.isFavorited)
	}

	// MARK: - Private

	private func setFavorited(_ favorited: Bool) {
		let alpha: CGFloat = favorited ? 0.7 : 0.1
		self.favoriteImageView.alpha = alpha
		self.favoriteImageView.accessibilityLabel = favorited ? "Remove \(self.venue.name) from favorites" : "Add \(self.venue.name) to favorites"
	}

	@objc private func favoriteTapped() {
		self.delegate?.venueCellDidTapFavorite(self)
	}
}
