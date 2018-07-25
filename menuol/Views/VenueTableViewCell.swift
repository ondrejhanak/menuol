//
//  VenueTableViewCell.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit
import SDWebImage

protocol VenueTableViewCellDelegate: class {
	func venueCellDidTapFavorite(_ cell: VenueTableViewCell)
}

final class VenueTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var favoriteImageView: UIImageView!
	public weak var delegate: VenueTableViewCellDelegate?
	private (set) var venue: Venue!

	// MARK: - Lifecycle

	override func awakeFromNib() {
		self.logoImageView?.contentMode = .scaleAspectFit
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
		self.favoriteImageView.addGestureRecognizer(recognizer)
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		self.setFavorited(false)
	}

	// MARK: - Public

	func setup(venue: Venue) {
		self.venue = venue
		self.titleLabel?.text = venue.name
		self.subtitleLabel?.text = venue.menuTimeDescription
		self.logoImageView?.sd_setImage(with: venue.imageURL, placeholderImage: UIImage(color: .lightGray, size: CGSize(width: 50, height: 50)))
		self.setFavorited(venue.isFavorited)
	}

	// MARK: - Private

	private func setFavorited(_ favorited: Bool) {
		let alpha: CGFloat = favorited ? 0.7 : 0.1
		self.favoriteImageView.alpha = alpha
	}

	@objc private func favoriteTapped() {
		self.delegate?.venueCellDidTapFavorite(self)
	}

}
