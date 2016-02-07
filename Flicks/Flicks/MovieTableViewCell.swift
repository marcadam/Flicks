//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by Marc Anderson on 2/2/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        let backgroundView = UIView()
        backgroundView.backgroundColor = Constants.tableCellHighlightColor
        selectedBackgroundView = backgroundView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        titleLabel.highlightedTextColor = UIColor.whiteColor()
        overviewLabel.highlightedTextColor = UIColor.whiteColor()
    }

    override func prepareForReuse() {
        posterImageView.image = nil
        titleLabel.text = nil
        overviewLabel.text = nil
    }
}
