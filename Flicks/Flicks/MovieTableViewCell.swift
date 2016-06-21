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

    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview

            if let posterURL = movie.smallPosterURL {
                let imageRequest = NSURLRequest(URL: posterURL)
                posterImageView.setImageWithURLRequest(
                    imageRequest,
                    placeholderImage: nil,
                    success: { (imageRequest, imageResponse, image) -> Void in

                        // imageResponse will be nil if the image is cached
                        if imageResponse != nil {
                            self.posterImageView.alpha = 0.0
                            self.posterImageView.image = image
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                self.posterImageView.alpha = 1.0
                            })
                        } else {
                            self.posterImageView.image = image
                        }
                    },
                    failure: { (imageRequest, imageResponse, error) -> Void in
                        // do something for the failure condition
                })
            } else {
                posterImageView.image = UIImage(named: "PosterPlaceholderSmall")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.flicksCellHighlightColor()
        selectedBackgroundView = backgroundView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        titleLabel.highlightedTextColor = UIColor.whiteColor()
        overviewLabel.highlightedTextColor = UIColor.whiteColor()
    }
}
