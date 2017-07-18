//
//  VenueTableViewCell.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit
import SDWebImage

final class VenueTableViewCell: UITableViewCell {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var subtitleLabel: UILabel!
	@IBOutlet var logoImageView: UIImageView!

	override func awakeFromNib() {
		self.logoImageView?.contentMode = .scaleAspectFit
	}

	func setup(venue: VenueObject) {
		self.titleLabel?.text = venue.name
		self.subtitleLabel?.text = venue.menuTimeDescription
		self.logoImageView?.sd_setImage(with: venue.imageURL, placeholderImage: UIImage(color: .lightGray, size: CGSize(width: 50, height: 50)))
	}

}
