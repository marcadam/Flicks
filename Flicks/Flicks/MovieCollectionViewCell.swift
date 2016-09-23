//
//  MovieCollectionViewCell.swift
//  Flicks
//
//  Created by Marc Anderson on 2/5/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    var movie: Movie! {
        didSet {
            if let releaseDate = movie.releaseDate {
                releaseDateLabel.text = formatDate(releaseDate, format: .short)
            }

            if let rating = movie.voteAverage {
                ratingLabel.text = String(format: "%.1f", arguments: [rating])
            }

            if let posterURL = movie.smallPosterURL {
                let imageRequest = URLRequest(url: posterURL)
                posterImageView.setImageWith(
                    imageRequest,
                    placeholderImage: nil,
                    success: { (imageRequest, imageResponse, image) -> Void in

                        // imageResponse will be nil if the image is cached
                        if imageResponse != nil {
                            self.posterImageView.alpha = 0.0
                            self.posterImageView.image = image
                            UIView.animate(withDuration: 0.3, animations: { () -> Void in
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
                posterImageView.image = UIImage(named: "PosterPlaceholderLarge")
            }
        }
    }

    override func prepareForReuse() {
        posterImageView.image = nil
        releaseDateLabel.text = nil
        ratingLabel.text = nil
    }
}
